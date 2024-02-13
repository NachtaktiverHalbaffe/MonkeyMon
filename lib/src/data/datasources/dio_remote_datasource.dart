import 'package:dio/dio.dart';
import 'package:monkey_mon/src/exceptions/network_exception.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

abstract class DioRemoteDatasource {
  late final Dio dio;

  DioRemoteDatasource(
      {required String baseUrl, Map<String, dynamic>? headers}) {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: headers,
    ));

    initializeInterceptors();
  }

  void initializeInterceptors() {
    // dio.interceptors.add(InterceptorsWrapper(
    //   onError: (error, handler) {
    //     print(error.message);
    //   },
    //   onRequest: (options, handler) {
    //     print("Request Uri: ${options.uri}");
    //   },
    //   onResponse: (response, handler) {
    //     print("Response: ${response.data}");
    //   },
    // ));

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
      print(e);
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
        default:
          throw NetworkExcpetion(e.message, type: NetworkExceptionType.unknown);
      }
    }

    if (response.statusCode == 200) {
      return response;
    } else {
      throw NetworkExcpetion(
          "Wrong statuscode (expected 200, got ${response.statusCode})",
          type: NetworkExceptionType.badResponse);
    }
  }
}
