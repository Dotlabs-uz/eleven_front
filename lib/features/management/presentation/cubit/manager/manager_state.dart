part of 'manager_cubit.dart';

abstract class ManagerState extends Equatable {
  const ManagerState();
}

class ManagerInitial extends ManagerState {
  @override
  List<Object> get props => [];
}

class ManagerError extends ManagerState {
  final String message;

  const ManagerError({required this.message});
  @override
  List<Object> get props => [message];
}

class ManagerLoaded extends ManagerState {
  final List<ManagerEntity> data;
  final int pageCount;
  final int dataCount;

  const ManagerLoaded(
      {required this.data, required this.pageCount, required this.dataCount});
  @override
  List<Object> get props => [data, pageCount];
}

class ManagerSaved extends ManagerState {
  final ManagerEntity data;

  const ManagerSaved(this.data);
  @override
  List<Object> get props => [data];
}

class ManagerDeleted extends ManagerState {
  final String id;

  const ManagerDeleted({required this.id});
  @override
  List<Object> get props => [id];
}

class EmployeeLoading extends ManagerState {
  @override
  List<Object> get props => [];
}
