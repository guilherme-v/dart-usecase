import 'package:dart_usecase/src/usecase_recovery_strategy.dart';

import 'unauthorized_exception.dart';

class UnauthorizedExceptionRecoveryStrategy implements UsecaseRecoveryStrategy {
  const UnauthorizedExceptionRecoveryStrategy();

  @override
  Future<void> run() async {
    // final token = await _authenticationRepository.refreshAccessToken();
    // final session = await _sessionRepository.saveToken(token);
    // ...
  }

  @override
  bool shouldRecover(Exception e) {
    return e is UnauthorizedException;
  }
}
