import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/models/display_city.dart';
import 'package:flutter_oppo_weather/models/weather/daily.dart';
import 'package:flutter_oppo_weather/services/weather/qweather_service.dart';
import 'package:flutter_oppo_weather/widget/Icon.dart';
import 'package:jiffy/jiffy.dart';

class DailyTabContent extends StatefulWidget {
  final DisplayCity location;
  // 点击的日期，用于 DailyTabContent
  final Jiffy? clickedJDate;
  DailyTabContent({Key? key, required this.location, this.clickedJDate})
    : super(key: key);

  @override
  _DailyTabContentState createState() => _DailyTabContentState();
}

class _DailyTabContentState extends State<DailyTabContent> {
  // 未来15天的天气数据
  List<Daily>? dailyList15;
  // 当前选中的日期索引
  int currentIndex = 0;

  // 获取未来15天的天气数据
  Future<void> _fetchWeather15d() async {
    try {
      final service = QWeatherService();
      final data = await service.getWeather15d(location: widget.location.id);
      setState(() {
        dailyList15 = data.daily;

        // 计算当前选中的日期索引
        if (dailyList15 != null &&
            dailyList15!.isNotEmpty &&
            widget.clickedJDate != null) {
          // 将clickedJDate格式化为YYYY-MM-DD字符串
          final clickedDateStr = widget.clickedJDate!.format(
            pattern: 'yyyy-MM-dd',
          );

          // 在dailyList15中查找fxDate与clickedDateStr匹配的项
          for (int i = 0; i < dailyList15!.length; i++) {
            if (dailyList15![i].fxDate == clickedDateStr) {
              currentIndex = i;
              break;
            }
          }
        }
      });
    } catch (e) {
      print('获取15天天气数据失败: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    // 初始化时获取未来15天的天气数据
    _fetchWeather15d();
  }

  void _previousDay() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
      }
    });
  }

  void _nextDay() {
    setState(() {
      if (dailyList15 != null &&
          dailyList15!.isNotEmpty &&
          currentIndex < dailyList15!.length - 1) {
        currentIndex++;
      }
    });
  }

  Widget _buildDailyDetailItem(String title, String value) {
    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        Text(value, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: dailyList15 == null || dailyList15!.isEmpty
            ? Container(
                constraints: BoxConstraints(minHeight: 200),
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                children: [
                  // 城市名和日期选择器
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.location.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.chevron_left),
                            onPressed: currentIndex == 0 ? null : _previousDay,
                            disabledColor: Colors.grey,
                          ),
                          Text(
                            dailyList15?[currentIndex].fxDate ?? '',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          IconButton(
                            icon: Icon(Icons.chevron_right),
                            onPressed: currentIndex == dailyList15!.length - 1
                                ? null
                                : _nextDay,
                            disabledColor: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // 当天天气
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${dailyList15?[currentIndex].tempMax}°/${dailyList15?[currentIndex].tempMin}°',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          QIcon(
                            iconCode: dailyList15?[currentIndex].iconDay ?? '',
                            size: 24,
                          ),
                          Text(
                            dailyList15?[currentIndex].textDay ?? '',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // 当天详细气候数据
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDailyDetailItem(
                        '降水量',
                        '${dailyList15?[currentIndex].precip ?? '0'}mm',
                      ),
                      _buildDailyDetailItem(
                        '能见度',
                        '${dailyList15?[currentIndex].vis ?? '0'}%',
                      ),
                      _buildDailyDetailItem(
                        '湿度',
                        '${dailyList15?[currentIndex].humidity ?? '0'}%',
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
