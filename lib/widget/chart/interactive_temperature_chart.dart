import 'package:flutter/material.dart';
import 'package:flutter_oppo_weather/models/weather/hourly.dart';
import 'package:flutter_oppo_weather/widget/Icon.dart';
import 'line_chart_painter.dart';

class InteractiveTemperatureChart extends StatelessWidget {
  final List<Hourly>? hourlyData;
  final int selectedIndex;
  final Function(int)? onSelectedIndexChanged;

  const InteractiveTemperatureChart({
    super.key,
    this.hourlyData,
    this.selectedIndex = -1,
    this.onSelectedIndexChanged,
  });

  void _onChartTapped(TapUpDetails details, GlobalKey chartKey) {
    if (hourlyData == null || hourlyData!.isEmpty) return;

    final renderBox = chartKey.currentContext!.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    final pointWidth = 70.0;
    final tappedIndex = (localPosition.dx / pointWidth).floor();

    if (tappedIndex >= 0 && tappedIndex < hourlyData!.length) {
      final newIndex = selectedIndex == tappedIndex ? -1 : tappedIndex;
      onSelectedIndexChanged?.call(newIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pointWidth = 70.0;
    final chartHeight = 240.0;
    final chartKey = GlobalKey();

    if (hourlyData == null || hourlyData!.isEmpty) {
      return SizedBox(
        height: chartHeight,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final chartTotalWidth = hourlyData!.length * pointWidth;

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
              ...List.generate(hourlyData!.length, (index) {
                final x = index * pointWidth + pointWidth / 2;
                return Positioned(
                  left: x - 12,
                  top: 40,
                  child: QIcon(
                    iconCode: hourlyData![index].icon,
                    size: 24,
                  ),
                );
              }),
              SizedBox(
                height: chartHeight,
                child: CustomPaint(
                  painter: LineChartPainter(
                    hourlyData: hourlyData!,
                    selectedIndex: selectedIndex,
                    pointWidth: pointWidth,
                    colorScheme: Theme.of(context).colorScheme,
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
