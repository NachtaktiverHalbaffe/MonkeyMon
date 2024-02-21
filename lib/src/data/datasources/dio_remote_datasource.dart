import 'package:dio/dio.dart';
import 'package:monkey_mon/src/core/utils/logger.dart';
import 'package:monkey_mon/src/exceptions/network_exception.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

abstract class DioRemoteDatasource {
  late final Dio dio;

  DioRemoteDatasource(
      {required String baseUrl,
      Map<String, dynamic>? headers,
      Duration? sendTimeout,
      Duration? connectTimeout,
      Duration? receiveTimeout}) {
    dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        headers: headers,
        sendTimeout: sendTimeout,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout));

    initializeInterceptors();
  }

  void setBaseUrl(String baseUrl) {
    dio.options.baseUrl = baseUrl;
  }

  void initializeInterceptors() {
    dio.interceptors.add(
      TalkerDioLogger(
        settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printRequestData: true,
            printResponseHeaders: true,
            printResponseMessage: true,
            printResponseData: true),
      ),
    );
  }

  Future<Response<String>> performGet(String endPoint) async {
    Response<String> response;

    try {
      response = await dio.get(endPoint);
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout ||
              DioExceptionType.receiveTimeout ||
              DioExceptionType.sendTimeout:
          throw NetworkExcpetion(e.message, type: NetworkExceptionType.timeout);
        case DioExceptionType.badCertificate ||
              DioExceptionType.connectionError ||
              DioExceptionType.cancel:
          throw NetworkExcpetion(e.message,
              type: NetworkExceptionType.connectionError);
        case DioExceptionType.badResponse:
          throw NetworkExcpetion(e.message,
              type: NetworkExceptionType.badResponse);
        default:
          throw NetworkExcpetion(e.message, type: NetworkExceptionType.unknown);
      }
    }

    return response;
  }

  Future<Response<String>> performPost(String endPoint, Object payload) async {
    Response<String> response;

    try {
      response = await dio.post<String>(endPoint, data: payload);
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout ||
              DioExceptionType.receiveTimeout ||
              DioExceptionType.sendTimeout:
          throw NetworkExcpetion(e.message, type: NetworkExceptionType.timeout);
        case DioExceptionType.badCertificate ||
              DioExceptionType.connectionError ||
              DioExceptionType.cancel:
          throw NetworkExcpetion(e.message,
              type: NetworkExceptionType.connectionError);
        case DioExceptionType.badResponse:
          throw NetworkExcpetion(e.message,
              type: NetworkExceptionType.badResponse);
        default:
          throw NetworkExcpetion(e.message, type: NetworkExceptionType.unknown);
      }
    }

    return response;
  }

  Future<Response<String>> performPut(String endPoint, Object payload) async {
    Response<String> response;

    try {
      response = await dio.put<String>(endPoint, data: payload);
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout ||
              DioExceptionType.receiveTimeout ||
              DioExceptionType.sendTimeout:
          throw NetworkExcpetion(e.message, type: NetworkExceptionType.timeout);
        case DioExceptionType.badCertificate ||
              DioExceptionType.connectionError ||
              DioExceptionType.cancel:
          throw NetworkExcpetion(e.message,
              type: NetworkExceptionType.connectionError);
        case DioExceptionType.badResponse:
          throw NetworkExcpetion(e.message,
              type: NetworkExceptionType.badResponse);
        default:
          throw NetworkExcpetion(e.message, type: NetworkExceptionType.unknown);
      }
    }

    return response;
  }
}
