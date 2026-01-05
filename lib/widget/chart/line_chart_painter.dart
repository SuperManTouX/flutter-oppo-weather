import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/models/weather/hourly.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter_oppo_weather/widget/Icon.dart';
import 'package:flutter_oppo_weather/widget/chart/base_temperature_chart_painter.dart';

class LineChartPainter extends BaseTemperatureChartPainter<Hourly> {
  LineChartPainter({
    required List<Hourly> hourlyData,
    required int selectedIndex,
    required double pointWidth,
  }) : super(
    data: hourlyData,
    selectedIndex: selectedIndex,
    pointWidth: pointWidth,
  );

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // 使用基类方法计算图表尺寸和温度范围
    final metrics = calculateChartMetrics(size);

    // 计算温度点
    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final temp = double.tryParse(data[i].temp) ?? 0;
      final point = calculatePointPosition(
        i, 
        temp, 
        metrics.chartBottomY, 
        metrics.chartHeight, 
        metrics.minTemp, 
        metrics.tempRange
      );
      points.add(point);
    }

    // 使用基类方法绘制选中高亮区域
    drawSelectedHighlight(canvas, size, points);

    // 创建温度线数据结构
    final temperatureLine = TemperatureLine(
      points: points,
      lineColor: Colors.blue,
      pointColor: Colors.blue,
      temperatureLabels: data.map((d) => '${d.temp}°').toList(),
      temperatureLabelAlign: TextAlign.center,
    );

    // 使用基类方法绘制折线
    drawTemperatureLines(canvas, [temperatureLine]);

    // 绘制标签
    drawLabels(canvas, size, points);

    // 使用基类方法绘制温度点和值
    drawTemperaturePoints(canvas, temperatureLine);
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}
