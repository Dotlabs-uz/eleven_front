import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widget/my_icon_button.dart';

part 'top_menu_state.dart';

class TopMenuCubit extends Cubit<List<IconButtonImpl>> {
  TopMenuCubit() : super([]);

  setWidgets(List<IconButtonImpl> widget) {
    emit(widget);
  }

  clear() {
    emit([]);
  }
}
