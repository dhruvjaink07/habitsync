import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioService {
  static final DioService _instance = DioService._internal();
  factory DioService() => _instance;
  late Dio dio;

  DioService._internal() {
    final options = BaseOptions(
      baseUrl: 'http://192.168.248.114:5000',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    dio = Dio(options);

    // Adding Interceptors
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      final token = await _getAuthToken();
      print('Token being sent: $token');
      // Always set Accept header
      options.headers['Accept'] = 'application/json';
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      print('Request headers: ${options.headers}');
      return handler.next(options);
    }, onResponse: (response, handler) {
      // handle responses globally
      return handler.next(response);
    }, onError: (DioException e, handler) {
      // handle errors globally
      print('❌ Dio error: ${e.response?.statusCode} - ${e.message}');
      print('Error response data: ${e.response?.data}');
      return handler.next(e);
    }));
  }

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }
}
