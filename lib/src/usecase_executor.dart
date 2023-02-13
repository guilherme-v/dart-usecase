import 'dart:async';

import 'package:dart_usecase/src/usecase.dart';

import 'usecase_executor_cancelable.dart';
import 'usecase_recovery_strategy.dart';

typedef RethrowError = bool Function(Exception);
typedef OnError = void Function(Exception);
typedef OnSuccess<T> = void Function(T);

class UsecaseExecutor {
  UsecaseExecutor();

  final _cancelable = UsecaseExecutorCancelable();
  final _recoveryStrategies = List<UsecaseRecoveryStrategy>.empty(
    growable: true,
  );

  Future<OUT?> execute<IN, OUT>({
    required UseCase<IN, OUT> usecase,
    OnSuccess<OUT>? onSuccess,
    OnError? onError,
    RethrowError? dontRethrowWhen,
    IN? params,
  }) async {
    Future<OUT?> run() async {
      if (_isClosed) return null;
      final result = await usecase.execute(params);
      if (_isClosed) return null;
      onSuccess?.call(result);
      return result;
    }

    bool shouldRethrow(Exception e) {
      if (_isClosed) return false;
      if (dontRethrowWhen == null) return true;
      final shouldIgnoreException = dontRethrowWhen.call(e);
      if (shouldIgnoreException) return false;
      return true;
    }

    Future<OUT?> tryToRecoverWithStrategy(UsecaseRecoveryStrategy stg) async {
      try {
        await stg.run();
        return await run();
      } on Exception catch (e) {
        onError?.call(e);
        if (shouldRethrow(e)) rethrow;
        return null;
      }
    }

    try {
      return await run();
    } on Exception catch (e) {
      final strategy = _getRecoveryStrategy(e);
      if (strategy != null) return tryToRecoverWithStrategy(strategy);
      onError?.call(e);
      if (shouldRethrow(e)) rethrow;
      return null;
    }
  }

  void addRecoveryStrategy(UsecaseRecoveryStrategy strategy) {
    _recoveryStrategies.add(strategy);
  }

  void close() {
    _cancelable.cancel();
  }

  UsecaseRecoveryStrategy? _getRecoveryStrategy(Exception e) {
    for (final s in _recoveryStrategies) {
      if (s.shouldRecover(e)) return s;
    }
    return null;
  }

  bool get _isClosed => _cancelable.isCancelled;
}
