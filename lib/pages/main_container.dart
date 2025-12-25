import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/pages/weather_page.dart';
import 'package:flutter_oppo_weather/pages/city_page.dart';
import 'package:flutter_oppo_weather/models/display_city.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 页面状态枚举
enum PageState {
  resultWeather, // 搜索结果天气页面
  pageViewWeather, // 滑动天气页面
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
  PageState _currentState = PageState.pageViewWeather;
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


  // 城市列表 - 从city_page.dart提升而来
  List<DisplayCity> _cityList = [];
  // 加载状态
  bool _isCityListLoading = true;
  // 当前选中的城市索引
  int _currentCityIndex = 0;
  // Page控制器，用于管理PageView的页面切换
  PageController? _pageController;

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
    _weatherScaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // 天气页面透明度动画：从1.0变为0.0
    _weatherOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // 加载城市列表
    _loadCityListFromStorage();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  // 将城市列表保存到本地存储 - 从city_page.dart迁移而来
  Future<void> _saveCityListToStorage(List<DisplayCity> cityList) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // 将DisplayCity列表转换为JSON字符串列表
      final cityListJson = cityList.map((city) => city.toJson()).toList();
      // 保存到本地存储
      await prefs.setStringList(
        'cityList',
        cityListJson.map((json) => jsonEncode(json)).toList(),
      );
      print('城市列表已保存到本地存储');
    } catch (e) {
      print('保存城市列表到本地存储失败: $e');
    }
  }

  // 从本地存储加载城市列表 - 从city_page.dart迁移而来
  Future<void> _loadCityListFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // 从本地存储获取城市列表JSON字符串
      final cityListJsonStrings = prefs.getStringList('cityList');
      print('从本地存储加载的城市列表JSON字符串: $cityListJsonStrings');
      if (cityListJsonStrings != null && cityListJsonStrings.isNotEmpty) {
        // 将JSON字符串列表转换为DisplayCity列表
        final cityList = cityListJsonStrings.map((jsonString) {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return DisplayCity.fromJson(json);
        }).toList();
        print('从本地存储加载城市列表成功');
        setState(() {
          _cityList = cityList;
          _isCityListLoading = false;

          // 确保当前城市索引有效
          if (_currentCityIndex >= _cityList.length) {
            _currentCityIndex = _cityList.length - 1;
          }
          if (_currentCityIndex < 0) {
            _currentCityIndex = 0;
          }

          // 如果有城市，更新当前选中的城市信息
          if (_cityList.isNotEmpty) {
            _currentLocation = _cityList[_currentCityIndex].id;
            _currentCityName = _cityList[_currentCityIndex].name;

            // 初始化Page控制器
            _pageController = PageController(initialPage: _currentCityIndex);
          }
        });
      } else {
        setState(() {
          _isCityListLoading = false;
        });
      }
    } catch (e) {
      print('从本地存储加载城市列表失败: $e');
      setState(() {
        _isCityListLoading = false;
      });
    }
  }

  // 添加城市到收藏列表 - 从city_page.dart迁移而来
  void addCity(DisplayCity city) {
    setState(() {
      // 检查城市是否已经存在
      final existingCityIndex = _cityList.indexWhere((c) => c.id == city.id);
      if (existingCityIndex == -1) {
        // 城市不存在，添加到列表
        _cityList.add(city);
        // 保存到本地存储
        _saveCityListToStorage(_cityList);
        print('城市已添加到收藏列表: ${city.name}');
      } else {
        // 城市已存在
        print('城市已在收藏列表中: ${city.name}');
      }
    });
  }

  // 删除选中的城市 - 从city_page.dart迁移而来
  void deleteCities(Set<String> cityIds) {
    if (cityIds.isEmpty) {
      return;
    }

    setState(() {
      // 获取当前城市ID
      String currentCityId = _currentLocation;

      // 删除选中的城市
      _cityList.removeWhere((city) => cityIds.contains(city.id));

      // 保存更新后的城市列表
      _saveCityListToStorage(_cityList);

      // 更新当前城市索引
      if (_cityList.isNotEmpty) {
        // 查找当前城市是否仍然存在
        int newIndex = _cityList.indexWhere((city) => city.id == currentCityId);

        if (newIndex != -1) {
          // 当前城市仍然存在，使用新索引
          _currentCityIndex = newIndex;
        } else {
          // 当前城市已被删除，使用最后一个城市作为当前城市
          _currentCityIndex = _cityList.length - 1;
        }

        // 更新当前城市信息
        _currentLocation = _cityList[_currentCityIndex].id;
        _currentCityName = _cityList[_currentCityIndex].name;

        // 确保PageView显示正确的页面
        _pageController?.jumpToPage(_currentCityIndex);
      } else {
        // 城市列表为空，重置索引
        _currentCityIndex = 0;
      }
    });
  }

  // 更新城市列表顺序 - 从city_page.dart迁移而来
  void updateCityListOrder(int oldIndex, int newIndex) {
    setState(() {
      // 调整newIndex，因为当从后往前拖动时，newIndex会变化
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      // 获取当前城市ID，用于后续更新索引
      String currentCityId = _currentLocation;

      // 移除旧位置的城市
      final DisplayCity city = _cityList.removeAt(oldIndex);
      // 在新位置插入城市
      _cityList.insert(newIndex, city);

      // 更新当前城市索引，确保它指向正确的城市
      _currentCityIndex = _cityList.indexWhere((c) => c.id == currentCityId);
      if (_currentCityIndex == -1) {
        _currentCityIndex = 0;
      }

      // 保存更新后的城市列表
      _saveCityListToStorage(_cityList);
    });
  }

  /// 切换到收藏列表页面
  void _switchToFavorites(DisplayCity? city) {
    // 无论是普通天气页面还是搜索结果页面，都可以切换到收藏列表
    if (_currentState == PageState.pageViewWeather ||
        _currentState == PageState.resultWeather) {
      // 如果有城市信息，设置要添加的城市
      if (city != null) {
        setState(() {
          addCity(city);
        });
      }

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
        // 返回到普通天气页面，而不是搜索结果页面
        _currentState = PageState.pageViewWeather;
        _isSearchResult = false;
      });
      _animationController.reverse();
    }
  }

  /// 选择城市并切换到天气页面
  void _selectCity(DisplayCity city, bool isSearchResult) {
    setState(() {
      _currentLocation = city.id;
      _currentCityName = city.name;
      _currentState = isSearchResult
          ? PageState.resultWeather
          : PageState.pageViewWeather;
      // 传递是否为搜索结果
      _isSearchResult = isSearchResult;
      // 更新当前选中的城市索引
      _currentCityIndex = _cityList.indexWhere((c) => c.id == city.id);
      if (_currentCityIndex == -1) {
        _currentCityIndex = 0;
      }
    });
    // 只有在非搜索结果模式下，才需要切换PageView页面
    if (!isSearchResult) {
      _pageController?.jumpToPage(_currentCityIndex);
    }
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
              onBackPress: () {
                // 从城市列表页面返回到天气页面
                _switchToWeather();
              },
              
              // 传递城市列表
              cityList: _cityList,
              // 传递删除城市回调
              onDeleteCities: deleteCities,
              // 传递更新城市列表顺序回调
              onUpdateCityOrder: updateCityListOrder,
              // 传递加载状态
              isLoading: _isCityListLoading,
            ),
          ),
          // 天气页面（顶层）
          Visibility(
            visible: true, // 始终可见，但通过动画控制显示/隐藏
            child: RepaintBoundary(
              // 隔离动画重绘区域，提高性能
              child: AnimatedBuilder(
                // 合并动画监听，减少重建次数
                animation: Listenable.merge([
                  _weatherScaleAnimation,
                  _weatherOpacityAnimation,
                ]),
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
                // 根据当前页面状态决定显示内容
                child: _currentState == PageState.resultWeather
                    ? WeatherPage(
                        id: _currentLocation,
                        cityName: _currentCityName,
                        // 传递回调函数给天气页面
                        onFavoritesPress: _switchToFavorites,
                        // 传递是否为搜索结果
                        isSearchResult: _isSearchResult,
                      )
                    : (_cityList.isEmpty
                          ? WeatherPage(
                              id: _currentLocation,
                              cityName: _currentCityName,
                              // 传递回调函数给天气页面
                              onFavoritesPress: _switchToFavorites,
                              // 传递是否为搜索结果
                              isSearchResult: _isSearchResult,
                            )
                          : PageView.builder(
                              // 使用Page控制器
                              controller: _pageController,
                              // 禁用页面过渡效果
                              physics: const PageScrollPhysics(),
                              // 当页面切换时，更新当前选中的城市索引
                              onPageChanged: (index) {
                                setState(() {
                                  _currentCityIndex = index;
                                  _currentLocation = _cityList[index].id;
                                  _currentCityName = _cityList[index].name;
                                });
                              },
                              // 根据城市列表生成多个WeatherPage
                              itemBuilder: (context, index) {
                                final city = _cityList[index];
                                return WeatherPage(
                                  id: city.id,
                                  cityName: city.name,
                                  // 传递回调函数给天气页面
                                  onFavoritesPress: _switchToFavorites,
                                  // 传递是否为搜索结果
                                  isSearchResult: _isSearchResult,
                                );
                              },
                              // 设置PageView的item数量为城市列表的长度
                              itemCount: _cityList.length,
                            )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
