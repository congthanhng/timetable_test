part of 'time_table_cubit.dart';

@immutable
sealed class TimeTableState {}

final class TimeTableInitial extends TimeTableState {}

final class TimeTableOrdered extends TimeTableState {
  TimeTableOrdered(this.selectedOffset);

  final Offset selectedOffset;
}

final class TimeTableRemoved extends TimeTableState {}