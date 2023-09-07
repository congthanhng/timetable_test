import 'package:flutter/material.dart';
import 'package:timetable_test/timetable/resources.dart';

class ItemHeaderPaint extends CustomPainter {
  ItemHeaderPaint({
    required this.items,
    required this.screenWidth,
    this.timeMilestoneHeight = TimetableResource.timeMilestoneHeight,
    this.timelineHeight = TimetableResource.timeLineHeight,
    this.presentWidthRate = TimetableResource.presentWidthRate,
  });

  final double timeMilestoneHeight;
  final double timelineHeight;
  final double presentWidthRate;
  final double screenWidth;
  final List<String> items;

  @override
  void paint(Canvas canvas, Size size) {
    _onDrawBG(canvas, size);
    _onDrawTimelines(canvas, size);
    _onDrawItem(canvas, size);
  }

  void _onDrawItem(Canvas canvas, Size size) {
    final hourArea = screenWidth / presentWidthRate;
    final itemPain = Paint()
      ..color = Colors.grey[400]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final element in List.generate(24, (index) {
      return Rect.fromPoints(
        Offset(hourArea * index + 1, TimetableResource.startTimelineDy),
        Offset(
          hourArea * index + hourArea + 1,
          TimetableResource.startTimelineDy + 40,
        ),
      );
    })) {
      canvas.drawRect(element, itemPain);
    }
  }

  void _onDrawTimelines(Canvas canvas, Size size) {
    final hourArea = screenWidth / presentWidthRate;
    final timeLinePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final list = List.generate(312, (index) {
      //draw timeline title
      if (index % 12 == 0) {
        _onDrawTimelineTitle(
          canvas,
          size,
          Offset(
              hourArea / 12 * index,
              TimetableResource.startTimelineDy -
                  ((index % 6 == 0) ? timeMilestoneHeight : timelineHeight)),
          '${(index ~/ 12) % 24}:00',
        );
      }

      return Rect.fromPoints(
        Offset(hourArea / 12 * index, TimetableResource.startTimelineDy),
        Offset(
          hourArea / 12 * index + ((index % 6 == 0) ? 2 : 1),
          TimetableResource.startTimelineDy -
              ((index % 6 == 0) ? timeMilestoneHeight : timelineHeight),
        ),
      );
    });

    for (final element in list) {
      canvas.drawRect(element, timeLinePaint);
    }
  }

  void _onDrawTimelineTitle(
      Canvas canvas,
      Size size,
      Offset offset,
      String title,
      ) {
    final textSpan = TextSpan(
      text: title,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 12,
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
        offset.dx - (textPainter.width / 2),
        offset.dy - textPainter.height,
      ),
    );
  }

  void _onDrawBG(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = Colors.red[50]!
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
