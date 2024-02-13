class NetworkExcpetion implements Exception {
  final String? message;
  final NetworkExceptionType? type;

  NetworkExcpetion(this.message, {this.type});

  @override
  String toString() {
    return '${type.toString()}: $message';
  }
}

enum NetworkExceptionType {
  /// Caused by a exceeded timeout of any kind
  timeout,

  /// When the request is cancelled, dio will throw a error with this type.
  cancel,

  /// When the response fails some validation e.g. wrong status code
  badResponse,

  /// Caused for example by a `xhr.onError` or SocketExceptions.
  connectionError,

  /// Default error type, Some other [Error]. In this case, you can use the
  /// [DioException.error] if it is not null.
  unknown,
}
