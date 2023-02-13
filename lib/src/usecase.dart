abstract class UseCase<INPUT, OUTPUT> {
  const UseCase();

  Future<OUTPUT> execute(INPUT? params);
}
