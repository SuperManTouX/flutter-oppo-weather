// 和风天气API常量
class QWeatherConstants {
  // API密钥
  static const String apiKey = '1aefd5adb034412b9bc9e0e3800d1c6f';
  
  // API基础URL
  static const String baseUrl = 'https://mw2k5nprk7.re.qweatherapi.com';
  
  // 请求头
  static const Map<String, String> headers = {
    'X-QW-Api-Key': apiKey,
    'Content-Type': 'application/json',
  };
  
  // API端点
  static const String geoCity = '/geo/v2/city/lookup'; // 城市查询
  static const String geoTop = '/geo/v2/city/top'; // 热门城市查询
  static const String weatherNow = '/v7/weather/now'; // 实时天气
  static const String weatherHistorical = '/v7/historical/weather'; // 历史天气
  static const String weather3d = '/v7/weather/3d'; // 3天天气
  static const String weather7d = '/v7/weather/7d'; // 7天天气
  static const String weather10d = '/v7/weather/10d'; // 10天天气
  static const String weather15d = '/v7/weather/15d'; // 15天天气
  static const String weather24h = '/v7/weather/24h'; // 24小时天气
  static const String airQualityCurrent = '/airquality/v1/current'; // 空气质量当前数据
}
