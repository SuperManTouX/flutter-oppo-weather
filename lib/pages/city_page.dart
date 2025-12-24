import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/constants/index.dart';
import 'package:flutter_oppo_weather/models/display_city.dart';
import 'package:flutter_oppo_weather/models/search_city.dart';
import 'package:flutter_oppo_weather/services/weather/qweather_service.dart';

class CityPage extends StatefulWidget {
  // 选择城市回调
  final Function(DisplayCity, bool isSearchResult)? onCitySelect;

  // 返回按钮点击回调
  final VoidCallback? onBackPress;

  const CityPage({super.key, this.onCitySelect, this.onBackPress});

  @override
  State<CityPage> createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> {
  // 城市列表
  List<DisplayCity> _cityList = [];
  // 热门城市列表
  List<SearchCity> _topCityList = [];
  // 加载状态
  bool isLoading = true;
  // 搜索列表项
  final List<String> _searchListViewItems = List.generate(
    10,
    (index) => 'Search Item ${index + 1}',
  );
  // 搜索控制器
  final TextEditingController _searchController = TextEditingController();
  // 搜索焦点节点
  final FocusNode _searchFocusNode = FocusNode();
  // 是否搜索框获得焦点
  bool _isSearchFocused = false;
  @override
  void initState() {
    super.initState();
    _loadCityList();
    _loadTopCityList();
    _searchController.addListener(_filterItems);
    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        setState(() {
          _isSearchFocused = true;
        });
      }
    });
  }

  // 过滤搜索列表项
  void _filterItems() {
    String query = _searchController.text.toLowerCase();
    setState(() {});
  }

  // 异步加载收藏的城市列表
  Future<void> _loadCityList() async {
    setState(() {
      isLoading = true;
    });

    try {
      // 城市数据
      final List<Map<String, String>> cityData = [
        {'name': '北京', 'location': '101010100'},
        {'name': '上海', 'location': '101020100'},
        {'name': '广州', 'location': '101280101'},
        {'name': '深圳', 'location': '101280601'},
        {'name': '杭州', 'location': '101210101'},
        {'name': '成都', 'location': '101270101'},
        {'name': '重庆', 'location': '101040100'},
        {'name': '武汉', 'location': '101200101'},
        {'name': '西安', 'location': '101110101'},
        {'name': '南京', 'location': '101190101'},
      ];

      // 使用createWithWeather创建城市实例
      final List<Future<DisplayCity>> cityFutures = cityData.map((data) {
        return DisplayCity.createWithWeather(
          name: data['name']!,
          location: data['location']!,
        );
      }).toList();

      // 等待所有城市数据加载完成
      _cityList = await Future.wait(cityFutures);
    } catch (e) {
      print('加载城市数据失败: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // 获取热门城市列表
  Future<void> _loadTopCityList() async {
    setState(() {
      isLoading = true;
    });
    try {
      final service = QWeatherService();
      final topCityResponse = await service.getTopCityList();
      setState(() {
        _topCityList = topCityResponse.topCityList;
      });
    } catch (e) {
      print('加载热门城市列表失败: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 主内容区（含 AppBar）
          Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: AnimatedOpacity(
                opacity: _isSearchFocused ? 0.0 : 1.0,
                duration: Duration(milliseconds: 300),
                child: IgnorePointer(
                  ignoring: _isSearchFocused,
                  child: AppBar(title: Text('Search ListView')),
                ),
              ),
            ),
            body: Column(
              children: [
                // 占位：非聚焦时搜索栏位置（搜索时隐藏）
                AnimatedContainer(
                  height: _isSearchFocused ? 0 : 60,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      // 当搜索框获得焦点时，原始列表淡出
                      AnimatedOpacity(
                        opacity: _isSearchFocused ? 0.0 : 1.0,
                        duration: Duration(milliseconds: 300),
                        child: _cityList.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'No items found',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: _cityList.length,
                                itemBuilder: (context, index) {
                                  final city = _cityList[index];
                                  return _buildCityItem(city);
                                },
                              ),
                      ),
                      // 搜索结果列表，当搜索框获得焦点时淡入显示
                      AnimatedOpacity(
                        opacity: _isSearchFocused ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 300),
                        child: _isSearchFocused
                            ? CustomScrollView(
                                slivers: [
                                  SliverPadding(
                                    padding: EdgeInsets.all(10),
                                    sliver: SliverMainAxisGroup(
                                      slivers: [
                                        SliverToBoxAdapter(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [Text("热门城市")],
                                          ),
                                        ),
                                        // 热门城市网格
                                        SliverGrid(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 4,
                                                mainAxisSpacing: 10,
                                                crossAxisSpacing: 10,
                                                childAspectRatio: 5,
                                              ),
                                          delegate: SliverChildBuilderDelegate(
                                            (context, index) {
                                              // 获取完整的城市对象
                                              final city =
                                                  _topCityList[index %
                                                      _topCityList.length];
                                              return _buildSearchCityTag(city);
                                            },
                                            childCount: _topCityList
                                                .length, // 显示热门城市数量个标签
                                          ),
                                        ),
                                        SliverToBoxAdapter(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [Text("国际热门城市")],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 可移动的搜索栏
          AnimatedPositioned(
            top: _isSearchFocused
                ? MediaQuery.of(context).padding.top
                : kToolbarHeight + 10,
            left: 10,
            right: 10,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                // 取消按钮只在搜索界面显示
                if (_isSearchFocused)
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: TextButton(
                      onPressed: () {
                        _searchController.clear();
                        _searchFocusNode.unfocus();
                        setState(() {
                          _isSearchFocused = false;
                        });
                      },
                      child: Text(
                        '取消',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建城市列表项
  Widget _buildCityItem(DisplayCity city) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: Material(
        // Material组件支持InkWell的水波纹效果
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
        child: InkWell(
          onTap: () {
            // 点击城市项，调用回调函数传递城市信息
            widget.onCitySelect?.call(city, false);
          },
          borderRadius: BorderRadius.circular(8.0),
          // 渐变色盒子
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors:
                    GlobalConfig.Gradient_Colors_Weather2English[city
                            .now
                            ?.text ??
                        "晴"] ??
                    [Colors.blue, Colors.lightBlue],
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // 地区
                    Text(
                      city.name,
                      style: const TextStyle(
                        fontSize: 32.0,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    // 温度
                    Text(
                      city.now != null ? '${city.now?.temp}°' : '--',
                      style: const TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                // 空气质量和天气状态
                Row(
                  children: [
                    Text(
                      "空气优  90",
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 209, 208, 208),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      city.now?.text ?? "--",
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 构建搜索城市标签
  Widget _buildSearchCityTag(SearchCity city) {
    return Ink(
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.blue.shade300, width: 1),
      ),

      child: InkWell(
        onTap: () {
          // 将SearchCity转换为DisplayCity
          final displayCity = DisplayCity(
            name: city.name,
            location: city.id,
            now: null, // 初始时不包含天气数据
          );
          // 调用回调函数传递城市信息
          widget.onCitySelect?.call(displayCity, true);
        },
        borderRadius: BorderRadius.circular(25),
        child: Text(
          city.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blue.shade800,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
