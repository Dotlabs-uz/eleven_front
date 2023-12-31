part of 'employee_cubit.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();
}

class EmployeeInitial extends EmployeeState {
  @override
  List<Object> get props => [];
}

class EmployeeError extends EmployeeState {
  final String message;

  const EmployeeError({required this.message});
  @override
  List<Object> get props => [message];
}

class EmployeeLoaded extends EmployeeState {
  final List<EmployeeEntity> data;
  final int pageCount;
  final int dataCount;

  const EmployeeLoaded(
      {required this.data, required this.pageCount, required this.dataCount});
  @override
  List<Object> get props => [data, pageCount];
}

class EmployeeEntityLoaded extends EmployeeState {
  final EmployeeEntity data;
  const EmployeeEntityLoaded({
    required this.data,
  });
  @override
  List<Object> get props => [data];
}

class EmployeeSaved extends EmployeeState {
  final EmployeeEntity data;

  const EmployeeSaved({required this.data});
  @override
  List<Object> get props => [data];
}

class EmployeeWeeklyScheduleSaved extends EmployeeState {
  @override
  List<Object?> get props => [];
}

class EmployeeDeleted extends EmployeeState {
  final String id;

  const EmployeeDeleted({required this.id});
  @override
  List<Object> get props => [id];
}

class EmployeeDeletedFromTable extends EmployeeState {
  final String id;

  const EmployeeDeletedFromTable({required this.id});
  @override
  List<Object> get props => [id];
}

class EmployeeLoading extends EmployeeState {
  @override
  List<Object> get props => [];
}
