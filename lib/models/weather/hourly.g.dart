// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hourly.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hourly _$HourlyFromJson(Map<String, dynamic> json) => Hourly(
  fxTime: json['fxTime'] as String,
  temp: json['temp'] as String,
  icon: json['icon'] as String,
  text: json['text'] as String,
  wind360: json['wind360'] as String,
  windDir: json['windDir'] as String,
  windScale: json['windScale'] as String,
  windSpeed: json['windSpeed'] as String,
  humidity: json['humidity'] as String,
  precip: json['precip'] as String,
  pressure: json['pressure'] as String,
  vis: json['vis'] as String,
  cloud: json['cloud'] as String,
  dew: json['dew'] as String,
);

Map<String, dynamic> _$HourlyToJson(Hourly instance) => <String, dynamic>{
  'fxTime': instance.fxTime,
  'temp': instance.temp,
  'icon': instance.icon,
  'text': instance.text,
  'wind360': instance.wind360,
  'windDir': instance.windDir,
  'windScale': instance.windScale,
  'windSpeed': instance.windSpeed,
  'humidity': instance.humidity,
  'precip': instance.precip,
  'pressure': instance.pressure,
  'vis': instance.vis,
  'cloud': instance.cloud,
  'dew': instance.dew,
};
