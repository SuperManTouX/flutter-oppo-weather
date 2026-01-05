import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/models/weather/daily.dart';
import 'package:flutter_oppo_weather/widget/Icon.dart';
import 'daily_line_chart_painter.dart';

class InteractiveDailyTemperatureChart extends StatelessWidget {
  final List<Daily>? dailyData;
  final int selectedIndex;
  final Function(int)? onSelectedIndexChanged;

  const InteractiveDailyTemperatureChart({
    super.key,
    this.dailyData,
    this.selectedIndex = -1,
    this.onSelectedIndexChanged,
  });

  void _onChartTapped(TapUpDetails details, GlobalKey chartKey) {
    if (dailyData == null || dailyData!.isEmpty) return;

    final renderBox = chartKey.currentContext!.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    final pointWidth = 70.0;
    final tappedIndex = (localPosition.dx / pointWidth).floor();

    if (tappedIndex >= 0 && tappedIndex < dailyData!.length) {
      final newIndex = selectedIndex == tappedIndex ? -1 : tappedIndex;
      onSelectedIndexChanged?.call(newIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pointWidth = 70.0;
    final chartHeight = 240.0;
    final chartKey = GlobalKey();

    if (dailyData == null || dailyData!.isEmpty) {
      return SizedBox(
        height: chartHeight,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final chartTotalWidth = dailyData!.length * pointWidth;

    return GestureDetector(
      onTapUp: (details) => _onChartTapped(details, chartKey),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          key: chartKey,
          width: chartTotalWidth,
          height: chartHeight,
          child: Stack(
            children: [
              ...List.generate(dailyData!.length, (index) {
                final x = index * pointWidth + pointWidth / 2;
                return Positioned(
                  left: x - 12,
                  top: 40,
                  child: QIcon(
                    iconCode: dailyData![index].iconDay,
                    size: 24,
                  ),
                );
              }),
              SizedBox(
                height: chartHeight,
                child: CustomPaint(
                  painter: DailyLineChartPainter(
                    dailyData: dailyData!,
                    selectedIndex: selectedIndex,
                    pointWidth: pointWidth,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}