part of 'employee_schedule_cubit.dart';

abstract class EmployeeScheduleState extends Equatable {
  const EmployeeScheduleState();
}

class EmployeeScheduleInitial extends EmployeeScheduleState {
  @override
  List<Object> get props => [];
}

class EmployeeScheduleError extends EmployeeScheduleState {
  final String message;

  const EmployeeScheduleError({required this.message});

  @override
  List<Object> get props => [];
}

class EmployeeScheduleLoading extends EmployeeScheduleState {
  @override
  List<Object> get props => [];
}

class EmployeeScheduleLoaded extends EmployeeScheduleState {

  @override
  List<Object> get props => [];
}

class EmployeeScheduleSaved extends EmployeeScheduleState {
  @override
  List<Object> get props => [];
}
