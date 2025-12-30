import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/models/weather/hourly.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter_oppo_weather/widget/Icon.dart';

class LineChartPainter extends CustomPainter {
  final List<Hourly> hourlyData;
  final int selectedIndex;
  final double pointWidth;

  LineChartPainter({
    required this.hourlyData,
    required this.selectedIndex,
    required this.pointWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final leftPadding = 0.0;
    final topPadding = 80.0;
    final bottomPadding = 30.0;

    final chartBottomY = size.height - bottomPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    final temperatures = hourlyData
        .map((d) => double.tryParse(d.temp) ?? 0)
        .toList();
    if (temperatures.isEmpty) return;
    final minTemp = temperatures.reduce((a, b) => a < b ? a : b) - 5;
    final maxTemp = temperatures.reduce((a, b) => a > b ? a : b) + 5;
    final tempRange = maxTemp - minTemp;

    final points = <Offset>[];
    for (int i = 0; i < hourlyData.length; i++) {
      final x = leftPadding + i * pointWidth + pointWidth / 2;
      final temp = double.tryParse(hourlyData[i].temp) ?? 0;
      var normalizedTemp = (temp - minTemp) / tempRange;
      normalizedTemp = normalizedTemp.clamp(0.0, 1.0);

      final y = chartBottomY - normalizedTemp * chartHeight;
      points.add(Offset(x, y));
    }

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

    final linePaint = Paint()
      ..color = Colors.blue
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

    final textPaint = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i < points.length; i++) {
      final isSelected = i == selectedIndex;
      final Color highlightColor = isSelected ? Colors.red : Colors.blue;
      // 绘制时间标签
      final timeStr = Jiffy.parse(
        hourlyData[i].fxTime,
        pattern: "yyyy-MM-dd'T'HH:mmZ",
      ).format(pattern: 'HH:mm');
      textPaint.text = TextSpan(
        text: timeStr,
        style: TextStyle(
          color: isSelected ? highlightColor : Colors.black,
          fontSize: 12,
        ),
      );
      textPaint.layout();
      textPaint.paint(canvas, Offset(points[i].dx - textPaint.width / 2, 10));

      textPaint.text = TextSpan(
        text: hourlyData[i].text,
        style: TextStyle(
          color: isSelected ? highlightColor : Colors.black,
          fontSize: 12,
        ),
      );
      textPaint.layout();
      textPaint.paint(canvas, Offset(points[i].dx - textPaint.width / 2, 25));

      textPaint.text = TextSpan(
        text: '${hourlyData[i].temp}°',
        style: TextStyle(
          color: highlightColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      );
      textPaint.layout();
      textPaint.paint(
        canvas,
        Offset(points[i].dx - textPaint.width / 2, points[i].dy - 20),
      );

      final dotPaint = Paint()..color = highlightColor;
      canvas.drawCircle(points[i], 5.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) {
    return oldDelegate.hourlyData != hourlyData ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}
