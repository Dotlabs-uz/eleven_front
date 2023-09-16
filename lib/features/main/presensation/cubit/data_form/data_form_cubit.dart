import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/entities/field_entity.dart';

part 'data_form_state.dart';

class DataFormCubit extends Cubit<DataFormState> {
  DataFormCubit() : super(DataFormNoData());

  editData(Map<String, FieldEntity> fields) {
    debugPrint("edit data ");
    emit(DataFormLoadedData(fields));
  }

  init() {
    emit(DataFormNoData());
  }
}
