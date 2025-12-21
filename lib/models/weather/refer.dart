import 'package:json_annotation/json_annotation.dart';

part 'refer.g.dart';

@JsonSerializable()
class Refer {
  @JsonKey(name: 'sources')
  final List<String> sources;

  @JsonKey(name: 'license')
  final List<String> license;

  Refer({
    required this.sources,
    required this.license,
  });

  factory Refer.fromJson(Map<String, dynamic> json) => _$ReferFromJson(json);

  Map<String, dynamic> toJson() => _$ReferToJson(this);
}
