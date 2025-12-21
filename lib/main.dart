import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/routes/index.dart';
import 'package:jiffy/jiffy.dart';

void main() {
// 步骤1：确保 Flutter 绑定初始化（异步操作前必备，避免报错）
  WidgetsFlutterBinding.ensureInitialized();
  
  // 步骤2：全局设置中文（关键：await + Jiffy.locale("zh_cn")）
  // await Jiffy.locale("zh_cn");
  Jiffy.setLocale("zh_cn");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '磨叽天气',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      initialRoute: RouteNames.weather,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
