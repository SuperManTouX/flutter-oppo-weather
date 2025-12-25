// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'display_city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisplayCity _$DisplayCityFromJson(Map<String, dynamic> json) => DisplayCity(
  name: json['name'] as String,
  id: json['id'] as String,
  now: json['now'] == null
      ? null
      : Now.fromJson(json['now'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DisplayCityToJson(DisplayCity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'now': instance.now,
    };
