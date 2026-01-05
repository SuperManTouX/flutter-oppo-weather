import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/models/weather/daily.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter_oppo_weather/widget/Icon.dart';
import 'package:flutter_oppo_weather/widget/chart/base_temperature_chart_painter.dart';

class DailyLineChartPainter extends BaseTemperatureChartPainter<Daily> {
  DailyLineChartPainter({
    required List<Daily> dailyData,
    required int selectedIndex,
    required double pointWidth,
  }) : super(
    data: dailyData,
    selectedIndex: selectedIndex,
    pointWidth: pointWidth,
  );

  @override
  List<double> getAllTemperatures() {
    final maxTemperatures = data.map((d) => double.tryParse(d.tempMax) ?? 0).toList();
    final minTemperatures = data.map((d) => double.tryParse(d.tempMin) ?? 0).toList();
    return [...maxTemperatures, ...minTemperatures];
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // 使用基类方法计算图表尺寸和温度范围
    final metrics = calculateChartMetrics(size);

    // 计算最高温度点
    final maxTempPoints = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final temp = double.tryParse(data[i].tempMax) ?? 0;
      final point = calculatePointPosition(
        i, 
        temp, 
        metrics.chartBottomY, 
        metrics.chartHeight, 
        metrics.minTemp, 
        metrics.tempRange
      );
      maxTempPoints.add(point);
    }

    // 计算最低温度点
    final minTempPoints = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final temp = double.tryParse(data[i].tempMin) ?? 0;
      final point = calculatePointPosition(
        i, 
        temp, 
        metrics.chartBottomY, 
        metrics.chartHeight, 
        metrics.minTemp, 
        metrics.tempRange
      );
      minTempPoints.add(point);
    }

    // 使用基类方法绘制选中高亮区域
    drawSelectedHighlight(canvas, size, maxTempPoints);

    // 创建温度线数据结构
    final maxLine = TemperatureLine(
      points: maxTempPoints,
      lineColor: Colors.red,
      pointColor: Colors.red,
      temperatureLabels: data.map((d) => '${d.tempMax}°').toList(),
      temperatureLabelAlign: TextAlign.center,
    );

    final minLine = TemperatureLine(
      points: minTempPoints,
      lineColor: Colors.blue,
      pointColor: Colors.blue,
      temperatureLabels: data.map((d) => '${d.tempMin}°').toList(),
      temperatureLabelAlign: TextAlign.end,
    );

    // 使用基类方法绘制折线
    drawTemperatureLines(canvas, [maxLine, minLine]);

    // 绘制标签
    drawLabels(canvas, size, maxTempPoints);

    // 使用基类方法绘制温度点和值
    drawTemperaturePoints(canvas, maxLine);
    drawTemperaturePoints(canvas, minLine);
  }

  @override
  bool shouldRepaint(covariant DailyLineChartPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}