// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Refer _$ReferFromJson(Map<String, dynamic> json) => Refer(
  sources: (json['sources'] as List<dynamic>).map((e) => e as String).toList(),
  license: (json['license'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$ReferToJson(Refer instance) => <String, dynamic>{
  'sources': instance.sources,
  'license': instance.license,
};
