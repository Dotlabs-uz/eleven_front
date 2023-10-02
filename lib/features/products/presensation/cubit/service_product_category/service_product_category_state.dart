part of 'service_product_category_cubit.dart';

abstract class ServiceProductCategoryState extends Equatable {
  const ServiceProductCategoryState();
}

class ServiceProductCategoryInitial extends ServiceProductCategoryState {
  @override
  List<Object> get props => [];
}
class ServiceProductCategoryLoading extends ServiceProductCategoryState {
  @override
  List<Object> get props => [];
}
class ServiceProductCategoryLoaded extends ServiceProductCategoryState {
  final List<ServiceProductCategoryEntity> data;
  final int pageCount;
  final int dataCount;

  const ServiceProductCategoryLoaded({
    required this.data,
    required this.pageCount,
    required this.dataCount,
  });

  @override
  List<Object> get props => [data];
}
class ServiceProductCategorySaved extends ServiceProductCategoryState {
  final ServiceProductCategoryEntity data;

  const ServiceProductCategorySaved({required this.data});


  @override
  List<Object> get props => [data];
}
class ServiceProductCategoryDeleted extends ServiceProductCategoryState {
  final String id;

  const ServiceProductCategoryDeleted({required this.id});


  @override
  List<Object> get props => [id];
}
class ServiceProductCategoryError extends ServiceProductCategoryState {
  final String message;

  const ServiceProductCategoryError({required this.message});

  @override
  List<Object> get props => [message];
}
