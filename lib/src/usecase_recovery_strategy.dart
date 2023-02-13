abstract class UsecaseRecoveryStrategy {
  bool shouldRecover(Exception e);

  Future<void> run();
}
