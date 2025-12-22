import 'package:json_annotation/json_annotation.dart';

part 'now.g.dart';

@JsonSerializable()
class Now {
  // 观测时间
  @JsonKey(name: 'obsTime')
  final String obsTime;
  // 当前温度
  @JsonKey(name: 'temp')
  final String temp;
  // 体感温度
  @JsonKey(name: 'feelsLike')
  final String feelsLike;
  // 天气图标代码
  @JsonKey(name: 'icon')
  final String icon;
  // 天气描述
  @JsonKey(name: 'text')
  final String text;
  // 风向360角度
  @JsonKey(name: 'wind360')
  final String wind360;
  // 风向
  @JsonKey(name: 'windDir')
  final String windDir;
  // 风力等级
  @JsonKey(name: 'windScale')
  final String windScale;
  // 风速
  @JsonKey(name: 'windSpeed')
  final String windSpeed;
  // 相对湿度
  @JsonKey(name: 'humidity')
  final String humidity;
  // 降水量
  @JsonKey(name: 'precip')
  final String precip;
  // 大气压强
  @JsonKey(name: 'pressure')
  final String pressure;
  // 能见度
  @JsonKey(name: 'vis')
  final String vis;
  // 云量
  @JsonKey(name: 'cloud')
  final String cloud;
  // 露点温度
  @JsonKey(name: 'dew')
  final String dew;

  Now({
    required this.obsTime,
    required this.temp,
    required this.feelsLike,
    required this.icon,
    required this.text,
    required this.wind360,
    required this.windDir,
    required this.windScale,
    required this.windSpeed,
    required this.humidity,
    required this.precip,
    required this.pressure,
    required this.vis,
    required this.cloud,
    required this.dew,
  });

  factory Now.fromJson(Map<String, dynamic> json) => _$NowFromJson(json);

  Map<String, dynamic> toJson() => _$NowToJson(this);
}
