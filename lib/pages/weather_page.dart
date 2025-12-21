import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/services/weather/weather_service.dart';
import 'package:flutter_oppo_weather/models/weather/weather_models.dart';
import 'package:flutter_oppo_weather/routes/index.dart';
import 'package:flutter_oppo_weather/widget/QIcon.dart';
import 'package:flutter_svg/svg.dart';

class WeatherPage extends StatefulWidget {
  // 城市位置码参数，默认为北京
  final String location;

  // 城市名称参数，默认为北京
  final String cityName;

  const WeatherPage({
    super.key,
    this.location = '101010100',
    this.cityName = '北京',
  });

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // 实时天气返回体
  WeatherNowResponse? _nowResponse;
  // 7天天气数据 [0]是今天的天气
  List<Daily>? _forecastData = [];
  // 逐小时天气数据
  List<Hourly>? _hourlyData = [];
  // 加载状态
  bool _isLoading = false;

  // 获取实时天气数据
  Future<void> _fetchWeatherData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final service = QWeatherService();
      final data = await service.getWeatherNow(location: widget.location);
      setState(() {
        _nowResponse = data;
        _isLoading = false;
      });
    } catch (e) {
      print('获取天气数据失败: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 获取七天的天气数据
  Future<void> _fetchWeatherForecast() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final service = QWeatherService();
      final data = await service.getWeather7d(location: widget.location);
      setState(() {
        _forecastData = data.daily;
        _isLoading = false;
      });
    } catch (e) {
      print('获取天气数据失败: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 获取24小时天气数据
  Future<void> _fetchWeather24h() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final service = QWeatherService();
      final data = await service.getWeather24h(location: widget.location);
      setState(() {
        _hourlyData = data.hourly;
        print('获取24小时天气数据: $_hourlyData');
        _isLoading = false;
      });
    } catch (e) {
      print('获取24小时天气数据失败: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // 自动获取天气数据
    _fetchWeatherData();
    // 自动获取7天天气数据
    _fetchWeatherForecast();
    // 自动获取24小时天气数据
    _fetchWeather24h();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('${widget.cityName}'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.favorites);
            },
            icon: const Icon(Icons.favorite_border),
            tooltip: '收藏列表',
          ),
          IconButton(
            onPressed: _fetchWeatherData,
            icon: const Icon(Icons.refresh),
            tooltip: '刷新数据',
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: _isLoading
              ? const CircularProgressIndicator()
              : _nowResponse != null
              ? _buildWeatherUI()
              : _buildErrorUI(),
        ),
      ),
    );
  }

  // 构建天气UI
  Widget _buildWeatherUI() {
    final now = _nowResponse!.now;
    final dayDetail = _forecastData![0];
    return Container(
      padding: const EdgeInsets.all(20),
      color: const Color.fromARGB(147, 127, 184, 231),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 天气图标和温度
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // // 天气图标 (使用占位符，实际项目中可以根据icon值显示对应的图标)
              // Container(
              //   width: 80,
              //   height: 80,
              //   decoration: BoxDecoration(
              //     color: Colors.blue.withOpacity(0.2),
              //     borderRadius: BorderRadius.circular(40),
              //   ),
              //   child: Center(
              //     child: Text(
              //       now.icon,
              //       style: const TextStyle(fontSize: 40),
              //     ),
              //   ),
              // ),
              // 温度
              Column(
                children: [
                  Text(
                    '${now.temp}°',
                    style: const TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${now.text}  ${dayDetail.tempMin}°/ ${dayDetail.tempMax}°',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          // 更新时间
          Text(
            '更新时间: ${_formatTime(_nowResponse!.updateTime)}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 30),

          // 实时小时天气
          Container(
            height: 100,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _hourlyData?.length ?? 0,
              itemBuilder: (context, index) {
                final hour = _hourlyData![index];
                return Container(
                  width: 50,
                  margin: const EdgeInsets.only(right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // 小时时间格式 HH:mm
                        "${hour.fxTime.substring(11, 13)}:00",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      // 天气图标 (使用占位符，实际项目中可以根据icon值显示对应的图标)
                      OnlineWeatherIcon(
                        iconCode: hour.icon,
                        size: 20,
                      ),
                      
                      Text(
                        '${hour.temp}°',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // 天气详情
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                const Text(
                  '天气详情',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                // 第一行详情
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailItem('体感温度', '${now.feelsLike}°C'),
                    _buildDetailItem('湿度', '${now.humidity}%'),
                  ],
                ),
                const SizedBox(height: 15),

                // 第二行详情
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailItem('风向', now.windDir),
                    _buildDetailItem('风力', '${now.windScale}级'),
                  ],
                ),
                const SizedBox(height: 15),

                // 第三行详情
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailItem('气压', '${now.pressure}hPa'),
                    _buildDetailItem('能见度', '${now.vis}km'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建详情项
  Widget _buildDetailItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // 构建错误UI
  Widget _buildErrorUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 64, color: Colors.red),
        const SizedBox(height: 20),
        const Text('获取天气数据失败', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: _fetchWeatherData, child: const Text('重试')),
      ],
    );
  }

  // 格式化时间
  String _formatTime(String timeStr) {
    try {
      final time = DateTime.parse(timeStr);
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return timeStr;
    }
  }
}
