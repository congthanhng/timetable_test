import 'package:flutter/material.dart';
import 'package:timetable_test/timetable/resources.dart';

class TimelineHeaderPaint extends CustomPainter {
  TimelineHeaderPaint({
    required this.screenWidth,
    this.timeMilestoneHeight = TimetableResource.timeMilestoneHeight,
    this.timelineHeight = TimetableResource.timeLineHeight,
    this.presentWidthRate = TimetableResource.presentWidthRate,
  });

  final double timeMilestoneHeight;
  final double timelineHeight;
  final double presentWidthRate;
  final double screenWidth;

  @override
  void paint(Canvas canvas, Size size) {
    _onDrawBG(canvas, size);
    _onDrawTimelines(canvas, size);
  }

  void _onDrawTimelines(Canvas canvas, Size size) {
    final hourArea = screenWidth / presentWidthRate;
    final timeLinePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final firstPaint = Paint()
      ..color = Colors.grey[400]!
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

      return index == 0
          ? Rect.fromPoints(
              const Offset(0, TimetableResource.startTimelineDy),
              const Offset(2, 0),
            )
          : Rect.fromPoints(
              Offset(hourArea / 12 * index, TimetableResource.startTimelineDy),
              Offset(
                hourArea / 12 * index + ((index % 6 == 0) ? 2 : 1),
                TimetableResource.startTimelineDy -
                    ((index % 6 == 0) ? timeMilestoneHeight : timelineHeight),
              ),
            );
    });

    for (var i = 0; i < list.length; i++) {
      if (i == 0) {
        canvas.drawRect(list[i], firstPaint);
      } else {
        canvas.drawRect(list[i], timeLinePaint);
      }
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
      ..color = Colors.deepOrange[200]!
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
