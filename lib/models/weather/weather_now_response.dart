import 'package:json_annotation/json_annotation.dart';
import './now.dart';
import './refer.dart';

part 'weather_now_response.g.dart';

@JsonSerializable()
class WeatherNowResponse {
  @JsonKey(name: 'code')
  final String code;

  @JsonKey(name: 'updateTime')
  final String updateTime;

  @JsonKey(name: 'fxLink')
  final String fxLink;

  @JsonKey(name: 'now')
  final Now now;

  @JsonKey(name: 'refer')
  final Refer refer;

  WeatherNowResponse({
    required this.code,
    required this.updateTime,
    required this.fxLink,
    required this.now,
    required this.refer,
  });

  factory WeatherNowResponse.fromJson(Map<String, dynamic> json) =>
      _$WeatherNowResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherNowResponseToJson(this);
}
