// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_city_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoCityResponse _$GeoCityResponseFromJson(Map<String, dynamic> json) =>
    GeoCityResponse(
      code: json['code'] as String,
      location: (json['location'] as List<dynamic>)
          .map((e) => SearchCity.fromJson(e as Map<String, dynamic>))
          .toList(),
      refer: Refer.fromJson(json['refer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GeoCityResponseToJson(GeoCityResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'location': instance.location,
      'refer': instance.refer,
    };
