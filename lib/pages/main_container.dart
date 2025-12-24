import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/pages/weather_page.dart';
import 'package:flutter_oppo_weather/pages/city_page.dart';
import 'package:flutter_oppo_weather/models/display_city.dart';

/// 页面状态枚举
enum PageState {
  weather, // 天气页面
  favorites, // 收藏列表页面
}

/// 主容器页面，用于管理天气页面和收藏列表页面的切换动画
class MainContainer extends StatefulWidget {
  // 初始显示的城市信息
  final String initialLocation;
  final String initialCityName;

  const MainContainer({
    Key? key,
    this.initialLocation = '101010100',
    this.initialCityName = '北京',
  }) : super(key: key);

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer>
    with SingleTickerProviderStateMixin {

  // 页面状态枚举
  PageState _currentState = PageState.weather;
  // 动画控制器
  late AnimationController _animationController;
  // 天气页面缩放动画
  late Animation<double> _weatherScaleAnimation;
  // 天气页面透明度动画
  late Animation<double> _weatherOpacityAnimation;

  // 当前选中的城市信息
  String _currentLocation = '';
  String _currentCityName = '';
  // 是否为搜索结果
  bool _isSearchResult = false;

  @override
  void initState() {
    super.initState();

    // 初始化当前城市信息
    _currentLocation = widget.initialLocation;
    _currentCityName = widget.initialCityName;

    // 初始化动画控制器
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // 天气页面缩放动画：从1.0缩放到0.0（上下收缩）
    _weatherScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // 天气页面透明度动画：从1.0变为0.0
    _weatherOpacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// 切换到收藏列表页面
  void _switchToFavorites() {
    if (_currentState == PageState.weather) {
      setState(() {
        _currentState = PageState.favorites;
      });
      _animationController.forward();
    }
  }

  /// 切换到天气页面
  void _switchToWeather() {
    if (_currentState == PageState.favorites) {
      setState(() {
        _currentState = PageState.weather;
      });
      _animationController.reverse();
    }
  }

  /// 选择城市并切换到天气页面
  void _selectCity(DisplayCity city, bool isSearchResult) {
    setState(() {
      _currentLocation = city.location;
      _currentCityName = city.name;
      _currentState = PageState.weather;
      // 传递是否为搜索结果
      _isSearchResult = isSearchResult;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 收藏列表页面（底层）- 无动画，直接显示
          Visibility(
            visible: true,
            child: CityPage(
              // 传递回调函数给收藏列表页面
              onCitySelect: _selectCity,
              onBackPress: _switchToWeather,
            ),
          ),
          // 天气页面（顶层）
          Visibility(
            visible: true, // 始终可见，但通过动画控制显示/隐藏
            child: RepaintBoundary(
              // 隔离动画重绘区域，提高性能
              child: AnimatedBuilder(
                // 合并动画监听，减少重建次数
                animation: Listenable.merge([_weatherScaleAnimation, _weatherOpacityAnimation]),
                builder: (context, child) {
                  return Transform.scale(
                    scaleY: _weatherScaleAnimation.value,
                    scaleX: 1.0,
                    // 移除origin设置，使用默认值提高性能
                    child: Opacity(
                      opacity: _weatherOpacityAnimation.value,
                      child: child, // 使用传入的child避免重建WeatherPage
                    ),
                  );
                },
                // 将WeatherPage作为child传递，避免在动画过程中频繁重建
                child: WeatherPage(
                  location: _currentLocation,
                  cityName: _currentCityName,
                  // 传递回调函数给天气页面
                  onFavoritesPress: _switchToFavorites,
                  // 传递是否为搜索结果
                  isSearchResult: _isSearchResult,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
