import 'package:bloc/bloc.dart';
import 'package:eleven_crm/features/main/domain/entity/order_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../domain/usecases/order.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final SaveOrder saveOrder;
  OrderCubit(this.saveOrder) : super(OrderInitial());

  void save({
    required OrderEntity order,
  }) async {
    // emit(OrderLoading());
    print("Save order ${order.id}");

    emit(OrderSaved(order));

    // print("Order $order");
    // var save = await saveOrder(order);
    //
    // save.fold(
    //   (error) => emit(OrderError(message: error.errorMessage)),
    //   (data) => emit(OrderSaved(order)),
    // );
  }
}
