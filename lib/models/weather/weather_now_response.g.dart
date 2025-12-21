// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_now_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherNowResponse _$WeatherNowResponseFromJson(Map<String, dynamic> json) =>
    WeatherNowResponse(
      code: json['code'] as String,
      updateTime: json['updateTime'] as String,
      fxLink: json['fxLink'] as String,
      now: Now.fromJson(json['now'] as Map<String, dynamic>),
      refer: Refer.fromJson(json['refer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeatherNowResponseToJson(WeatherNowResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'updateTime': instance.updateTime,
      'fxLink': instance.fxLink,
      'now': instance.now,
      'refer': instance.refer,
    };
