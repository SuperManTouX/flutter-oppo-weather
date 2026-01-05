// 城市模型类
import 'package:json_annotation/json_annotation.dart';
import '../services/weather/qweather_service.dart';
import './weather/now.dart';
import './weather/weather_now_response.dart';

part 'display_city.g.dart';

@JsonSerializable()
class DisplayCity {
  // 城市名称
  final String name;

  // 城市位置码 (和风天气API使用的location参数)
  final String id;

  // 纬度
  final String latitude;

  // 经度
  final String longitude;

  // 当前天气数据
  final Now? now;

  // 构造函数
  const DisplayCity({required this.name, required this.id, required this.latitude, required this.longitude, this.now});

  // 静态异步方法 - 创建包含天气数据的City实例
  static Future<DisplayCity> createWithWeather({
    required String name,
    required String id,
    required String latitude,
    required String longitude,
  }) async {
    try {
      final weatherService = QWeatherService();
      final WeatherNowResponse weatherNowResponse = await weatherService
          .getWeatherNow(id: id);
      return DisplayCity(name: name, id: id, latitude: latitude, longitude: longitude, now: weatherNowResponse.now);
    } catch (e) {
      print('获取天气数据失败: $e');
      rethrow;
    }
  }

  // JSON序列化相关方法
  factory DisplayCity.fromJson(Map<String, dynamic> json) =>
      _$DisplayCityFromJson(json);

  Map<String, dynamic> toJson() => _$DisplayCityToJson(this);
}
