import 'package:bloc/bloc.dart';
import 'package:eleven_crm/core/api/api_constants.dart';
import 'package:eleven_crm/features/main/domain/entity/order_entity.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/services/web_sockets_service.dart';
import '../../../../data/model/order_model.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<Stream<OrderEntity>> {
  final WebSocketsService _webSocketsService;
  OrdersCubit(this._webSocketsService) : super(const Stream.empty());

  load() {

    print("Orders load ");
    final orderWebSocket =
        _webSocketsService.connect(ApiConstants.ordersWebSocket).map(
              (event) => OrderModel.fromJson(event),
            );

    emit(orderWebSocket);
  }
}
