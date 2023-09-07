import 'package:flutter/material.dart';
import 'package:timetable_test/timetable/resources.dart';
import 'package:timetable_test/utils/number_extension.dart';

final class TimetableBodyPaint extends CustomPainter {
  TimetableBodyPaint({
    required this.items,
    required this.screenWidth,
    this.selectedOffset,
    this.presentWidthRate = TimetableResource.presentWidthRate,
    this.itemHeight = TimetableResource.itemHeight,
  });

  final double presentWidthRate;
  final double screenWidth;
  final double itemHeight;
  final List<String> items;
  final Offset? selectedOffset;

  @override
  void paint(Canvas canvas, Size size) {
    List.generate(
      items.length,
      (index) {
        _onDrawItem(canvas, size, index);
      },
    );

    if (selectedOffset != null) {
      _onDrawSelectedItem(canvas, size, selectedOffset!);
    }
  }

  void _onDrawSelectedItem(Canvas canvas, Size size, Offset offset) {
    final hourArea = screenWidth / presentWidthRate;
    final itemPain = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final itemPosition = offset.dy ~/ itemHeight;
    final dy = ((itemPosition + 1) * itemHeight) - (itemHeight / 2);

    var hour = offset.dx ~/ hourArea;
    var minute = ((offset.dx / hourArea) * 60) % 60;

    //condition for range of time below 1 or over 23
    if (hour == 0) {
      hour = 1;
      minute = 0;
    } else if (hour == 23) {
      minute = 0;
    }

    final dx = (hour * hourArea) + ((hourArea / 12) * (minute ~/ 5));
    final rect = Rect.fromCenter(
      center: Offset(dx, dy),
      height: TimetableResource.itemHeight,
      width: hourArea * 2,
    );

    final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(6));
    canvas.drawRRect(rRect, itemPain);
    _onDrawRangeTime(canvas, size, hour, minute, Offset(dx, dy));
  }

  void _onDrawRangeTime(
    Canvas canvas,
    Size size,
    int hour,
    double minute,
    Offset centerPoint,
  ) {
    final roundMinute = (minute ~/ 5) * 5;
    final textSpan = TextSpan(
      text:
          '${(hour - 1).padLeftNum()}:${roundMinute.padLeftNum()} - ${(hour + 1).padLeftNum()}:${roundMinute.padLeftNum()}',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
    );
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout(
        maxWidth: size.width,
      );
    textPainter.paint(
      canvas,
      Offset(
        centerPoint.dx - (textPainter.width / 2),
        centerPoint.dy - (textPainter.height / 2),
      ),
    );
  }

  void _onDrawItem(Canvas canvas, Size size, int itemPosition) {
    final hourArea = screenWidth / presentWidthRate;
    final itemPain = Paint()
      ..color = itemPosition.isOdd ? Colors.grey[200]! : Colors.white
      ..style = PaintingStyle.fill;

    final itemStokePain = Paint()
      ..color = Colors.grey[400]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final element in List.generate(
      24,
      (index) => Rect.fromPoints(
        Offset(hourArea * index + 1, itemHeight * itemPosition),
        Offset(
          hourArea * index + hourArea + 1,
          itemHeight * (itemPosition + 1),
        ),
      ),
    )) {
      canvas
        ..drawRect(element, itemPain)
        ..drawRect(element, itemStokePain);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
