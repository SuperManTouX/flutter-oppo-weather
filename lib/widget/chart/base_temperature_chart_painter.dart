import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/models/weather/daily.dart';

// 定义温度数据接口
abstract class TemperatureData {
  String get temperature;
  String get timeLabel;
  String get weekdayLabel;
  String get weatherText;
  String get iconCode;
}

// 定义温度线数据结构
class TemperatureLine {
  final List<Offset> points;
  final Color lineColor;
  final Color pointColor;
  final List<String> temperatureLabels;
  final TextAlign temperatureLabelAlign;

  TemperatureLine({
    required this.points,
    required this.lineColor,
    required this.pointColor,
    required this.temperatureLabels,
    this.temperatureLabelAlign = TextAlign.center,
  });
}

// 抽象温度图表绘制器基类
abstract class BaseTemperatureChartPainter<T extends TemperatureData> extends CustomPainter {
  final List<T> data;
  final int selectedIndex;
  final double pointWidth;

  BaseTemperatureChartPainter({
    required this.data,
    required this.selectedIndex,
    required this.pointWidth,
  });

  // 获取所有温度值用于计算范围
  List<double> getAllTemperatures() {
    return data
        .map((d) => double.tryParse(d.temperature) ?? 0)
        .toList();
  }

  // 计算图表尺寸和温度范围
  ({double chartBottomY, double chartHeight, double minTemp, double maxTemp, double tempRange}) 
      calculateChartMetrics(Size size) {
    final topPadding = 80.0;
    final bottomPadding = 30.0;

    final chartBottomY = size.height - bottomPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    final temperatures = getAllTemperatures();
    if (temperatures.isEmpty) {
      return (
        chartBottomY: chartBottomY,
        chartHeight: chartHeight,
        minTemp: 0,
        maxTemp: 40,
        tempRange: 40,
      );
    }
    final minTemp = temperatures.reduce((a, b) => a < b ? a : b) - 5;
    final maxTemp = temperatures.reduce((a, b) => a > b ? a : b) + 5;
    final tempRange = maxTemp - minTemp;

    return (
      chartBottomY: chartBottomY,
      chartHeight: chartHeight,
      minTemp: minTemp,
      maxTemp: maxTemp,
      tempRange: tempRange,
    );
  }

  // 计算点的位置
  Offset calculatePointPosition(int index, double temperature, 
      double chartBottomY, double chartHeight, double minTemp, double tempRange) {
    final leftPadding = 0.0;
    final x = leftPadding + index * pointWidth + pointWidth / 2;
    var normalizedTemp = (temperature - minTemp) / tempRange;
    normalizedTemp = normalizedTemp.clamp(0.0, 1.0);
    final y = chartBottomY - normalizedTemp * chartHeight;
    return Offset(x, y);
  }

  // 绘制选中高亮区域
  void drawSelectedHighlight(Canvas canvas, Size size, List<Offset> points) {
    if (selectedIndex != -1 && selectedIndex < points.length) {
      final selectedPoint = points[selectedIndex];
      final columnPaint = Paint()
        ..color = Colors.red.withOpacity(0.2)
        ..style = PaintingStyle.fill;
      final columnRect = Rect.fromLTRB(
        selectedPoint.dx - pointWidth / 2,
        0,
        selectedPoint.dx + pointWidth / 2,
        size.height,
      );
      canvas.drawRect(columnRect, columnPaint);
    }
  }

  // 绘制折线
  void drawLine(Canvas canvas, List<Offset> points, Color lineColor) {
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 0; i < points.length - 1; i++) {
        path.lineTo(points[i + 1].dx, points[i + 1].dy);
      }
    }
    canvas.drawPath(path, linePaint);
  }

  // 绘制所有温度线
  void drawTemperatureLines(Canvas canvas, List<TemperatureLine> lines) {
    for (var line in lines) {
      drawLine(canvas, line.points, line.lineColor);
    }
  }

  // 绘制时间标签和天气文本
  void drawLabels(Canvas canvas, Size size, List<Offset> referencePoints) {
    final textPaint = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i < data.length; i++) {
      final isSelected = i == selectedIndex;
      final highlightColor = isSelected ? Colors.red : Colors.black;
      final point = referencePoints[i];

      // 初始 Y 坐标偏移
      double yOffset = 0;

      // 只在 Daily 类型数据时绘制星期标签
      if (data[i] is Daily) {
        textPaint.text = TextSpan(
          text: data[i].weekdayLabel,
          style: TextStyle(
            color: highlightColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        );
        textPaint.layout();
        textPaint.paint(canvas, Offset(point.dx - textPaint.width / 2, yOffset));
        yOffset += 15; // 星期标签高度
      }

      // 绘制时间标签
      textPaint.text = TextSpan(
        text: data[i].timeLabel,
        style: TextStyle(
          color: highlightColor,
          fontSize: 12,
        ),
      );
      textPaint.layout();
      textPaint.paint(canvas, Offset(point.dx - textPaint.width / 2, yOffset));
      yOffset += 15; // 时间标签高度

      // 绘制天气文本
      textPaint.text = TextSpan(
        text: data[i].weatherText,
        style: TextStyle(
          color: highlightColor,
          fontSize: 12,
        ),
      );
      textPaint.layout();
      textPaint.paint(canvas, Offset(point.dx - textPaint.width / 2, yOffset));
    }
  }

  // 绘制温度值和点
  void drawTemperaturePoints(Canvas canvas, TemperatureLine line) {
    final textPaint = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i < line.points.length; i++) {
      final point = line.points[i];

      // 绘制温度值
      textPaint.text = TextSpan(
        text: line.temperatureLabels[i],
        style: TextStyle(
          color: line.pointColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      );
      textPaint.layout();

      // 根据对齐方式调整文本位置
      double yOffset = point.dy - 20;
      if (line.temperatureLabelAlign == TextAlign.end) {
        yOffset = point.dy + 5;
      }

      textPaint.paint(
        canvas,
        Offset(point.dx - textPaint.width / 2, yOffset),
      );

      // 绘制点
      final dotPaint = Paint()..color = line.pointColor;
      canvas.drawCircle(point, 5.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant BaseTemperatureChartPainter<T> oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}