import 'package:bloc/bloc.dart';

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

  remove({required ServiceProductEntity service}) {
    emit(
      SelectServicesHelper(
        data: service,
        action: SelectedServicesAction.remove,
      ),
    );
  }
}
