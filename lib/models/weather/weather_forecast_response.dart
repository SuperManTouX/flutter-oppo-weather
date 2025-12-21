import 'package:json_annotation/json_annotation.dart';
import './daily.dart';
import './refer.dart';

part 'weather_forecast_response.g.dart';

@JsonSerializable()
class WeatherForecastResponse {
  @JsonKey(name: 'code')
  final String code;

  @JsonKey(name: 'updateTime')
  final String updateTime;

  @JsonKey(name: 'fxLink')
  final String fxLink;

  @JsonKey(name: 'daily')
  final List<Daily> daily;

  @JsonKey(name: 'refer')
  final Refer refer;

  WeatherForecastResponse({
    required this.code,
    required this.updateTime,
    required this.fxLink,
    required this.daily,
    required this.refer,
  });

  factory WeatherForecastResponse.fromJson(Map<String, dynamic> json) =>
      _$WeatherForecastResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherForecastResponseToJson(this);
}
