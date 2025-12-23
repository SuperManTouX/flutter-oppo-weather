// 城市模型类
import '../services/weather/weather_service.dart';
import './weather/now.dart';
import './weather/weather_now_response.dart';

class City {
  // 城市名称
  final String name;
  
  // 城市位置码 (和风天气API使用的location参数)
  final String location;
  
  // 当前天气数据
  final Now? now;
  
  // 构造函数
  const City({
    required this.name,
    required this.location,
    this.now,
  });
  
  // 静态异步方法 - 创建包含天气数据的City实例
  static Future<City> createWithWeather({required String name, required String location}) async {
    try {
      final weatherService = QWeatherService();
      final WeatherNowResponse weatherNowResponse = await weatherService.getWeatherNow(location: location);
      return City(
        name: name,
        location: location,
        now: weatherNowResponse.now,
      );
    } catch (e) {
      print('获取天气数据失败: $e');
      rethrow;
    }
  }
}
