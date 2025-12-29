import 'package:flutter/material.dart';
import '../../models/display_city.dart';
import 'hourly_tab_content.dart';
import 'daily_tab_content.dart';
import 'future15_tab_content.dart';
import 'air_quality_tab_content.dart';

class WeatherDetail extends StatelessWidget {
  final DisplayCity location;

  const WeatherDetail({super.key, required this.location});
  @override
  Widget build(BuildContext context) {
    // DefaultTabController 管理 Tab 切换状态，length 是 Tab 数量
    return DefaultTabController(
      length: 4, // 必须和 Tab 数量一致
      child: Scaffold(
        appBar: AppBar(
          title: Text('${location.name} 天气详情'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // 顶部 TabBar 配置
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: SizedBox(
              height: 48,
              child: TabBar(
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
                tabs: const [
                  Tab(text: '逐小时'),
                  Tab(text: '每日'),
                  Tab(text: '15日'),
                  Tab(text: '空气质量'),
                ],
              ),
            ),
          ),
        ),
        // 2. Tab 对应的内容页
        body: const TabBarView(
          // 注意：TabBarView 的子组件顺序必须和 TabBar 一一对应
          children: [
            HourlyTabContent(),
            DailyTabContent(),
            Future15TabContent(),
            AirQualityTabContent(),
          ],
        ),
      ),
    );
  }
}
