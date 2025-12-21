// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_24h_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather24hResponse _$Weather24hResponseFromJson(Map<String, dynamic> json) =>
    Weather24hResponse(
      code: json['code'] as String,
      updateTime: json['updateTime'] as String,
      fxLink: json['fxLink'] as String,
      hourly: (json['hourly'] as List<dynamic>)
          .map((e) => Hourly.fromJson(e as Map<String, dynamic>))
          .toList(),
      refer: Refer.fromJson(json['refer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$Weather24hResponseToJson(Weather24hResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'updateTime': instance.updateTime,
      'fxLink': instance.fxLink,
      'hourly': instance.hourly,
      'refer': instance.refer,
    };
