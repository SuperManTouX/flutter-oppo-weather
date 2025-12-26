import 'package:flutter/material.dart';

class WeatherDetail extends StatelessWidget {
  const WeatherDetail({super.key});

  // TabBar(
  //           controller: _controller,
  //           isScrollable: true,          // 关键：允许横向滚动
  //           tabAlignment: TabAlignment.start, // 起始对齐
  //           labelColor: Colors.white,
  //           unselectedLabelColor: Colors.white70,
  //           indicator: const BoxDecoration(
  //             border: Border(
  //               bottom: BorderSide(color: Colors.white, width: 3),
  //             ),
  //           ),
  //           tabs: tabs.map((t) => Tab(text: t)).toList(),
  //         )
  @override
  Widget build(BuildContext context) {
    // DefaultTabController 管理 Tab 切换状态，length 是 Tab 数量
    return DefaultTabController(
      length: 3, // 必须和 Tab 数量一致
      child: Scaffold(
        appBar: AppBar(
          title: const Text('天气详情'),
          backgroundColor: const Color.fromARGB(255, 45, 125, 241),
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
                  Tab(text: '今日', icon: Icon(Icons.sunny, size: 16)),
                  Tab(text: '未来7天', icon: Icon(Icons.calendar_today, size: 16)),
                  Tab(text: '空气质量', icon: Icon(Icons.air, size: 16)),
                ],
              ),
            ),
          ),
        ),
        // 2. Tab 对应的内容页
        body: const TabBarView(
          // 注意：TabBarView 的子组件顺序必须和 TabBar 一一对应
          children: [
            HomeTabContent(),
            MessageTabContent(),
            ProfileTabContent(),
          ],
        ),
      ),
    );
  }
}

// 各 Tab 对应的内容组件
class HomeTabContent extends StatelessWidget {
  const HomeTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('首页内容'));
  }
}

class MessageTabContent extends StatelessWidget {
  const MessageTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('消息内容'));
  }
}

class ProfileTabContent extends StatelessWidget {
  const ProfileTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('我的内容'));
  }
}
