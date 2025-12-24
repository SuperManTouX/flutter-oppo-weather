import 'package:json_annotation/json_annotation.dart';
part 'search_city.g.dart';

/// 搜索城市信息模型（原TopCity已替换为SearchCity）
@JsonSerializable()
class SearchCity {
  /// 城市名称
  final String name;

  /// 城市ID（天气查询唯一标识）
  final String id;

  /// 纬度
  final String lat;

  /// 经度
  final String lon;

  /// 二级行政区
  final String adm2;

  /// 一级行政区
  final String adm1;

  /// 国家
  final String country;

  /// 时区
  final String tz;

  /// UTC偏移量
  final String utcOffset;

  /// 是否夏令时（0=否）
  final String isDst;

  /// 类型（city=城市）
  final String type;

  /// 城市排名
  final String rank;

  /// 天气详情链接
  final String fxLink;

  /// 构造函数
  SearchCity({
    required this.name,
    required this.id,
    required this.lat,
    required this.lon,
    required this.adm2,
    required this.adm1,
    required this.country,
    required this.tz,
    required this.utcOffset,
    required this.isDst,
    required this.type,
    required this.rank,
    required this.fxLink,
  });

  /// 从JSON映射为模型对象
  factory SearchCity.fromJson(Map<String, dynamic> json) =>
      _$SearchCityFromJson(json);

  /// 将模型对象转换为JSON
  Map<String, dynamic> toJson() => _$SearchCityToJson(this);
}