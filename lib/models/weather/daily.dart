import 'package:json_annotation/json_annotation.dart';

part 'daily.g.dart';

@JsonSerializable()
class Daily {
  @JsonKey(name: 'fxDate')
  final String fxDate;

  @JsonKey(name: 'sunrise')
  final String sunrise;

  @JsonKey(name: 'sunset')
  final String sunset;

  @JsonKey(name: 'moonrise')
  final String moonrise;

  @JsonKey(name: 'moonset')
  final String moonset;

  @JsonKey(name: 'moonPhase')
  final String moonPhase;

  @JsonKey(name: 'moonPhaseIcon')
  final String moonPhaseIcon;

  @JsonKey(name: 'tempMax')
  final String tempMax;

  @JsonKey(name: 'tempMin')
  final String tempMin;

  @JsonKey(name: 'iconDay')
  final String iconDay;

  @JsonKey(name: 'textDay')
  final String textDay;

  @JsonKey(name: 'iconNight')
  final String iconNight;

  @JsonKey(name: 'textNight')
  final String textNight;

  @JsonKey(name: 'wind360Day')
  final String wind360Day;

  @JsonKey(name: 'windDirDay')
  final String windDirDay;

  @JsonKey(name: 'windScaleDay')
  final String windScaleDay;

  @JsonKey(name: 'windSpeedDay')
  final String windSpeedDay;

  @JsonKey(name: 'wind360Night')
  final String wind360Night;

  @JsonKey(name: 'windDirNight')
  final String windDirNight;

  @JsonKey(name: 'windScaleNight')
  final String windScaleNight;

  @JsonKey(name: 'windSpeedNight')
  final String windSpeedNight;

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

  @JsonKey(name: 'uvIndex')
  final String uvIndex;

  Daily({
    required this.fxDate,
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
    required this.moonPhase,
    required this.moonPhaseIcon,
    required this.tempMax,
    required this.tempMin,
    required this.iconDay,
    required this.textDay,
    required this.iconNight,
    required this.textNight,
    required this.wind360Day,
    required this.windDirDay,
    required this.windScaleDay,
    required this.windSpeedDay,
    required this.wind360Night,
    required this.windDirNight,
    required this.windScaleNight,
    required this.windSpeedNight,
    required this.humidity,
    required this.precip,
    required this.pressure,
    required this.vis,
    required this.cloud,
    required this.uvIndex,
  });

  factory Daily.fromJson(Map<String, dynamic> json) => _$DailyFromJson(json);

  Map<String, dynamic> toJson() => _$DailyToJson(this);
}
