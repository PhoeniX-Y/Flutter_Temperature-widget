import 'dart:math';
import 'package:flutter/material.dart';

class SemiCircularTemperatureWidget extends StatefulWidget {
  final double temperature;
  final double radius;
  final double strokeWidth;
  final Color backgroundColor;
  final Color foregroundColor;
  final TextStyle textStyle;

  const SemiCircularTemperatureWidget({
    Key? key,
    required this.temperature,
    required this.radius,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.textStyle,
  }) : super(key: key);

  @override
  State<SemiCircularTemperatureWidget> createState() =>
      _SemiCircularTemperatureWidgetState();
}

class _SemiCircularTemperatureWidgetState
    extends State<SemiCircularTemperatureWidget>
    with SingleTickerProviderStateMixin {
  bool _isCelsius = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _displayTemperature {
    if (_isCelsius) {
      return widget.temperature;
    } else {
      return (widget.temperature * 9 / 5) + 32;
    }
  }

  void _toggleUnit() {
    setState(() {
      _isCelsius = !_isCelsius;
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleUnit,
      child: SizedBox(
        width: widget.radius * 2,
        height: widget.radius + 50,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(widget.radius * 2, widget.radius * 2),
              painter: _SemiCirclePainter(
                progress: _animation,
                backgroundColor: widget.backgroundColor,
                foregroundColor: widget.foregroundColor,
                strokeWidth: widget.strokeWidth,
              ),
            ),
            Positioned(
              bottom: widget.radius * 0.2,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _animation.value,
                    child: Text(
                      '${_displayTemperature.toStringAsFixed(1)}°${_isCelsius ? 'C' : 'F'}',
                      style: widget.textStyle,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SemiCirclePainter extends CustomPainter {
  final Animation<double> progress;
  final Color backgroundColor;
  final Color foregroundColor;
  final double strokeWidth;

  _SemiCirclePainter({
    required this.progress,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.strokeWidth,
  }) : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth / 2;

    // Draw background arc
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      backgroundPaint,
    );

    // Draw foreground arc
    final foregroundPaint = Paint()
      ..color = foregroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi * progress.value,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(_SemiCirclePainter oldDelegate) {
    return true;
  }
}
