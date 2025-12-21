import 'package:dio/dio.dart';
import './constants.dart';
import '../../models/weather/weather_models.dart';

// 和风天气服务类
class QWeatherService {
  static final QWeatherService _instance = QWeatherService._internal();
  factory QWeatherService() => _instance;
  
  late Dio _dio;
  
  QWeatherService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: QWeatherConstants.baseUrl,
        headers: QWeatherConstants.headers,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    
    // 添加请求拦截器
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('请求: ${options.uri}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('响应: ${response.statusCode} ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('错误: ${e.message}');
        return handler.next(e);
      },
    ));
  }
  
  // 获取实时天气
  Future<WeatherNowResponse> getWeatherNow({required String location}) async {
    try {
      print('准备请求实时天气API...');
      print('请求URL: ${QWeatherConstants.baseUrl}${QWeatherConstants.weatherNow}');
      print('请求参数: location=$location');
      print('请求头: ${QWeatherConstants.headers}');
      
      final response = await _dio.get(
        QWeatherConstants.weatherNow,
        queryParameters: {'location': location},
      );
      
      print('API请求成功，状态码: ${response.statusCode}');
      print('响应数据: ${response.data}');
      
      return WeatherNowResponse.fromJson(response.data);
    } catch (e) {
      print('获取实时天气失败: $e');
      if (e is DioException) {
        print('Dio错误类型: ${e.type}');
        print('错误消息: ${e.message}');
        print('请求URL: ${e.requestOptions.uri}');
        print('响应状态码: ${e.response?.statusCode}');
        print('响应数据: ${e.response?.data}');
        print('错误堆栈: ${e.stackTrace}');
      }
      rethrow;
    }
  }
  
  // 获取3天天气预报
  Future<WeatherForecastResponse> getWeather3d({required String location}) async {
    try {
      final response = await _dio.get(
        QWeatherConstants.weather3d,
        queryParameters: {'location': location},
      );
      return WeatherForecastResponse.fromJson(response.data);
    } catch (e) {
      print('获取3天天气预报失败: $e');
      rethrow;
    }
  }
  
  // 获取7天天气预报
  Future<WeatherForecastResponse> getWeather7d({required String location}) async {
    try {
      final response = await _dio.get(
        QWeatherConstants.weather7d,
        queryParameters: {'location': location},
      );
      return WeatherForecastResponse.fromJson(response.data);
    } catch (e) {
      print('获取7天天气预报失败: $e');
      rethrow;
    }
  }
  
  // 获取10天天气预报
  Future<WeatherForecastResponse> getWeather10d({required String location}) async {
    try {
      final response = await _dio.get(
        QWeatherConstants.weather10d,
        queryParameters: {'location': location},
      );
      return WeatherForecastResponse.fromJson(response.data);
    } catch (e) {
      print('获取10天天气预报失败: $e');
      rethrow;
    }
  }
  
  // 获取15天天气预报
  Future<WeatherForecastResponse> getWeather15d({required String location}) async {
    try {
      final response = await _dio.get(
        QWeatherConstants.weather15d,
        queryParameters: {'location': location},
      );
      return WeatherForecastResponse.fromJson(response.data);
    } catch (e) {
      print('获取15天天气预报失败: $e');
      rethrow;
    }
  }
  
  // 获取24小时天气预报
  Future<Weather24hResponse> getWeather24h({required String location}) async {
    try {
      final response = await _dio.get(
        QWeatherConstants.weather24h,
        queryParameters: {'location': location},
      );
      return Weather24hResponse.fromJson(response.data);
    } catch (e) {
      print('获取24小时天气预报失败: $e');
      rethrow;
    }
  }
}
