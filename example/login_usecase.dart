import 'package:dart_usecase/src/usecase.dart';

class LoginInput {
  const LoginInput({required this.email, required this.password});

  final String email;
  final String password;
}

class LoginUsecase extends UseCase<LoginInput, String> {
  const LoginUsecase();

  @override
  Future<String> execute(LoginInput? params) async {
    // final accessToken = await _authenticationRepository.login(params!.email, params.password);
    // final session = await _sessionRepository.saveToken(accessToken);
    // ...
    return '';
  }
}
