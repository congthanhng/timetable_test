import 'package:flutter/material.dart';
import 'package:timetable_test/timetable/resources.dart';

class TimetableBodyPaint extends CustomPainter {
  TimetableBodyPaint({
    required this.items,
    required this.screenWidth,
    this.presentWidthRate = TimetableResource.presentWidthRate,
    this.itemHeight = TimetableResource.itemHeight,
  });

  final double presentWidthRate;
  final double screenWidth;
  final double itemHeight;
  final List<String> items;

  @override
  void paint(Canvas canvas, Size size) {
    List.generate(items.length,(index) {
      _onDrawItem(canvas, size, index);
    },);
  }

  void _onDrawItem(Canvas canvas, Size size, int itemPosition) {
    final hourArea = screenWidth / presentWidthRate;
    final itemPain = Paint()
      ..color = Colors.grey[400]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final element in List.generate(24, (index) {
      return Rect.fromPoints(
        Offset(hourArea * index + 1, 0),
        Offset(
          hourArea * index + hourArea + 1,
          itemHeight * (itemPosition + 1),
        ),
      );
    })) {
      canvas.drawRect(element, itemPain);
    }
  }

  void _onDrawBG(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;
    final parentRect =
        Rect.fromPoints(Offset.zero, Offset(size.width, size.height));
    canvas.drawRect(parentRect, bgPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
