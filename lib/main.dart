import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/routes/index.dart';
import 'package:jiffy/jiffy.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  Jiffy.setLocale("zh_cn");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '磨叽天气',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 31, 209, 25))),
      initialRoute: RouteNames.weather,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
