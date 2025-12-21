import 'package:json_annotation/json_annotation.dart';
import './hourly.dart';
import './refer.dart';

part 'weather_24h_response.g.dart';

@JsonSerializable()
class Weather24hResponse {
  @JsonKey(name: 'code')
  final String code;

  @JsonKey(name: 'updateTime')
  final String updateTime;

  @JsonKey(name: 'fxLink')
  final String fxLink;

  @JsonKey(name: 'hourly')
  final List<Hourly> hourly;

  @JsonKey(name: 'refer')
  final Refer refer;

  Weather24hResponse({
    required this.code,
    required this.updateTime,
    required this.fxLink,
    required this.hourly,
    required this.refer,
  });

  factory Weather24hResponse.fromJson(Map<String, dynamic> json) =>
      _$Weather24hResponseFromJson(json);

  Map<String, dynamic> toJson() => _$Weather24hResponseToJson(this);
}
