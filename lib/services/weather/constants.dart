// 和风天气API常量
class QWeatherConstants {
  // API密钥
  static const String apiKey = '1aefd5adb034412b9bc9e0e3800d1c6f';
  
  // API基础URL
  static const String baseUrl = 'https://mw2k5nprk7.re.qweatherapi.com/v7';
  
  // 请求头
  static const Map<String, String> headers = {
    'X-QW-Api-Key': apiKey,
    'Content-Type': 'application/json',
  };
  
  // API端点
  static const String weatherNow = '/weather/now';
  static const String weather3d = '/weather/3d';
  static const String weather7d = '/weather/7d';
  static const String weather10d = '/weather/10d';
  static const String weather15d = '/weather/15d';
  static const String weather24h = '/weather/24h';
}
