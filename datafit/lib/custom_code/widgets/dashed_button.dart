// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class DashedButton extends StatefulWidget {
  const DashedButton({
    super.key,
    this.width,
    this.height,
    // Label
    required this.label,
    this.labelSize,
    this.labelColor,
    this.fontWeight,
    // Icon
    this.icon,
    this.iconSize,
    this.iconColor,
    this.iconGap,
    // Border
    this.borderColor,
    this.borderRadius,
    this.borderWidth,
    this.dashWidth,
    this.dashGap,
    // Background
    this.backgroundColor,
    // Padding
    this.horizontalPadding,
    this.verticalPadding,
    // Action
    this.onPressed,
  });

  final double? width;
  final double? height;

  // Label
  final String label;
  final double? labelSize;
  final Color? labelColor;
  final String? fontWeight; // 'normal' | 'medium' | 'semibold' | 'bold'

  // Icon
  final Widget? icon;
  final double? iconSize;
  final Color? iconColor;
  final double? iconGap;

  // Border
  final Color? borderColor;
  final double? borderRadius;
  final double? borderWidth;
  final double? dashWidth;
  final double? dashGap;

  // Background
  final Color? backgroundColor;

  // Padding
  final double? horizontalPadding;
  final double? verticalPadding;

  // Action
  final Future<dynamic> Function()? onPressed;

  @override
  State<DashedButton> createState() => _DashedButtonState();
}

class _DashedButtonState extends State<DashedButton> {
  bool _pressed = false;

  FontWeight _resolveFontWeight() {
    switch (widget.fontWeight) {
      case 'bold':
        return FontWeight.w700;
      case 'semibold':
        return FontWeight.w600;
      case 'medium':
        return FontWeight.w500;
      default:
        return FontWeight.w400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.borderColor ?? const Color(0xFFC4CDD6);
    final labelColor = widget.labelColor ?? const Color(0xFF536471);
    final bgColor = widget.backgroundColor ?? Colors.transparent;
    final radius = widget.borderRadius ?? 12.0;
    final dashW = widget.dashWidth ?? 6.0;
    final dashG = widget.dashGap ?? 4.0;
    final strokeW = widget.borderWidth ?? 1.5;
    final iconGap = widget.iconGap ?? 6.0;
    final hPad = widget.horizontalPadding ?? 16.0;
    final vPad = widget.verticalPadding ?? 10.0;
    final fontSize = widget.labelSize ?? 13.0;
    final iconSize = widget.iconSize ?? 14.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: CustomPaint(
            painter: _DashedBorderPainter(
              color: borderColor,
              radius: radius,
              strokeWidth: strokeW,
              dashWidth: dashW,
              dashGap: dashG,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(radius),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: hPad,
                vertical: vPad,
              ),
              child: Row(
                mainAxisSize:
                    widget.width != null ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    IconTheme(
                      data: IconThemeData(
                        size: iconSize,
                        color: widget.iconColor ?? labelColor,
                      ),
                      child: widget.icon!,
                    ),
                    SizedBox(width: iconGap),
                  ],
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: labelColor,
                      fontWeight: _resolveFontWeight(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;

  _DashedBorderPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashGap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(
          strokeWidth / 2,
          strokeWidth / 2,
          size.width - strokeWidth,
          size.height - strokeWidth,
        ),
        Radius.circular(radius),
      ));

    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final next = distance + (draw ? dashWidth : dashGap);
        if (draw) {
          canvas.drawPath(
            metric.extractPath(distance, next.clamp(0, metric.length)),
            paint,
          );
        }
        distance = next;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color ||
      old.radius != radius ||
      old.strokeWidth != strokeWidth ||
      old.dashWidth != dashWidth ||
      old.dashGap != dashGap;
}
