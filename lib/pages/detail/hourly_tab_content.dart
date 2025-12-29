import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/models/display_city.dart';
import 'package:flutter_oppo_weather/models/weather/hourly.dart';
import 'package:flutter_oppo_weather/services/weather/qweather_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_oppo_weather/widget/Icon.dart';

class HourlyTabContent extends StatefulWidget {
  // 接受DisplayCity对象
  final DisplayCity location;
  // 接受Hourly对象

  const HourlyTabContent({super.key, required this.location});

  @override
  _HourlyTabContentState createState() => _HourlyTabContentState();
}

class _HourlyTabContentState extends State<HourlyTabContent> {
  List<Hourly>? _hourlyData;

  // 获取24小时天气数据
  Future<void> _fetchWeather24h() async {
    setState(() {});
    try {
      final service = QWeatherService();
      final data = await service.getWeather24h(location: widget.location.id);
      setState(() {
        _hourlyData = data.hourly;
      });
    } catch (e) {
      print('获取24小时天气数据失败: $e');
      setState(() {});
    }
  }

  @override
  initState() {
    super.initState();
    _fetchWeather24h();
  }

  // 将小时温度数据转换为LineChart所需的FlSpot列表
  List<FlSpot> _getTemperatureSpots() {
    if (_hourlyData == null || _hourlyData!.isEmpty) {
      return [];
    }
    final spots = <FlSpot>[];
    for (int i = 0; i < _hourlyData!.length; i++) {
      final temp = double.tryParse(_hourlyData![i].temp) ?? 0;
      spots.add(FlSpot(i.toDouble(), temp));
    }
    return spots;
  }

  // 获取温度数据中的最小值
  double _getMinTemp() {
    if (_hourlyData == null || _hourlyData!.isEmpty) {
      return 0;
    }
    double minTemp = double.infinity;
    for (final data in _hourlyData!) {
      final temp = double.tryParse(data.temp) ?? 0;
      if (temp < minTemp) {
        minTemp = temp;
      }
    }
    return minTemp;
  }

  // 获取温度数据中的最大值
  double _getMaxTemp() {
    if (_hourlyData == null || _hourlyData!.isEmpty) {
      return 30;
    }
    double maxTemp = -double.infinity;
    for (final data in _hourlyData!) {
      final temp = double.tryParse(data.temp) ?? 0;
      if (temp > maxTemp) {
        maxTemp = temp;
      }
    }
    return maxTemp;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.location.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text('月日 今天明天', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            Text('6 分钟前发布', style: Theme.of(context).textTheme.titleLarge),
            // 24小时天气折线趋势图
            Container(
              height: 200,
              margin: const EdgeInsets.only(top: 16),
              child: _hourlyData != null && _hourlyData!.isNotEmpty
                  ? LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false), // 隐藏网格
                        titlesData: FlTitlesData(show: false), // 隐藏坐标轴文字
                        borderData: FlBorderData(show: false), // 隐藏边框

                        minX: 0,
                        maxX: _hourlyData!.length - 1.toDouble(),
                        minY: _getMinTemp() - 2,
                        maxY: _getMaxTemp() + 2,
                        lineBarsData: [
                          LineChartBarData(
                            spots: _getTemperatureSpots(),
                            color: Colors.white,
                            barWidth: 2,
                            isStrokeCapRound: true,
                            isCurved: false, // 直线（UI中是折线）
                            dotData: FlDotData(show: false), // 隐藏折点
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
            ),
            // 24小时天气详细信息
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '12:00',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text('20℃', style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '12:00',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text('20℃', style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '12:00',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text('20℃', style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
                // 其他小时...
              ],
            ),
          ],
        ),
      ),
    );
  }
}
