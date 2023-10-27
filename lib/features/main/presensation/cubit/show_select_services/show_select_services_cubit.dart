import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../products/domain/entity/service_product_entity.dart';

class ShowSelectedServiceHelper {
  final bool show;
  final List<ServiceProductEntity> selectedServices;

  ShowSelectedServiceHelper({
    required this.show,
    required this.selectedServices,
  });
}

class ShowSelectServicesCubit extends Cubit<ShowSelectedServiceHelper> {
  ShowSelectServicesCubit()
      : super(ShowSelectedServiceHelper(show: false, selectedServices: []));

  enable(List<ServiceProductEntity> selectedServices) => emit(
        ShowSelectedServiceHelper(
          show: true,
          selectedServices: selectedServices,
        ),
      );

  disable() => emit(
        ShowSelectedServiceHelper(
          show: false,
          selectedServices: [],
        ),
      );
}
