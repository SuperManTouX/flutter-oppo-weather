// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_top_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityTopResponse _$CityTopResponseFromJson(Map<String, dynamic> json) =>
    CityTopResponse(
      code: json['code'] as String,
      topCityList: (json['topCityList'] as List<dynamic>)
          .map((e) => SearchCity.fromJson(e as Map<String, dynamic>))
          .toList(),
      refer: Refer.fromJson(json['refer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CityTopResponseToJson(CityTopResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'topCityList': instance.topCityList,
      'refer': instance.refer,
    };
