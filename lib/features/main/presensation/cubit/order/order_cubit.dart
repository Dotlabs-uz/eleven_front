import 'package:eleven_crm/features/main/domain/entity/order_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/order.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final SaveOrder saveOrder;
  final DeleteOrder deleteOrder;
  OrderCubit(this.saveOrder, this.deleteOrder) : super(OrderInitial());

  init( )=>emit(OrderInitial());

  void save({
    required OrderEntity order,
  }) async {
    emit(OrderLoading());

    debugPrint("Order $order");
    var save = await saveOrder(order);

    save.fold(
      (error) => emit(OrderError(message: error.errorMessage)),
      (data) => emit(OrderSaved(order)),
    );
  }

  void delete({
    required String orderId,
  }) async {
    emit(OrderLoading());

    var save = await deleteOrder(orderId);

    save.fold(
      (error) => emit(OrderError(message: error.errorMessage)),
      (data) => emit(OrderDeleted(orderId)),
    );
  }
}
