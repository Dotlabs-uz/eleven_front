part of 'customer_cubit.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object> get props => [];
}

class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class CustomerLoaded extends CustomerState {
  final List<CustomerEntity> data;
  final int pageCount;
  final int dataCount;

  const CustomerLoaded({
    required this.data,
    required this.pageCount,
    required this.dataCount,
  });

  @override
  List<Object> get props => [data];
}

class CustomerSaved extends CustomerState {
  final CustomerEntity data;

  const CustomerSaved({required this.data});

  @override
  List<Object> get props => [data];
}

class CustomerDeleted extends CustomerState {
  final int id;

  const CustomerDeleted({required this.id});

  @override
  List<Object> get props => [id];
}

class CustomerError extends CustomerState {
  final String message;

  const CustomerError({required this.message});

  @override
  List<Object> get props => [message];
}
