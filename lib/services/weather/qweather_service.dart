import 'package:dio/dio.dart';
import 'package:flutter_oppo_weather/models/city_top_response.dart';
import 'package:flutter_oppo_weather/models/geo_city_response.dart';
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
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('错误: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  // 获取实时天气
  Future<WeatherNowResponse> getWeatherNow({required String id}) async {
    try {
      final response = await _dio.get(
        QWeatherConstants.weatherNow,
        queryParameters: {'location': id},
      );
      return WeatherNowResponse.fromJson(response.data);
    } catch (e) {
      print('获取实时天气失败: $e');
      if (e is DioException) {
        print('Dio错误类型: ${e.type}');
        print('错误消息: ${e.message}');
      }
      rethrow;
    }
  }

  // 获取3天天气预报
  Future<WeatherForecastResponse> getWeather3d({
    required String location,
  }) async {
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
  Future<WeatherForecastResponse> getWeather7d({
    required String location,
  }) async {
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
  Future<WeatherForecastResponse> getWeather10d({
    required String location,
  }) async {
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
  Future<WeatherForecastResponse> getWeather15d({
    required String location,
  }) async {
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

  // 获取热门城市列表
  Future<CityTopResponse> getTopCityList() async {
    try {
      final service = QWeatherService();
      final response = await service._dio.get(QWeatherConstants.geoTop);
      return CityTopResponse.fromJson(response.data);
    } catch (e) {
      print('获取热门城市列表失败: $e');
      rethrow;
    }
  }

  // 搜索城市
  Future<GeoCityResponse> searchCity({required String keyword}) async {
    try {
      final response = await _dio.get(
        QWeatherConstants.geoCity,
        queryParameters: {'location': keyword},
      );
      return GeoCityResponse.fromJson(response.data);
    } catch (e) {
      print('搜索城市失败: $e');
      if (e is DioException) {
        print('Dio错误类型: ${e.type}');
        print('错误消息: ${e.message}');
      }
      rethrow;
    }
  }
}
