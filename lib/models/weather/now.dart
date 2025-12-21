import 'package:json_annotation/json_annotation.dart';

part 'now.g.dart';

@JsonSerializable()
class Now {
  @JsonKey(name: 'obsTime')
  final String obsTime;

  @JsonKey(name: 'temp')
  final String temp;

  @JsonKey(name: 'feelsLike')
  final String feelsLike;

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

  @JsonKey(name: 'precip')
  final String precip;

  @JsonKey(name: 'pressure')
  final String pressure;

  @JsonKey(name: 'vis')
  final String vis;

  @JsonKey(name: 'cloud')
  final String cloud;

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
