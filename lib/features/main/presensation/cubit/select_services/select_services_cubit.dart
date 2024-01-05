import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../products/domain/entity/service_product_entity.dart';

enum SelectedServicesAction {
  add,
  remove,
  undefined,
}

class SelectServicesHelper {
  final ServiceProductEntity? data;
  final SelectedServicesAction action;

  SelectServicesHelper({required this.data, required this.action});
}

class SelectServicesCubit extends Cubit<SelectServicesHelper> {
  SelectServicesCubit()
      : super(
          SelectServicesHelper(
              data: null, action: SelectedServicesAction.undefined),
        );

  init() => emit(
        SelectServicesHelper(
          data: null,
          action: SelectedServicesAction.undefined,
        ),
      );

  save({required ServiceProductEntity service}) {
    emit(
      SelectServicesHelper(data: service, action: SelectedServicesAction.add),
    );
  }

  Future<void> remove({required ServiceProductEntity service}) async {
    emit(
      SelectServicesHelper(
        data: service,
        action: SelectedServicesAction.remove,
      ),
    );
  }
}
