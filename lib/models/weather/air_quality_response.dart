import 'package:flutter_oppo_weather/models/weather/air_quality.dart';

// 空气质量响应模型
class AirQualityResponse {
  final Map<String, dynamic> metadata; // 元数据
  final List<AirQualityIndex> indexes; // 空气质量指数列表
  final List<Pollutant> pollutants; // 污染物列表
  final List<Station> stations; // 监测站列表

  AirQualityResponse({
    required this.metadata,
    required this.indexes,
    required this.pollutants,
    required this.stations,
  });

  factory AirQualityResponse.fromJson(Map<String, dynamic> json) {
    return AirQualityResponse(
      metadata: json['metadata'] ?? {},
      indexes: (json['indexes'] as List<dynamic>?)?.map((e) => AirQualityIndex.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      pollutants: (json['pollutants'] as List<dynamic>?)?.map((e) => Pollutant.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      stations: (json['stations'] as List<dynamic>?)?.map((e) => Station.fromJson(e as Map<String, dynamic>)).toList() ?? [],
    );
  }
}
