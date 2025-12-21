import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/pages/weather_page.dart';
import 'package:flutter_oppo_weather/pages/favorites_page.dart';

// 路由名称常量
class RouteNames {
  static const String weather = '/';
  static const String favorites = '/favorites';
}

// 路由配置
class AppRoutes {
  // 路由表
  static Map<String, WidgetBuilder> routes = {
    RouteNames.weather: (context) => const WeatherPage(),
    RouteNames.favorites: (context) => const FavoritesPage(),
  };

  // 自定义路由生成器
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.weather:
        // 从路由设置中获取参数
        final Map<String, dynamic>? arguments = settings.arguments as Map<String, dynamic>?;
        return _customPageRoute(
          builder: (context) => WeatherPage(
            location: arguments?['location'] ?? '101010100',
            cityName: arguments?['cityName'] ?? '北京',
          ),
          settings: settings,
          type: RouteAnimationType.scaleVertical,
        );
      case RouteNames.favorites:
        return _customPageRoute(
          builder: (context) => const FavoritesPage(),
          settings: settings,
          type: RouteAnimationType.slide,
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const WeatherPage(),
        );
    }
  }

  // 自定义页面路由
  static PageRouteBuilder _customPageRoute({
    required WidgetBuilder builder,
    required RouteSettings settings,
    RouteAnimationType type = RouteAnimationType.slide,
  }) {
    // 页面切换时长
    const duration = Duration(milliseconds: 300);

    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        late Widget transition;

        // 根据动画类型选择不同的过渡效果
        switch (type) {
          case RouteAnimationType.slide:
            // 左右滑动动画
            final offsetAnimation = animation.drive(
              Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).chain(
                CurveTween(curve: Curves.easeInOut),
              ),
            );
            transition = SlideTransition(
              position: offsetAnimation,
              child: child,
            );
            break;
          case RouteAnimationType.fade:
            // 淡入淡出动画
            final opacityAnimation = animation.drive(
              Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).chain(
                CurveTween(curve: Curves.easeInOut),
              ),
            );
            transition = FadeTransition(
              opacity: opacityAnimation,
              child: child,
            );
            break;
          case RouteAnimationType.scale:
            // 缩放动画
            final scaleAnimation = animation.drive(
              Tween<double>(
                begin: 0.8,
                end: 1.0,
              ).chain(
                CurveTween(curve: Curves.easeInOut),
              ),
            );
            final opacityAnimation = animation.drive(
              Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).chain(
                CurveTween(curve: Curves.easeInOut),
              ),
            );
            transition = ScaleTransition(
              scale: scaleAnimation,
              child: FadeTransition(
                opacity: opacityAnimation,
                child: child,
              ),
            );
            break;
          case RouteAnimationType.scaleVertical:
            // 垂直缩放动画（以页面中点为中心）
            final scaleVerticalAnimation = animation.drive(
              Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).chain(
                CurveTween(curve: Curves.easeInOut),
              ),
            );
            final opacityAnimation = animation.drive(
              Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).chain(
                CurveTween(curve: Curves.easeInOut),
              ),
            );
            transition = FadeTransition(
              opacity: opacityAnimation,
              child: AnimatedBuilder(
                animation: scaleVerticalAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scaleY: scaleVerticalAnimation.value,
                    scaleX: 1.0,
                    origin: const Offset(0.5, 0.5), // 以页面中点为中心
                    child: child,
                  );
                },
                child: child,
              ),
            );
            break;
        }

        return transition;
      },
    );
  }
}

// 路由动画类型枚举
enum RouteAnimationType {
  slide,       // 左右滑动
  fade,        // 淡入淡出
  scale,       // 缩放
  scaleVertical, // 垂直缩放（以页面中点为中心）
}