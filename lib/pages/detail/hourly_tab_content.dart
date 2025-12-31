import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/models/display_city.dart';
import 'package:flutter_oppo_weather/models/weather/hourly.dart';
import 'package:flutter_oppo_weather/pages/detail/interactive_temperature_chart.dart';
import 'package:flutter_oppo_weather/pages/detail/line_chart_painter.dart';
import 'package:flutter_oppo_weather/services/weather/qweather_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_oppo_weather/utils/oppo_date_utils.dart';
import 'package:flutter_oppo_weather/widget/Icon.dart';
import 'package:jiffy/jiffy.dart';

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
  int _selectedIndex = -1;
  // 获取当前时间
  Jiffy get JToday {
    if (_hourlyData == null || _hourlyData!.isEmpty) {
      return Jiffy.now();
    }
    final index = _selectedIndex > -1 ? _selectedIndex : 0;
    final timeStr = _hourlyData![index].fxTime;
    if (timeStr.isEmpty) {
      return Jiffy.now();
    }
    return Jiffy.parse(timeStr, pattern: "yyyy-MM-dd'T'HH:mmZ");
  }

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

  @override
  Widget build(BuildContext context) {
    return Card(
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
                Text(
                  OppoDateUtils.getWeekdayText(JToday),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),

            // 24小时天气折线趋势图
            Container(
              height: 240,
              margin: const EdgeInsets.only(top: 16),
              child: InteractiveTemperatureChart(
                hourlyData: _hourlyData,
                selectedIndex: _selectedIndex,
                onSelectedIndexChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
            // 24小时天气详细信息
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('温度', style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      '${_hourlyData?[_selectedIndex].temp ?? '0'}℃',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('降水概率', style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      '${_hourlyData?[_selectedIndex].pop ?? '0'}%',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('湿度', style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      '${_hourlyData?[_selectedIndex].humidity ?? '0'}%',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
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
