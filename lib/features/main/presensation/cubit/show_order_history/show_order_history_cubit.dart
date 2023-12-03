import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../products/domain/entity/service_product_entity.dart';

class ShowOrderHistoryHelper extends Equatable {
  final bool show;
  final String clientName;
  final String clientPhone;
  final DateTime createdAt;
  final bool fromSite;
  final List<ServiceProductEntity> selectedServices;

  const ShowOrderHistoryHelper({
    required this.show,
    required this.clientName,
    required this.createdAt,
    required this.clientPhone,
    required this.fromSite,
    required this.selectedServices,
  });

  @override
  List<Object?> get props => [show, selectedServices.length];
}

class ShowOrderHistoryCubit extends Cubit<ShowOrderHistoryHelper> {
  ShowOrderHistoryCubit()
      : super(
            ShowOrderHistoryHelper(
            show: false,
            selectedServices:const [],
            clientName: '',
            clientPhone: '',
            createdAt: DateTime.now(),
            fromSite: false,
          ),
        );

  // init({bool show = false}) =>
  //     emit(ShowSelectedServiceHelper(show: show, selectedServices: const []));

  enable(List<ServiceProductEntity> selectedServices, String clientPhone, String clientName, bool fromSite, DateTime createdAt) => emit(
        ShowOrderHistoryHelper(
          show: true,
          clientPhone: clientPhone,
          clientName: clientName,
          fromSite: fromSite,
          createdAt: createdAt,
          selectedServices: selectedServices,
        ),
      );

  disable() => emit(
          ShowOrderHistoryHelper(
          show: false,
          clientName: "",
          clientPhone: "",
          fromSite: false,
          createdAt: DateTime.now(),
          selectedServices: const[],
        ),
      );
}
