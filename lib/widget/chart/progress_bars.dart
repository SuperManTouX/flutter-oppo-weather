import 'package:flutter/material.dart';

// 3/4环形进度条组件
class CircularProgressBar extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final Color color;
  final List<Color>? gradientColors;
  final Color backgroundColor;
  final double size;
  final double strokeWidth;
  final bool showText;

  const CircularProgressBar({
    Key? key,
    required this.progress,
    this.color = Colors.blue,
    this.gradientColors,
    this.backgroundColor = Colors.grey,
    this.size = 150.0,
    this.strokeWidth = 15.0,
    this.showText = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 统一使用自定义绘制器实现3/4环形
          CustomPaint(
            painter: _CircularGradientPainter(
              progress: progress,
              gradientColors: gradientColors ?? [color],
              backgroundColor: backgroundColor,
              strokeWidth: strokeWidth,
              size: size,
            ),
          ),
          if (showText)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: size * 0.25,
                      fontWeight: FontWeight.bold,
                      color: gradientColors != null
                          ? gradientColors!.first
                          : color,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// 自定义3/4环形渐变绘制器
class _CircularGradientPainter extends CustomPainter {
  final double progress;
  final List<Color> gradientColors;
  final Color backgroundColor;
  final double strokeWidth;
  final double size;

  _CircularGradientPainter({
    required this.progress,
    required this.gradientColors,
    required this.backgroundColor,
    required this.strokeWidth,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final radius = (canvasSize.width - strokeWidth) / 2;

    // 3/4环形配置（270度），旋转135度
    final totalAngle = 4.71238898038; // 3π/2 radians (270 degrees)
    final rotationAngle = 2.35619449019; // 3π/4 radians (135 degrees) - 旋转角度
    final startAngle = rotationAngle; // 起始位置旋转135度
    final endAngle = startAngle + totalAngle; // 结束位置
    final sweepAngle = totalAngle * progress; // 当前进度对应的角度

    // 绘制背景圆环（3/4环形）
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      totalAngle,
      false,
      backgroundPaint,
    );

    // 只在进度大于0时绘制前景
    if (progress > 0) {
      // 创建渐变（覆盖完整的3/4环形范围）
      final gradient = SweepGradient(
        colors: gradientColors,
        startAngle: startAngle,
        endAngle: endAngle,
        tileMode: TileMode.clamp,
      );

      // 创建渐变画笔
      final gradientPaint = Paint()
        ..shader = gradient.createShader(
          Rect.fromCircle(center: center, radius: radius),
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      // 绘制渐变圆弧（当前进度）
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        gradientPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _CircularGradientPainter &&
        (oldDelegate.progress != progress ||
            oldDelegate.gradientColors != gradientColors ||
            oldDelegate.backgroundColor != backgroundColor ||
            oldDelegate.strokeWidth != strokeWidth ||
            oldDelegate.size != size);
  }
}

// 环形进度条组件（带动画）
class AnimatedCircularProgressBar extends StatefulWidget {
  final double progress;
  final Color color;
  final List<Color>? gradientColors;
  final Color backgroundColor;
  final double size;
  final double strokeWidth;
  final bool showText;

  const AnimatedCircularProgressBar({
    Key? key,
    required this.progress,
    this.color = Colors.blue,
    this.gradientColors,
    this.backgroundColor = Colors.grey,
    this.size = 150.0,
    this.strokeWidth = 15.0,
    this.showText = true,
  }) : super(key: key);

  @override
  State<AnimatedCircularProgressBar> createState() =>
      _AnimatedCircularProgressBarState();
}

class _AnimatedCircularProgressBarState
    extends State<AnimatedCircularProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.progress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedCircularProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress ||
        oldWidget.gradientColors != widget.gradientColors) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.progress,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CircularProgressBar(
          progress: _animation.value,
          color: widget.color,
          gradientColors: widget.gradientColors,
          backgroundColor: widget.backgroundColor,
          size: widget.size,
          strokeWidth: widget.strokeWidth,
          showText: widget.showText,
        );
      },
    );
  }
}

// 进度条演示页面（仅保留带渐变动画的环形进度条）
class ProgressBarDemo extends StatelessWidget {
  const ProgressBarDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '带渐变动画的环形进度条',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 40),

          // 第一组渐变环形进度条
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AnimatedCircularProgressBar(
                progress: 0.5,
                size: 150,
                strokeWidth: 15,
                gradientColors: [Colors.blue, Colors.purple],
                showText: true,
              ),
              AnimatedCircularProgressBar(
                progress: 0.8,
                size: 150,
                strokeWidth: 15,
                gradientColors: [Colors.green, Colors.blue],
                showText: true,
              ),
            ],
          ),
          const SizedBox(height: 40),

          // 第二组渐变环形进度条
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AnimatedCircularProgressBar(
                progress: 0.65,
                size: 150,
                strokeWidth: 15,
                gradientColors: [Colors.orange, Colors.red],
                showText: true,
              ),
              AnimatedCircularProgressBar(
                progress: 0.9,
                size: 150,
                strokeWidth: 15,
                gradientColors: [Colors.pink, Colors.purple],
                showText: true,
              ),
            ],
          ),
          const SizedBox(height: 40),

          // 第三组渐变环形进度条
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AnimatedCircularProgressBar(
                progress: 0.4,
                size: 150,
                strokeWidth: 15,
                gradientColors: [Colors.teal, Colors.blue],
                showText: true,
              ),
              AnimatedCircularProgressBar(
                progress: 0.75,
                size: 150,
                strokeWidth: 15,
                gradientColors: [Colors.yellow, Colors.orange],
                showText: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
