import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../products/domain/entity/service_product_entity.dart';

class ShowSelectedServiceHelper extends Equatable {
  final bool show;
  final String barberId;
  final List<ServiceProductEntity> selectedServices;

  const ShowSelectedServiceHelper({
    required this.show,
    required this.barberId,
    required this.selectedServices,
  });

  @override
  List<Object?> get props => [show, selectedServices.length];
}

class ShowSelectServicesCubit extends Cubit<ShowSelectedServiceHelper> {
  ShowSelectServicesCubit()
      : super(
          const ShowSelectedServiceHelper(
            show: false,
            selectedServices: [],
            barberId: '',
          ),
        );

  // init({bool show = false}) =>
  //     emit(ShowSelectedServiceHelper(show: show, selectedServices: const []));

  enable(List<ServiceProductEntity> selectedServices, String barberId) => emit(
        ShowSelectedServiceHelper(
          show: true,
          barberId: barberId,
          selectedServices: selectedServices,
        ),
      );

  disable() => emit(
        const ShowSelectedServiceHelper(
          show: false,
          barberId: "",
          selectedServices: [],
        ),
      );
}
