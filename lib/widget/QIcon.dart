import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class QIcon extends StatelessWidget {
  final String iconCode;
  final double size;

  const QIcon({
    super.key,
    required this.iconCode,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    // 拼接和风天气CDN图标地址（svg格式）
    String iconUrl = 'assets/QIcon/$iconCode.svg';
    
    return SvgPicture.asset(
      iconUrl,
      width: size,
      height: size,
      fit: BoxFit.contain,
      // 加载失败占位
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.error_outline, size: size, color: Colors.red);
      },
      
    );
  }
}
