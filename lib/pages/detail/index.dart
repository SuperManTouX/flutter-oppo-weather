import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/models/weather/daily.dart';
import 'package:flutter_oppo_weather/services/weather/qweather_service.dart';
import '../../models/display_city.dart';
import 'hourly_tab_content.dart';
import 'daily_tab_content.dart';
import 'future15_tab_content.dart';
import 'air_quality_tab_content.dart';

class WeatherDetail extends StatefulWidget {
  final DisplayCity location;
  final int initialIndex;

  const WeatherDetail({super.key, required this.location, this.initialIndex = 0});

  @override
  State<WeatherDetail> createState() => _WeatherDetailState();
}

class _WeatherDetailState extends State<WeatherDetail>
    with SingleTickerProviderStateMixin {
  final List<String> _tabTitles = ['逐小时', '7天', '15天', '空气质量'];
  bool _isLoading = false;
  List<Daily>? _forecastData;
  late TabController _tabController;

  // 获取七天的天气数据
  Future<void> _fetchWeatherForecast() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final service = QWeatherService();
      final data = await service.getWeather7d(location: widget.location.id);
      setState(() {
        _forecastData = data.daily;
        _isLoading = false;
      });
    } catch (e) {
      print('获取天气数据失败: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

 

  // 依据激活的tab，加载对应数据
  Future<void> _loadDataForActiveTab(int index) async {
    if (index == 0) {
      // 逐小时天气数据

    } else if (index == 1) {
      await _fetchWeatherForecast();
    } else if (index == 2) {
      // TODO(WIP): 15天天气数据
    } else if (index == 3) {
      // TODO(WIP): 空气质量数据
    }
  }

  @override
  void initState() {
    super.initState();
    // 初始化 TabController，使用从路由参数获取的initialIndex
    _tabController = TabController(
      length: 4, 
      vsync: this, 
      initialIndex: widget.initialIndex // 使用路由参数中的索引
    );
    // 添加 Tab 切换监听
    _tabController.addListener(() {
      print('当前tab索引: ${_tabController.index}');
      if (!_tabController.indexIsChanging) {
        // 当 Tab 切换完成时加载对应数据
        _loadDataForActiveTab(_tabController.index);
      }
    });
    // 使用路由参数中的索引加载对应tab的数据
    _loadDataForActiveTab(widget.initialIndex);
  }

  @override
  void dispose() {
    // 销毁 TabController
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.location.name} 天气详情'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // 顶部 TabBar 配置
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: SizedBox(
            height: 48,
            child: TabBar(
              controller: _tabController, // 使用我们自己的 TabController
              tabAlignment: TabAlignment.start, // 起始对齐 重要
              isScrollable: true, // 开启滚动（适配固定宽度+多Tab场景）
              indicatorSize: TabBarIndicatorSize.tab, // 指示器适配Tab宽度
              indicatorColor: Colors.white, // 指示器颜色
              indicatorWeight: 2, // 指示器高度（更细更协调）
              // 文字颜色配置
              unselectedLabelColor: const Color.fromARGB(179, 255, 255, 255),
              labelColor: Colors.white,
              // 文字样式（适配小高度）
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: const TextStyle(fontSize: 14),
              // Tab 内边距（替代固定宽度，避免滚动偏移）
              labelPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 2,
              ),
              // Tab 列表（天气场景适配）
              tabs: _tabTitles.map((title) => Tab(text: title)).toList(),
            ),
          ),
        ),
      ),
      // 2. Tab 对应的内容页
      body: TabBarView(
        controller: _tabController, // 使用我们自己的 TabController
        // 注意：TabBarView 的子组件顺序必须和 TabBar 一一对应
        children: [
          HourlyTabContent(
            location: widget.location,
          ),
          DailyTabContent(),
          Future15TabContent(),
          AirQualityTabContent(),
        ],
      ),
    );
  }
}
