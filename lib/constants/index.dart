// 渐变色类
import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/models/display_city.dart';

class GlobalConfig {
  static Map<String, List<Color>> Gradient_Colors_Weather2English = {
    "晴": [
      Color(0xFF4A90E2), // 起始颜色
      Color.fromARGB(255, 255, 255, 255), // 结束颜色
    ],
    "多云": [
      Color(0xFF4A90E2), // 起始颜色
      Color(0xFF7FB8E7), // 结束颜色
    ],
    "阴": [
      Color.fromARGB(255, 64, 64, 65), // 起始颜色
      Color.fromARGB(255, 170, 147, 147), // 结束颜色
    ],
    "小雨": [
      Color(0xFF4A90E2), // 起始颜色
      Color(0xFF7FB8E7), // 结束颜色
    ],
    "中雨": [
      Color(0xFF4A90E2), // 起始颜色
      Color(0xFF7FB8E7), // 结束颜色
    ],
    "大雨": [
      Color(0xFF4A90E2), // 起始颜色
      Color(0xFF7FB8E7), // 结束颜色
    ],
    "雪": [
      Color(0xFF4A90E2), // 起始颜色
      Color(0xFF7FB8E7), // 结束颜色
    ],
    "雾": [
      Color.fromARGB(255, 79, 80, 80), // 起始颜色
      Color.fromARGB(255, 97, 97, 97), // 结束颜色
    ],
  };
}
