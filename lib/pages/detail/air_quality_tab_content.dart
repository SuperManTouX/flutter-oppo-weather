import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/models/display_city.dart';
import 'package:flutter_oppo_weather/models/weather/air_quality.dart';
import 'package:flutter_oppo_weather/services/weather/qweather_service.dart';
import 'package:flutter_oppo_weather/models/weather/air_quality_response.dart';
import 'package:flutter_oppo_weather/widget/chart/progress_bars.dart';

class AirQualityTabContent extends StatefulWidget {
  final DisplayCity location;
  const AirQualityTabContent({super.key, required this.location});

  @override
  _AirQualityTabContentState createState() => _AirQualityTabContentState();
}

class _AirQualityTabContentState extends State<AirQualityTabContent> {
  AirQualityResponse? _airQualityData;
  bool _isLoading = true;

  // 获取空气质量数据
  Future<void> _fetchAirQuality() async {
    try {
      print('获取空气质量数据: ${widget.location.name},${widget.location.latitude}, ${widget.location.longitude}');
      final service = QWeatherService();
      final data = await service.getAirQualityCurrent(
        latitude: widget.location.latitude,
        longitude: widget.location.longitude,
      );
      setState(() {
        _airQualityData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('获取空气质量数据失败: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // 初始化时获取空气质量数据
    _fetchAirQuality();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: _isLoading
            ? Container(
                constraints: BoxConstraints(minHeight: 200),
                child: Center(child: CircularProgressIndicator()),
              )
            : _airQualityData != null
            ? Column(
                children: [
                  // 城市名
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.location.name} 空气质量',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // 空气质量指数 (默认显示第一个指数，通常是US EPA标准)
                  if (_airQualityData!.indexes.isNotEmpty)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 使用环形进度条显示空气质量指数
                        Builder(
                          builder: (context) {
                            final index = _airQualityData!.indexes[0];
                            // AQI最大值通常为500，计算进度值（0-1）
                            double aqiValue =
                                double.tryParse(index.aqiDisplay) ?? 0;
                            double progress = aqiValue / 500;

                            // 根据空气质量类别设置渐变颜色
                            List<Color> gradientColors;
                            switch (index.level) {
                              case '1':
                                gradientColors = [
                                  Colors.green,
                                  Colors.lightGreen,
                                ];
                                break;
                              case '2':
                                gradientColors = [Colors.yellow, Colors.amber];
                                break;
                              case '3':
                                gradientColors = [
                                  Colors.orange,
                                  Colors.deepOrange,
                                ];
                                break;
                              case '4':
                                gradientColors = [Colors.red, Colors.redAccent];
                                break;
                              case '5':
                                gradientColors = [
                                  Colors.purple,
                                  Colors.deepPurple,
                                ];
                                break;
                              case '6':
                                gradientColors = [Colors.brown, Colors.black];
                                break;
                              default:
                                gradientColors = [Colors.grey, Colors.blueGrey];
                            }

                            return AnimatedCircularProgressBar(
                              progress: progress,
                              size: 180,
                              strokeWidth: 20,
                              gradientColors: gradientColors,
                              showText: false,
                            );
                          },
                        ),
                        SizedBox(height: 16),
                        Text(
                          '${_airQualityData!.indexes[0].aqiDisplay}',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${_airQualityData!.indexes[0].category} (${_airQualityData!.indexes[0].level}级)',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${_airQualityData!.indexes[0].name}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 4),
                        if (_airQualityData!
                            .indexes[0]
                            .primaryPollutant
                            .code
                            .isNotEmpty)
                          Text(
                            '主要污染物: ${_airQualityData!.indexes[0].primaryPollutant.name}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                      ],
                    ),
                  SizedBox(height: 24),

                  
                ],
              )
            : Container(
                constraints: BoxConstraints(minHeight: 200),
                child: Center(child: Text('获取空气质量数据失败')),
              ),
      ),
    );
  }

  // 构建污染物指标项
  Widget _buildPollutantItem(Pollutant pollutant) {
    return Column(
      children: [
        Text(pollutant.name, style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 8),
        Text(
          '${pollutant.concentration.value} ${pollutant.concentration.unit}',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
