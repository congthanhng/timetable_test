import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetable_test/timetable/cubit/time_table_cubit.dart';
import 'package:timetable_test/timetable/data/mock_data.dart';
import 'package:timetable_test/timetable/resources.dart';
import 'package:timetable_test/timetable/view/components/timeline_header_paint.dart';
import 'package:timetable_test/timetable/view/components/timetable_body_paint.dart';

class TimetableLayout extends StatefulWidget {
  const TimetableLayout({super.key});

  @override
  State<TimetableLayout> createState() => _TimetableLayoutState();
}

class _TimetableLayoutState extends State<TimetableLayout> {
  final _verScroll = ScrollController();
  final _horScroll = ScrollController();
  final _horTimelineHeaderScroll = ScrollController();
  final _verItemScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.deepOrange[200],
                border: Border(right: BorderSide(color: Colors.grey[400]!)),
              ),
              width: MediaQuery.sizeOf(context).width /
                  TimetableResource.presentWidthRate,
              height: TimetableResource.startTimelineDy,
              child: const Center(child: Text('Table (Timeline)')),
            ),
            Expanded(
              child: SizedBox(
                height: tableMockList.length * TimetableResource.itemHeight,
                width: MediaQuery.sizeOf(context).width /
                    TimetableResource.presentWidthRate,
                child: ListView.builder(
                  controller: _verItemScroll,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) => Container(
                    decoration: BoxDecoration(
                      color: index.isOdd
                          ? Colors.deepOrange[100]!
                          : Colors.deepOrange[50]!,
                      border:
                          Border(right: BorderSide(color: Colors.grey[400]!)),
                    ),
                    width: MediaQuery.sizeOf(context).width /
                        TimetableResource.presentWidthRate,
                    height: TimetableResource.itemHeight,
                    child: Center(
                      child: Text('Table ${tableMockList[index]}',
                          textAlign: TextAlign.center),
                    ),
                  ),
                  itemCount: tableMockList.length,
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _horTimelineHeaderScroll,
                physics: const NeverScrollableScrollPhysics(),
                child: CustomPaint(
                  painter: TimelineHeaderPaint(
                      screenWidth: MediaQuery.sizeOf(context).width),
                  child: SizedBox(
                    height: TimetableResource.startTimelineDy,
                    width: MediaQuery.sizeOf(context).width *
                        (24 / TimetableResource.presentWidthRate),
                  ),
                ),
              ),
              Expanded(
                child: Scrollbar(
                  controller: _verScroll,
                  thickness: 0,
                  notificationPredicate: (notification) {
                    _verItemScroll.jumpTo(_verScroll.position.pixels);
                    return notification.depth == 1;
                  },
                  child: ScrollConfiguration(
                    behavior:
                        const ScrollBehavior().copyWith(overscroll: false),
                    child: SingleChildScrollView(
                      controller: _verScroll,
                      child: Scrollbar(
                        controller: _horScroll,
                        thickness: 0,
                        notificationPredicate: (notification) {
                          _horTimelineHeaderScroll
                              .jumpTo(_horScroll.position.pixels);
                          return notification.depth == 1;
                        },
                        child: SingleChildScrollView(
                          controller: _horScroll,
                          scrollDirection: Axis.horizontal,
                          child: GestureDetector(
                            onTapUp: (details) {
                              final cubit = context.read<TimeTableCubit>();
                              if (cubit.state is TimeTableOrdered) {
                                cubit.onTableRemoved();
                              } else {
                                cubit.onTableOrdered(details.localPosition);
                              }
                            },
                            child: BlocBuilder<TimeTableCubit, TimeTableState>(
                              builder: (context, state) {
                                Offset? offset;
                                if (state is TimeTableOrdered) {
                                  offset = state.selectedOffset;
                                }
                                return CustomPaint(
                                  painter: TimetableBodyPaint(
                                      selectedOffset: offset,
                                      items: tableMockList,
                                      screenWidth:
                                          MediaQuery.sizeOf(context).width),
                                  child: SizedBox(
                                    height: tableMockList.length *
                                        TimetableResource.itemHeight,
                                    width: MediaQuery.sizeOf(context).width *
                                        (24 /
                                            TimetableResource.presentWidthRate),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
