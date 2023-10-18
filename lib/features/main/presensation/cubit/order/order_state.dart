part of 'order_cubit.dart';

abstract class OrderState extends Equatable {
  const OrderState();
}

class OrderInitial extends OrderState {
  @override
  List<Object> get props => [];
}
class OrderError extends OrderState {
  final String message;

  const OrderError({required this.message});
  @override
  List<Object> get props => [];
}
class OrderLoading extends OrderState {
  @override
  List<Object> get props => [];
}
class OrderSaved extends OrderState {
  final OrderEntity order;

  const OrderSaved(this.order);

  @override
  List<Object> get props => [order];
}
class OrderDeleted extends OrderState {
  final String id ;

  const OrderDeleted(this.id);
  @override
  List<Object> get props => [id];
}
