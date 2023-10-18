import 'package:bloc/bloc.dart';
import 'package:eleven_crm/features/main/domain/entity/order_entity.dart';
import 'package:equatable/equatable.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());

  void save({
    required OrderEntity order,
  }) async {
    emit(OrderLoading());
    // var save = await saveData(customer);
    //
    // save.fold(
    //   (error) => emit(OrderError(message: error.errorMessage)),
    //   (data) => emit(OrderSaved(order)),
    // );
  }
}
