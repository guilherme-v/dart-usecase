import 'package:dart_usecase/usecase.dart';

import 'login_usecase.dart';
import 'unauthorized_exception.dart';
import 'unauthorized_exception_recovery_strategy.dart';

void main() async {
  // 1. Create the Usecase Executor
  // 2. Add any Recovery Strategy you want
  final usecaseExecutor = UsecaseExecutor()
    ..addRecoveryStrategy(
      UnauthorizedExceptionRecoveryStrategy(),
    );

  // 3. Create the usercase
  final loginUsecase = LoginUsecase();

  // 4 Execute the usercase
  await usecaseExecutor.execute(
    usecase: loginUsecase,
    params: LoginInput(email: 'my@email.com', password: 'password'),
    onSuccess: (_) {
      print('SUCCESS!');
      // emit(...); Update UI properly
    },
    onError: (e) {
      print('FAILED');
      // emit(...); Update UI properly
    },
    dontRethrowWhen: (e) {
      // The following Exception will be 'consumed' by the 'usecaseExecutor'
      // and won't be rethrown. Any other exception will be rethrown normally
      return e is UnauthorizedException;
    },
  );
}
