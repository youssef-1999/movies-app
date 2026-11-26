import 'package:dio/dio.dart';

/// One simple exception for the whole app.
/// It carries a message that is safe to show to the user.
class AppException implements Exception {
  final String message;

  const AppException(this.message);

  /// Turns a Dio error into a friendly message.
  factory AppException.fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const AppException('Connection timed out. Please try again.');
      case DioExceptionType.connectionError:
        return const AppException('No internet connection.');
      case DioExceptionType.badResponse:
        return AppException(_messageFromStatusCode(e.response?.statusCode));
      case DioExceptionType.cancel:
        return const AppException('The request was cancelled.');
      default:
        return const AppException('Something went wrong. Please try again.');
    }
  }

  static String _messageFromStatusCode(int? code) {
    if (code == 404) return 'Nothing was found.';
    if (code == 429) return 'Too many requests. Please wait a moment.';
    if (code != null && code >= 500) {
      return 'The server has a problem. Please try again later.';
    }
    return 'Something went wrong. Please try again.';
  }

  @override
  String toString() => message;
}
