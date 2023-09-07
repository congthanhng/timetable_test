import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'time_table_state.dart';

final class TimeTableCubit extends Cubit<TimeTableState> {
  TimeTableCubit() : super(TimeTableInitial());

  void onTableOrdered(Offset selectedOffset) {
    emit(TimeTableOrdered(selectedOffset));
  }

  void onTableRemoved() {
    emit(TimeTableRemoved());
  }
}
