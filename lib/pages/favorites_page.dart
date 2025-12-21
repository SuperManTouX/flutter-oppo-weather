import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/models/city.dart';
import 'package:flutter_oppo_weather/routes/index.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});
  
  // 模拟收藏的城市列表
  final List<City> favoriteCities = const [
    City(name: '北京', location: '101010100'),
    City(name: '上海', location: '101020100'),
    City(name: '广州', location: '101280101'),
    City(name: '深圳', location: '101280601'),
    City(name: '杭州', location: '101210101'),
    City(name: '成都', location: '101270101'),
    City(name: '重庆', location: '101040100'),
    City(name: '武汉', location: '101200101'),
    City(name: '西安', location: '101110101'),
    City(name: '南京', location: '101190101'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('我的收藏'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          tooltip: '返回天气页面',
        ),
      ),
      body: ListView.builder(
        itemCount: favoriteCities.length,
        itemBuilder: (context, index) {
          final city = favoriteCities[index];
          return ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: Text(city.name),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // 点击城市项，跳转到天气页面并传递城市信息
              Navigator.pushNamed(
                context,
                RouteNames.weather,
                arguments: {
                  'location': city.location,
                  'cityName': city.name,
                },
              );
            },
          );
        },
      ),
    );
  }
}