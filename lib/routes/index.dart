import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/pages/main_container.dart';

// 路由名称常量
class RouteNames {
  static const String main = '/';
}

// 路由配置
class AppRoutes {
  // 路由表
  static Map<String, WidgetBuilder> routes = {
    RouteNames.main: (context) => const MainContainer(),
  };
}