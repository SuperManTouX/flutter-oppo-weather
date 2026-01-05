import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/models/display_city.dart';
import 'package:flutter_oppo_weather/models/weather/air_quality.dart';
import 'package:flutter_oppo_weather/services/weather/qweather_service.dart';
import 'package:flutter_oppo_weather/models/weather/air_quality_response.dart';

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
      print(widget.location.latitude);
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
                            if (_airQualityData!.indexes[0].primaryPollutant.code.isNotEmpty)
                              Text(
                                '主要污染物: ${_airQualityData!.indexes[0].primaryPollutant.name}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                          ],
                        ),
                      SizedBox(height: 24),

                      // 详细污染物数据
                      GridView.count(
                        crossAxisCount: 5,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: _airQualityData!.pollutants.map((pollutant) {
                          return _buildPollutantItem(pollutant);
                        }).toList(),
                      ),
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
        Text(
          pollutant.name,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
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
