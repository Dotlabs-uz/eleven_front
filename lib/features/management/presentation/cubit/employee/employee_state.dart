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

  const EmployeeLoaded({required this.data, required this.pageCount,required this.dataCount});
  @override
  List<Object> get props => [data, pageCount];
}
class EmployeeSaved extends EmployeeState {
  final EmployeeEntity data;

  const EmployeeSaved({required this.data});
  @override
  List<Object> get props => [data ];
}class EmployeeDeleted extends EmployeeState {
  final int id;

  const EmployeeDeleted({required this.id});
  @override
  List<Object> get props => [id];
}

class EmployeeLoading extends EmployeeState {
  @override
  List<Object> get props => [ ];
}
