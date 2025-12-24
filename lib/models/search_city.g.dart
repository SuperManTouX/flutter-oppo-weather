// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchCity _$SearchCityFromJson(Map<String, dynamic> json) => SearchCity(
  name: json['name'] as String,
  id: json['id'] as String,
  lat: json['lat'] as String,
  lon: json['lon'] as String,
  adm2: json['adm2'] as String,
  adm1: json['adm1'] as String,
  country: json['country'] as String,
  tz: json['tz'] as String,
  utcOffset: json['utcOffset'] as String,
  isDst: json['isDst'] as String,
  type: json['type'] as String,
  rank: json['rank'] as String,
  fxLink: json['fxLink'] as String,
);

Map<String, dynamic> _$SearchCityToJson(SearchCity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'lat': instance.lat,
      'lon': instance.lon,
      'adm2': instance.adm2,
      'adm1': instance.adm1,
      'country': instance.country,
      'tz': instance.tz,
      'utcOffset': instance.utcOffset,
      'isDst': instance.isDst,
      'type': instance.type,
      'rank': instance.rank,
      'fxLink': instance.fxLink,
    };
