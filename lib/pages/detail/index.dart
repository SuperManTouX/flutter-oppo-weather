import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import '../../models/display_city.dart';
import 'hourly_tab_content.dart';
import 'daily_tab_content.dart';
import 'future15_tab_content.dart';
import 'air_quality_tab_content.dart';

// 封装TabContent的组件，用于添加灰色间隔块
class TabContentWrapper extends StatelessWidget {
  final Widget child;
  final double height;
  final Color color;
  
  const TabContentWrapper({
    super.key,
    required this.child,
    this.height = 8,
    this.color = const Color.fromARGB(110, 158, 158, 158),
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 灰色间隔块
        SizedBox(
          height: height,
          width: double.infinity,
          child: ColoredBox(color: color),
        ),
        // 原始内容
        child,
      ],
    );
  }
}

class WeatherDetail extends StatefulWidget {
  final DisplayCity location;
  final int initialIndex;
  // 点击的日期，用于 DailyTabContent
  final Jiffy? clickedJDate;

  const WeatherDetail({
    super.key,
    required this.location,
    this.initialIndex = 0,
    this.clickedJDate,
  });

  @override
  State<WeatherDetail> createState() => _WeatherDetailState();
}

class _WeatherDetailState extends State<WeatherDetail>
    with SingleTickerProviderStateMixin {
  final List<String> _tabTitles = ['逐小时', '每日', '15天', '空气质量'];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // 初始化 TabController，使用从路由参数获取的initialIndex
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialIndex, // 使用路由参数中的索引
    );
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
              indicatorColor: const Color.fromARGB(255, 15, 15, 15), // 指示器颜色
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
          // 使用封装组件包裹每个TabContent
          TabContentWrapper(child: HourlyTabContent(location: widget.location)),
          TabContentWrapper(child: DailyTabContent(location: widget.location, clickedJDate: widget.clickedJDate)),
          TabContentWrapper(child: Future15TabContent(location: widget.location)),
          TabContentWrapper(child: AirQualityTabContent(location: widget.location)),
        ],
      ),
    );
  }
}
