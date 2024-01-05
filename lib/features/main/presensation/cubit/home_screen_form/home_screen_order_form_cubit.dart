import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_screen_order_form_state.dart';


class HomeScreenOrderFormHelper {
  final bool show;

  HomeScreenOrderFormHelper(this.show);
}
class HomeScreenOrderFormCubit extends Cubit<HomeScreenOrderFormHelper> {
  HomeScreenOrderFormCubit() : super(HomeScreenOrderFormHelper(false));

  init() => emit(HomeScreenOrderFormHelper(false));

  enable() => emit(HomeScreenOrderFormHelper(true));

  disable() => emit(HomeScreenOrderFormHelper(false));
}
