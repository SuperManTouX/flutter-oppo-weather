import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/models/display_city.dart';
import 'package:flutter_oppo_weather/models/weather/daily.dart';
import 'package:flutter_oppo_weather/services/weather/qweather_service.dart';
import 'package:flutter_oppo_weather/widget/chart/interactive_daily_temperature_chart.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter_oppo_weather/utils/oppo_date_utils.dart';

class Future15TabContent extends StatefulWidget {
  final DisplayCity location;
  const Future15TabContent({super.key, required this.location});

  @override
  _Future15TabContentState createState() => _Future15TabContentState();
}

class _Future15TabContentState extends State<Future15TabContent> {
  // 未来15天的天气数据
  List<Daily>? dailyList15;
  // 当前选中的日期索引
  int selectedIndex = 0;
  
  // 获取当前选中的日期
  Jiffy get JToday {
    if (dailyList15 == null || dailyList15!.isEmpty) {
      return Jiffy.now();
    }
    final dateStr = dailyList15![selectedIndex].fxDate;
    if (dateStr.isEmpty) {
      return Jiffy.now();
    }
    return Jiffy.parse(dateStr, pattern: "yyyy-MM-dd");
  }

  // 获取未来15天的天气数据
  Future<void> _fetchWeather15d() async {
    try {
      final service = QWeatherService();
      final data = await service.getWeather15d(location: widget.location.id);
      setState(() {
        dailyList15 = data.daily;
      });
    } catch (e) {
      print('获取15天天气数据失败: $e');
    }
  }

  // 处理选中索引变化
  void _onSelectedIndexChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // 初始化时获取未来15天的天气数据
    _fetchWeather15d();
  }

  @override
  Widget build(BuildContext context) {
    if (dailyList15 == null || dailyList15!.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
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
            Container(
              height: 240,
              margin: const EdgeInsets.only(top: 16),
              child: InteractiveDailyTemperatureChart(
                dailyData: dailyList15!,
                selectedIndex: selectedIndex,
                onSelectedIndexChanged: _onSelectedIndexChanged,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('温度', style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      '${dailyList15?[selectedIndex].tempMax ?? '0'}℃ / ${dailyList15?[selectedIndex].tempMin ?? '0'}℃',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('降水概率', style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      '${dailyList15?[selectedIndex].precip ?? '0'}%',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('湿度', style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      '${dailyList15?[selectedIndex].humidity ?? '0'}%',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}