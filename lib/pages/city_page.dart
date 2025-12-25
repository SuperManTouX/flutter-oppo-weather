import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/constants/index.dart';
import 'package:flutter_oppo_weather/models/display_city.dart';
import 'package:flutter_oppo_weather/models/search_city.dart';
import 'package:flutter_oppo_weather/services/weather/qweather_service.dart';
import 'package:flutter_oppo_weather/widget/Icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CityPage extends StatefulWidget {
  // 选择城市回调
  final Function(DisplayCity, bool isSearchResult)? onCitySelect;

  // 返回按钮点击回调
  final VoidCallback? onBackPress;

  // 城市列表 - 从父组件传入
  final List<DisplayCity> cityList;

  // 删除城市回调
  final Function(Set<String>)? onDeleteCities;

  // 更新城市列表顺序回调
  final Function(int, int)? onUpdateCityOrder;

  // 加载状态
  final bool isLoading;

  const CityPage({
    super.key,
    this.onCitySelect,
    this.onBackPress,
    required this.cityList,
    this.onDeleteCities,
    this.onUpdateCityOrder,
    this.isLoading = false,
  });

  @override
  State<CityPage> createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> {
  // 热门城市列表
  List<SearchCity> _topCityList = [];

  // 搜索控制器
  final TextEditingController _searchController = TextEditingController();
  // 搜索焦点节点
  final FocusNode _searchFocusNode = FocusNode();
  // 是否搜索框获得焦点
  bool _isSearchFocused = false;
  // 搜索结果列表
  List<SearchCity> _searchResults = [];
  // 搜索加载状态
  bool _isSearchLoading = false;

  // 多选模式状态
  bool _isMultiSelectMode = false;
  // 选中的城市ID列表
  Set<String> _selectedCityIds = {};
  @override
  void initState() {
    super.initState();
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
  void _filterItems() async {
    String query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
        _isSearchLoading = false;
      });
      return;
    }

    setState(() {
      _isSearchLoading = true;
    });

    try {
      final service = QWeatherService();
      final response = await service.searchCity(keyword: query);
      setState(() {
        _searchResults = response.location;
        _isSearchLoading = false;
      });
    } catch (e) {
      print('搜索城市失败: $e');
      setState(() {
        _searchResults.clear();
        _isSearchLoading = false;
      });
    }
  }

  // 删除选中的城市
  void _deleteSelectedCities() {
    if (_selectedCityIds.isEmpty) {
      // 没有选中任何城市，退出多选模式
      setState(() {
        _isMultiSelectMode = false;
        _selectedCityIds.clear();
      });
      return;
    }

    // 调用父组件的删除城市回调
    if (widget.onDeleteCities != null) {
      widget.onDeleteCities!(_selectedCityIds);
    }

    // 退出多选模式
    setState(() {
      _isMultiSelectMode = false;
      _selectedCityIds.clear();
    });
  }

  // 获取热门城市列表
  Future<void> _loadTopCityList() async {
    try {
      final service = QWeatherService();
      final topCityResponse = await service.getTopCityList();
      setState(() {
        _topCityList = topCityResponse.topCityList;
      });
    } catch (e) {
      print('加载热门城市列表失败: $e');
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
                  child: AppBar(
                    title: Text('城市列表'),
                    actions: [
                      // 只在多选模式下显示退出按钮
                      if (_isMultiSelectMode)
                        IconButton(
                          onPressed: () {
                            // 退出多选模式 并清空选中的城市
                            setState(() {
                              _isMultiSelectMode = false;
                              _selectedCityIds.clear();
                            });
                          },
                          icon: Icon(Icons.close),
                          tooltip: "取消",
                        ),
                      IconButton(
                        icon: Icon(
                          _isMultiSelectMode
                              ? Icons.delete_outline
                              : Icons.multiple_stop,
                        ),
                        tooltip: _isMultiSelectMode ? '删除选中项' : '多选',
                        onPressed: () {
                          if (_isMultiSelectMode) {
                            // 删除选中的城市
                            _deleteSelectedCities();
                          } else {
                            // 进入多选模式
                            setState(() {
                              _isMultiSelectMode = true;
                            });
                          }
                        },
                      ),
                    ],
                  ),
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
                        child: widget.cityList.isEmpty
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
                            : _isMultiSelectMode
                            ? ReorderableListView.builder(
                                itemCount: widget.cityList.length,
                                itemBuilder: (context, index) {
                                  final city = widget.cityList[index];
                                  return _buildCityItem(city);
                                },
                                onReorder: (oldIndex, newIndex) {
                                  // 调用父组件的更新城市列表顺序回调
                                  if (widget.onUpdateCityOrder != null) {
                                    widget.onUpdateCityOrder!(
                                      oldIndex,
                                      newIndex,
                                    );
                                  }
                                },
                              )
                            : ListView.builder(
                                itemCount: widget.cityList.length,
                                itemBuilder: (context, index) {
                                  final city = widget.cityList[index];
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
                                        
                                        // 搜索结果
                                        if (_searchController.text.isNotEmpty)
                                          SliverToBoxAdapter(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                top: 20,
                                                bottom: 10,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [Text("搜索结果")],
                                              ),
                                            ),
                                          ),
                                        // 搜索结果列表
                                        if (_isSearchLoading)
                                          SliverToBoxAdapter(
                                            child: Padding(
                                              padding: EdgeInsets.all(20),
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ),
                                          )
                                        else if (_searchResults.isNotEmpty)
                                          SliverList(
                                            delegate: SliverChildBuilderDelegate(
                                              (context, index) {
                                                final city =
                                                    _searchResults[index];
                                                return _buildSearchResultItem(
                                                  city,
                                                );
                                              },
                                              childCount: _searchResults.length,
                                            ),
                                          )
                                        else if (_searchController
                                            .text
                                            .isNotEmpty)
                                          SliverToBoxAdapter(
                                            child: Padding(
                                              padding: EdgeInsets.all(20),
                                              child: Center(
                                                child: Text("未找到相关城市"),
                                              ),
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
    // 为ReorderableListView提供唯一的key
    final key = ValueKey(city.id);
    final isSelected = _selectedCityIds.contains(city.id);

    return Padding(
      key: key,
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: Material(
        // Material组件支持InkWell的水波纹效果
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
        child: InkWell(
          onTap: () {
            if (_isMultiSelectMode) {
              // 多选模式下，切换选中状态
              setState(() {
                if (isSelected) {
                  _selectedCityIds.remove(city.id);
                } else {
                  _selectedCityIds.add(city.id);
                }
              });
            } else {
              // 正常模式下，调用回调函数传递城市信息
              widget.onCitySelect?.call(city, false);
            }
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
              border: isSelected
                  ? Border.all(color: Colors.white, width: 2)
                  : null,
            ),
            child: Stack(
              children: [
                Column(
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
                // 多选模式下显示复选框
                if (_isMultiSelectMode)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedCityIds.add(city.id);
                          } else {
                            _selectedCityIds.remove(city.id);
                          }
                        });
                      },
                      checkColor: Colors.blue,
                      fillColor: MaterialStateProperty.all(Colors.white),
                    ),
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
            id: city.id,
            now: null, // 初始时不包含天气数据
          );
          // 调用回调函数传递城市信息
          widget.onCitySelect?.call(displayCity, true);
        },
        borderRadius: BorderRadius.circular(25),
        child: Center(
          child: Text(
            city.name,
            style: TextStyle(
              color: Colors.blue.shade800,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  // 构建搜索结果项
  Widget _buildSearchResultItem(SearchCity city) {
    return Ink(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: InkWell(
        onTap: () {
          // 将SearchCity转换为DisplayCity
          final displayCity = DisplayCity(
            name: city.name,
            id: city.id,
            now: null, // 初始时不包含天气数据
          );
          // 调用回调函数传递城市信息
          widget.onCitySelect?.call(displayCity, true);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                city.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 4),
              Text(
                '${city.adm1}, ${city.country}',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
