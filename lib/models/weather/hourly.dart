import 'package:flutter_oppo_weather/constants/index.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_oppo_weather/widget/chart/base_temperature_chart_painter.dart';
import 'package:jiffy/jiffy.dart';

part 'hourly.g.dart';

@JsonSerializable()
class Hourly implements TemperatureData {
  @JsonKey(name: 'fxTime')
  final String fxTime;

  @JsonKey(name: 'temp')
  final String temp;

  @JsonKey(name: 'icon')
  final String icon;

  @JsonKey(name: 'text')
  final String text;

  @JsonKey(name: 'wind360')
  final String wind360;

  @JsonKey(name: 'windDir')
  final String windDir;

  @JsonKey(name: 'windScale')
  final String windScale;

  @JsonKey(name: 'windSpeed')
  final String windSpeed;

  @JsonKey(name: 'humidity')
  final String humidity;

  @JsonKey(name: 'pop')
  final String pop;

  @JsonKey(name: 'precip')
  final String precip;

  @JsonKey(name: 'pressure')
  final String pressure;


  @JsonKey(name: 'cloud')
  final String cloud;

  @JsonKey(name: 'dew')
  final String dew;

  Hourly({
    required this.fxTime,
    required this.temp,
    required this.icon,
    required this.text,
    required this.wind360,
    required this.windDir,
    required this.windScale,
    required this.windSpeed,
    required this.humidity,
    required this.pop,
    required this.precip,
    required this.pressure,
    required this.cloud,
    required this.dew,
  });

  factory Hourly.fromJson(Map<String, dynamic> json) => _$HourlyFromJson(json);

  Map<String, dynamic> toJson() => _$HourlyToJson(this);

  @override
  String get temperature => temp;

  @override
  String get timeLabel {
    try {
      // 使用Jiffy解析ISO格式时间并格式化为HH:mm
      return Jiffy.parse(fxTime,pattern: GlobalConfig.DATE_PATTERN).format(pattern: 'HH:mm');
    } catch (e) {
      // 如果解析失败，回退到原始时间
      return fxTime;
    }
  }

  @override
  String get weekdayLabel {
    try {
      // 使用Jiffy解析ISO格式时间并格式化为星期几
      return Jiffy.parse(fxTime,pattern: GlobalConfig.DATE_PATTERN).format(pattern: 'EEE');
    } catch (e) {
      // 如果解析失败，返回空字符串
      return '';
    }
  }

  @override
  String get weatherText => text;

  @override
  String get iconCode => icon;
} 
