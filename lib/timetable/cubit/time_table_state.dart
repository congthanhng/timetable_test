part of 'time_table_cubit.dart';

@immutable
abstract class TimeTableState {}

class TimeTableInitial extends TimeTableState {}

class TimeTableOrdered extends TimeTableState {
  TimeTableOrdered(this.selectedOffset);

  final Offset selectedOffset;
}

class TimeTableRemoved extends TimeTableState {}


