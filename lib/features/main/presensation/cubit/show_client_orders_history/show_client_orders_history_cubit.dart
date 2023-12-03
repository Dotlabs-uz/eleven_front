import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowClientOrdersHistoryHelper extends Equatable {
  final bool show;
  final String clientId;

  const ShowClientOrdersHistoryHelper({
    required this.show,
    required this.clientId,
  });

  @override
  List<Object?> get props => [show, clientId];
}

class ShowClientOrdersHistoryCubit
    extends Cubit<ShowClientOrdersHistoryHelper> {
  ShowClientOrdersHistoryCubit()
      : super(
          const ShowClientOrdersHistoryHelper(
            show: false,
            clientId: '',
          ),
        );

  // init({bool show = false}) =>
  //     emit(ShowSelectedServiceHelper(show: show, selectedServices: const []));

  enable(String clientId) => emit(
        ShowClientOrdersHistoryHelper(
          show: true,
          clientId: clientId,
        ),
      );

  disable() => emit(
        const ShowClientOrdersHistoryHelper(
          show: false,
          clientId: "",
        ),
      );
}
