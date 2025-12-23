import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/constants/index.dart';
import 'package:flutter_oppo_weather/models/city.dart';

class CityPage extends StatefulWidget {
  // 选择城市回调
  final Function(City)? onCitySelect;

  // 返回按钮点击回调
  final VoidCallback? onBackPress;

  const CityPage({super.key, this.onCitySelect, this.onBackPress});

  @override
  State<CityPage> createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> {
  // 城市列表
  List<City> favoriteCities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteCities();
  }

  // 异步加载收藏的城市列表
  Future<void> _loadFavoriteCities() async {
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
      final List<Future<City>> cityFutures = cityData.map((data) {
        return City.createWithWeather(
          name: data['name']!,
          location: data['location']!,
        );
      }).toList();

      // 等待所有城市数据加载完成
      favoriteCities = await Future.wait(cityFutures);
    } catch (e) {
      print('加载城市数据失败: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('城市管理'),
        leading: IconButton(
          onPressed: widget.onBackPress,
          icon: const Icon(Icons.arrow_back),
          tooltip: '返回天气页面',
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  sliver: SliverMainAxisGroup(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: '搜索城市',
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final city = favoriteCities[index];
                          return _buildCityItem(city);
                        }, childCount: favoriteCities.length),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  // 构建城市列表项
  Widget _buildCityItem(City city) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Material(
        // Material组件支持InkWell的水波纹效果
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
        child: InkWell(
          onTap: () {
            // 点击城市项，调用回调函数传递城市信息
            widget.onCitySelect?.call(city);
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
                    GradientColors.Weather2English[city.now?.text ?? "晴"] ??
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
}
