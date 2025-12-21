// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_forecast_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherForecastResponse _$WeatherForecastResponseFromJson(
  Map<String, dynamic> json,
) => WeatherForecastResponse(
  code: json['code'] as String,
  updateTime: json['updateTime'] as String,
  fxLink: json['fxLink'] as String,
  daily: (json['daily'] as List<dynamic>)
      .map((e) => Daily.fromJson(e as Map<String, dynamic>))
      .toList(),
  refer: Refer.fromJson(json['refer'] as Map<String, dynamic>),
);

Map<String, dynamic> _$WeatherForecastResponseToJson(
  WeatherForecastResponse instance,
) => <String, dynamic>{
  'code': instance.code,
  'updateTime': instance.updateTime,
  'fxLink': instance.fxLink,
  'daily': instance.daily,
  'refer': instance.refer,
};
