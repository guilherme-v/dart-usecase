class UsecaseExecutorCancelable {
  UsecaseExecutorCancelable() : _cancelled = false;

  bool _cancelled;

  void cancel() {
    _cancelled = true;
  }

  bool get isCancelled => _cancelled;
}
