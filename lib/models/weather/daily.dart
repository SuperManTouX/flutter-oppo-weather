import 'package:flutter_oppo_weather/constants/index.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_oppo_weather/widget/chart/base_temperature_chart_painter.dart';
import 'package:jiffy/jiffy.dart';

part 'daily.g.dart';

@JsonSerializable()
class Daily implements TemperatureData {
  // 预报日期
  @JsonKey(name: 'fxDate')
  final String fxDate;
  // 日出时间
  @JsonKey(name: 'sunrise')
  final String sunrise;
  // 日落时间
  @JsonKey(name: 'sunset')
  final String sunset;
  // 月升时间
  @JsonKey(name: 'moonrise')
  final String moonrise;
  // 月落时间
  @JsonKey(name: 'moonset')
  final String moonset;
  // 月相
  @JsonKey(name: 'moonPhase')
  final String moonPhase;
  // 月相图标
  @JsonKey(name: 'moonPhaseIcon')
  final String moonPhaseIcon;
  // 最高温度
  @JsonKey(name: 'tempMax')
  final String tempMax;
  // 最低温度
  @JsonKey(name: 'tempMin')
  final String tempMin;
  // 白天天气图标代码
  @JsonKey(name: 'iconDay')
  final String iconDay;
  // 白天天气描述
  @JsonKey(name: 'textDay')
  final String textDay;
  // 夜间天气图标代码
  @JsonKey(name: 'iconNight')
  final String iconNight;
  // 夜间天气描述
  @JsonKey(name: 'textNight')
  final String textNight;
  // 白天风向360角度
  @JsonKey(name: 'wind360Day')
  final String wind360Day;
  // 白天风向
  @JsonKey(name: 'windDirDay')
  final String windDirDay;
  // 白天风力等级
  @JsonKey(name: 'windScaleDay')
  final String windScaleDay;
  // 白天风速
  @JsonKey(name: 'windSpeedDay')
  final String windSpeedDay;
  // 夜间风向360角度
  @JsonKey(name: 'wind360Night')
  final String wind360Night;
  // 夜间风向
  @JsonKey(name: 'windDirNight')
  final String windDirNight;
  // 夜间风力等级
  @JsonKey(name: 'windScaleNight')
  final String windScaleNight;
  // 夜间风速
  @JsonKey(name: 'windSpeedNight')
  final String windSpeedNight;
  // 相对湿度
  @JsonKey(name: 'humidity')
  final String humidity;
  // 降水量
  @JsonKey(name: 'precip')
  final String precip;
  // 大气压强
  @JsonKey(name: 'pressure')
  final String pressure;
  // 能见度
  @JsonKey(name: 'vis')
  final String vis;
  // 云量
  @JsonKey(name: 'cloud')
  final String cloud;
  // UV指数
  @JsonKey(name: 'uvIndex')
  final String uvIndex;

  Daily({
    required this.fxDate,
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
    required this.moonPhase,
    required this.moonPhaseIcon,
    required this.tempMax,
    required this.tempMin,
    required this.iconDay,
    required this.textDay,
    required this.iconNight,
    required this.textNight,
    required this.wind360Day,
    required this.windDirDay,
    required this.windScaleDay,
    required this.windSpeedDay,
    required this.wind360Night,
    required this.windDirNight,
    required this.windScaleNight,
    required this.windSpeedNight,
    required this.humidity,
    required this.precip,
    required this.pressure,
    required this.vis,
    required this.cloud,
    required this.uvIndex,
  });

  factory Daily.fromJson(Map<String, dynamic> json) => _$DailyFromJson(json);

  Map<String, dynamic> toJson() => _$DailyToJson(this);

  @override
  String get temperature => tempMax; // 默认返回最高温度

  @override
  String get timeLabel {
    try {
      // 使用Jiffy解析日期并格式化为MM/dd格式
      return Jiffy.parse(fxDate).format(pattern: 'MM/dd');
    } catch (e) {
      // 如果解析失败，回退到原始日期
      return fxDate;
    }
  }

  @override
  String get weekdayLabel {
    try {
      // 使用Jiffy解析日期并格式化为星期几
      return Jiffy.parse(fxDate).format(pattern: 'EEE');
    } catch (e) {
      // 如果解析失败，返回空字符串
      return '';
    }
  }

  @override
  String get weatherText => textDay;

  @override
  String get iconCode => iconDay;
}
