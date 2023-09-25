import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'employee_schedule_state.dart';

class EmployeeScheduleCubit extends Cubit<EmployeeScheduleState> {
  EmployeeScheduleCubit() : super(EmployeeScheduleInitial());
  init()=> emit(EmployeeScheduleInitial());
  load(){}
  save(){}
}
