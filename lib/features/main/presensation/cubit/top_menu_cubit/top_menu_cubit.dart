import 'package:eleven_crm/features/main/domain/entity/top_menu_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'top_menu_state.dart';

class TopMenuCubit extends Cubit<TopMenuEntity> {
  TopMenuCubit() : super(TopMenuEntity.empty());

  setWidgets(TopMenuEntity widget) {
    emit(widget);
  }

  clear() {
    emit(TopMenuEntity.empty());
  }
}
