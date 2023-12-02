import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/employee_schedule_entity.dart';
import '../../../domain/usecases/employee_schedule.dart';
import '../../widgets/employee_schedule_widget.dart';

part 'employee_schedule_state.dart';

class EmployeeScheduleCubit extends Cubit<EmployeeScheduleState> {
  final SaveEmployeeSchedule _saveEmployeeSchedule;
  EmployeeScheduleCubit(this._saveEmployeeSchedule)
      : super(EmployeeScheduleInitial());
  init() => emit(EmployeeScheduleInitial());
  save({required List<FieldSchedule> listData}) async {
    emit(EmployeeScheduleLoading());
    final data = await _saveEmployeeSchedule.call(listData);

    data.fold(
      (l) => emit(EmployeeScheduleError(message: l.errorMessage)),
      (r) => emit(EmployeeScheduleSaved()),
    );
  }
}
