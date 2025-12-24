import 'package:flutter/material.dart';

class AppTheme {
  // 主色调
  static const Color primaryColor = Color(0xFF4A90E2);
  static const Color primaryLight = Color(0xFF7FB8E7);
  static const Color primaryDark = Color(0xFF1A68C4);
  
  // 辅助色
  static const Color secondaryColor = Color(0xFF50E3C2);
  static const Color accentColor = Color(0xFFFF9500);
  
  // 文字颜色
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF999999);
  
  // 背景色
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardColor = Color(0xFFFFFFFF);
  
  // 状态色
  static const Color successColor = Color(0xFF4CD964);
  static const Color warningColor = Color(0xFFFFCC00);
  static const Color errorColor = Color(0xFFFF3B30);
  static const Color infoColor = Color(0xFF34AADC);
  
  // 边框圆角
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusExtraLarge = 24.0;
  
  // 阴影
  static const BoxShadow shadowSmall = BoxShadow(
    color: Colors.black12,
    blurRadius: 2.0,
    spreadRadius: 1.0,
    offset: Offset(0, 1),
  );
  
  static const BoxShadow shadowMedium = BoxShadow(
    color: Colors.black12,
    blurRadius: 4.0,
    spreadRadius: 2.0,
    offset: Offset(0, 2),
  );
  
  static const BoxShadow shadowLarge = BoxShadow(
    color: Colors.black12,
    blurRadius: 8.0,
    spreadRadius: 4.0,
    offset: Offset(0, 4),
  );
  
  // 亮色主题
  static ThemeData lightTheme = ThemeData(
    // 主要配置
    primaryColor: primaryColor,
    primaryColorLight: primaryLight,
    primaryColorDark: primaryDark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      primary: primaryColor,
      secondary: secondaryColor,
      background: backgroundLight,
      surface: cardColor,
      error: errorColor,
      onPrimary: textLight,
      onSecondary: textPrimary,
      onBackground: textPrimary,
      onSurface: textPrimary,
      onError: textLight,
    ),
    
    // 文字主题
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontSize: 16.0),
      bodyMedium: TextStyle(fontSize: 14.0),
      bodySmall: TextStyle(fontSize: 12.0),
      labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      labelMedium: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
      labelSmall: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
    ),
    
    // 背景主题
    scaffoldBackgroundColor: backgroundLight,
    cardColor: cardColor,
    
    // 按钮主题
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        textStyle: const TextStyle(fontWeight: FontWeight.w500),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: const TextStyle(fontWeight: FontWeight.w500),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
    ),
    
    // 输入框主题
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: BorderSide(color: primaryLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: BorderSide(color: primaryLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    
    // 卡片主题
    cardTheme: CardThemeData(
      color: cardColor,
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
      ),
    ),
    
    // 分割线主题
    dividerTheme: DividerThemeData(
      color: Colors.black12,
      thickness: 1.0,
      space: 1.0,
    ),
    
    // 底部导航栏主题
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: cardColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: textGrey,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
      unselectedLabelStyle: const TextStyle(),
      type: BottomNavigationBarType.fixed,
    ),
    
    // 应用栏主题
    appBarTheme: AppBarTheme(
      backgroundColor: cardColor,
      foregroundColor: textPrimary,
      elevation: 0,
      shadowColor: Colors.transparent,
      titleTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    
    // 图标主题
    iconTheme: IconThemeData(
      color: textPrimary,
      size: 24,
    ),
    
    // 弹窗主题
    dialogTheme: DialogThemeData(
      backgroundColor: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusLarge),
      ),
      titleTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    
    // 页面过渡主题
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
  
  // 暗色主题
  static ThemeData darkTheme = ThemeData(
    // 主要配置
    primaryColor: primaryColor,
    primaryColorLight: primaryLight,
    primaryColorDark: primaryDark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      primary: primaryColor,
      secondary: secondaryColor,
      background: backgroundDark,
      surface: Color(0xFF1E1E1E),
      error: errorColor,
      onPrimary: textLight,
      onSecondary: textLight,
      onBackground: textLight,
      onSurface: textLight,
      onError: textLight,
    ),
    
    // 文字主题
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontSize: 16.0),
      bodyMedium: TextStyle(fontSize: 14.0),
      bodySmall: TextStyle(fontSize: 12.0),
      labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      labelMedium: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
      labelSmall: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
    ).apply(
      bodyColor: textLight,
      displayColor: textLight,
    ),
    
    // 背景主题
    scaffoldBackgroundColor: backgroundDark,
    cardColor: Color(0xFF1E1E1E),
    
    // 按钮主题
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        textStyle: const TextStyle(fontWeight: FontWeight.w500),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: const TextStyle(fontWeight: FontWeight.w500),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
    ),
    
    // 输入框主题
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: BorderSide(color: textGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: BorderSide(color: textGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: TextStyle(color: textGrey),
    ),
    
    // 卡片主题
    cardTheme: CardThemeData(
      color: Color(0xFF1E1E1E),
      elevation: 4,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
      ),
    ),
    
    // 分割线主题
    dividerTheme: DividerThemeData(
      color: Colors.white12,
      thickness: 1.0,
      space: 1.0,
    ),
    
    // 底部导航栏主题
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: primaryColor,
      unselectedItemColor: textGrey,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
      unselectedLabelStyle: const TextStyle(),
      type: BottomNavigationBarType.fixed,
    ),
    
    // 应用栏主题
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: textLight,
      elevation: 0,
      shadowColor: Colors.transparent,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    
    // 图标主题
    iconTheme: IconThemeData(
      color: textLight,
      size: 24,
    ),
    
    // 弹窗主题
    dialogTheme: DialogThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusLarge),
      ),
      titleTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textLight,
      ),
      contentTextStyle: TextStyle(color: textLight),
    ),
  );
  
  // 获取当前主题（可根据系统设置自动切换明暗主题）
  static ThemeData getTheme(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.light ? lightTheme : darkTheme;
  }
}

// 常用文本样式扩展
class AppTextStyles {
  static const TextStyle weatherTemperature = TextStyle(
    fontSize: 100,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  static const TextStyle weatherCondition = TextStyle(
    fontSize: 24,
    color: Colors.white,
  );
  
  static const TextStyle weatherSubtitle = TextStyle(
    fontSize: 14,
    color: Colors.white70,
  );
  
  static const TextStyle hourlyWeatherTime = TextStyle(
    fontSize: 14,
    color: Colors.white,
  );
  
  static const TextStyle hourlyWeatherTemp = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}
