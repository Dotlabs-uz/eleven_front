part of 'service_product_cubit.dart';

abstract class ServiceProductState extends Equatable {
  const ServiceProductState();
}

class ServiceProductInitial extends ServiceProductState {
  @override
  List<Object> get props => [];
}



class ServiceProductLoading extends ServiceProductState {
  @override
  List<Object> get props => [];
}

class ServiceProductLoaded extends ServiceProductState {
  final List<ServiceProductEntity> data;
  final int pageCount;
  final int dataCount;

  const ServiceProductLoaded({
    required this.data,
    required this.pageCount,
    required this.dataCount,
  });

  @override
  List<Object> get props => [data];
}

class ServiceProductSaved extends ServiceProductState {
  final ServiceProductEntity data;

  const ServiceProductSaved({required this.data});

  @override
  List<Object> get props => [data];
}


class BarberServiceProductSaved extends ServiceProductState {

  const BarberServiceProductSaved();

  @override
  List<Object> get props => [];
}

class ServiceProductDeleted extends ServiceProductState {
  final String id;

  const ServiceProductDeleted({required this.id});

  @override
  List<Object> get props => [id];
}

class ServiceProductError extends ServiceProductState {
  final String message;

  const ServiceProductError({required this.message});

  @override
  List<Object> get props => [message];
}
