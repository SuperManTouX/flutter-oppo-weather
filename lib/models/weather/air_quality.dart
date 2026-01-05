// 空气质量指数模型
class AirQualityIndex {
  final String code; // 指数类型代码
  final String name; // 指数类型名称
  final dynamic aqi; // 空气质量指数值
  final String aqiDisplay; // 空气质量指数显示值
  final String level; // 空气质量等级
  final String category; // 空气质量类别
  final ColorInfo color; // 空气质量颜色信息
  final PollutantInfo primaryPollutant; // 主要污染物
  final HealthInfo health; // 健康建议信息

  AirQualityIndex({
    required this.code,
    required this.name,
    required this.aqi,
    required this.aqiDisplay,
    required this.level,
    required this.category,
    required this.color,
    required this.primaryPollutant,
    required this.health,
  });

  factory AirQualityIndex.fromJson(Map<String, dynamic> json) {
    return AirQualityIndex(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      aqi: json['aqi'] ?? 0,
      aqiDisplay: json['aqiDisplay'] ?? '',
      level: json['level'] ?? '',
      category: json['category'] ?? '',
      color: ColorInfo.fromJson(json['color'] ?? {}),
      primaryPollutant: PollutantInfo.fromJson(json['primaryPollutant'] ?? {}),
      health: HealthInfo.fromJson(json['health'] ?? {}),
    );
  }
}

// 颜色信息模型
class ColorInfo {
  final int red; // 红色通道值
  final int green; // 绿色通道值
  final int blue; // 蓝色通道值
  final double alpha; // 透明度

  ColorInfo({
    required this.red,
    required this.green,
    required this.blue,
    required this.alpha,
  });

  factory ColorInfo.fromJson(Map<String, dynamic> json) {
    return ColorInfo(
      red: json['red'] ?? 0,
      green: json['green'] ?? 0,
      blue: json['blue'] ?? 0,
      alpha: json['alpha'] ?? 1.0,
    );
  }
}

// 污染物基本信息模型
class PollutantInfo {
  final String code; // 污染物代码
  final String name; // 污染物名称
  final String fullName; // 污染物完整名称

  PollutantInfo({
    required this.code,
    required this.name,
    required this.fullName,
  });

  factory PollutantInfo.fromJson(Map<String, dynamic> json) {
    return PollutantInfo(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      fullName: json['fullName'] ?? '',
    );
  }
}

// 健康建议信息模型
class HealthInfo {
  final String effect; // 健康影响
  final AdviceInfo advice; // 建议信息

  HealthInfo({
    required this.effect,
    required this.advice,
  });

  factory HealthInfo.fromJson(Map<String, dynamic> json) {
    return HealthInfo(
      effect: json['effect'] ?? '',
      advice: AdviceInfo.fromJson(json['advice'] ?? {}),
    );
  }
}

// 建议信息模型
class AdviceInfo {
  final String generalPopulation; // 一般人群建议
  final String sensitivePopulation; // 敏感人群建议

  AdviceInfo({
    required this.generalPopulation,
    required this.sensitivePopulation,
  });

  factory AdviceInfo.fromJson(Map<String, dynamic> json) {
    return AdviceInfo(
      generalPopulation: json['generalPopulation'] ?? '',
      sensitivePopulation: json['sensitivePopulation'] ?? '',
    );
  }
}

// 污染物模型
class Pollutant {
  final String code; // 污染物代码
  final String name; // 污染物名称
  final String fullName; // 污染物完整名称
  final ConcentrationInfo concentration; // 浓度信息
  final List<SubIndex> subIndexes; // 子指数列表

  Pollutant({
    required this.code,
    required this.name,
    required this.fullName,
    required this.concentration,
    required this.subIndexes,
  });

  factory Pollutant.fromJson(Map<String, dynamic> json) {
    return Pollutant(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      fullName: json['fullName'] ?? '',
      concentration: ConcentrationInfo.fromJson(json['concentration'] ?? {}),
      subIndexes: (json['subIndexes'] as List<dynamic>?)?.map((e) => SubIndex.fromJson(e as Map<String, dynamic>)).toList() ?? [],
    );
  }
}

// 浓度信息模型
class ConcentrationInfo {
  final double value; // 浓度值
  final String unit; // 浓度单位

  ConcentrationInfo({
    required this.value,
    required this.unit,
  });

  factory ConcentrationInfo.fromJson(Map<String, dynamic> json) {
    return ConcentrationInfo(
      value: json['value'] ?? 0.0,
      unit: json['unit'] ?? '',
    );
  }
}

// 子指数模型
class SubIndex {
  final String code; // 指数类型代码
  final dynamic aqi; // 空气质量指数值
  final String aqiDisplay; // 空气质量指数显示值

  SubIndex({
    required this.code,
    required this.aqi,
    required this.aqiDisplay,
  });

  factory SubIndex.fromJson(Map<String, dynamic> json) {
    return SubIndex(
      code: json['code'] ?? '',
      aqi: json['aqi'] ?? 0,
      aqiDisplay: json['aqiDisplay'] ?? '',
    );
  }
}

// 监测站模型
class Station {
  final String id; // 监测站ID
  final String name; // 监测站名称

  Station({
    required this.id,
    required this.name,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
