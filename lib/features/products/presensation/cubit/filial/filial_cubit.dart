import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eleven_crm/features/products/domain/entity/filial_results_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../domain/entity/filial_entity.dart';
import '../../../domain/usecases/filial.dart';

part 'filial_state.dart';

class FilialCubit extends Cubit<FilialState> {
  final GetFilials getFilials;
  FilialCubit(this.getFilials) : super(FilialInitial());

  init() => emit  (FilialInitial());

  load({int page = 1, required String search,   String ordering = ""}) async {
    final data = await getFilials.call(GetFilialParams(
      page: page,
      ordering: ordering,
      searchText: search,
    ));

    data.fold(
      (l) => emit(FilialError(l.errorMessage)),
      (r) {
        debugPrint("Loaded $r");
        emit(FilialLoaded(r));
      },
    );
  }
}
