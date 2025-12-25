import 'package:json_annotation/json_annotation.dart';
import './search_city.dart';
import './weather/refer.dart';

part 'geo_city_response.g.dart';

@JsonSerializable()
class GeoCityResponse {
  @JsonKey(name: 'code')
  final String code;

  @JsonKey(name: 'location')
  final List<SearchCity> location;

  @JsonKey(name: 'refer')
  final Refer refer;

  GeoCityResponse({
    required this.code,
    required this.location,
    required this.refer,
  });

  factory GeoCityResponse.fromJson(Map<String, dynamic> json) =>
      _$GeoCityResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GeoCityResponseToJson(this);
}
