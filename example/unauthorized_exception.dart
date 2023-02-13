class UnauthorizedException implements Exception {
  const UnauthorizedException([String? message]) : _message = message;

  final String? _message;

  String get message => _message ?? 'Missing or invalid credentials';

  @override
  String toString() => 'UnauthorizedException: $message';
}
