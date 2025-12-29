import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/pages/main_container.dart';
import 'package:flutter_oppo_weather/pages/detail/weather_detail.dart';
import 'package:flutter_oppo_weather/models/display_city.dart';

// 路由名称常量
class RouteNames {
  static const String main = '/';
  static const String detail = '/detail';
}

// 路由配置
class AppRoutes {
  // 路由表
  static Map<String, WidgetBuilder> routes = {
    RouteNames.main: (context) => const MainContainer(),
    RouteNames.detail: (context) {
      // 从路由参数中获取location
      final DisplayCity location = ModalRoute.of(context)?.settings.arguments as DisplayCity;
      return WeatherDetail(location: location);
    },
  };
}
