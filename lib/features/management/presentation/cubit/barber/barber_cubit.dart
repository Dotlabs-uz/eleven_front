import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/barber_entity.dart';
import '../../../domain/entity/barber_results_entity.dart';
import '../../../domain/usecases/barber.dart';

part 'barber_state.dart';

class BarberCubit extends Cubit<BarberState> {
  final GetBarber getData;
  final SaveBarber saveData;
  final DeleteBarber deleteData;
  BarberCubit(this.getData, this.saveData, this.deleteData)
      : super(BarberInitial());

  init() => emit(BarberInitial());
  void save({required BarberEntity barber}) async {
    emit(BarberLoading());
    var save = await saveData(barber);
    save.fold((error) => emit(BarberError(message: error.errorMessage)),
        (data) => emit(BarberSaved(data)));
  }

  void delete({required BarberEntity entity}) async {
    emit(BarberLoading());

    final delete = await deleteData(entity);
    delete.fold(
      (error) => emit(BarberError(message: error.errorMessage)),
      (data) => emit(BarberDeleted(entity.id)),
    );
  }

  void load(
    String searchText, {
    String? ordering,
    int page = 1,
    int limit = 20,
  }) async {
    emit(BarberLoading());
    searchText = searchText;
    final data = await getData(GetBarberParams(
      page: page,
      searchText: searchText,
      ordering: ordering,
      limit: limit,
    ));
    data.fold(
      (error) => emit(BarberError(message: error.errorMessage)),
      (data) {
        emit(BarberLoaded(data));
      },
    );
    //loadingCubit.hide();
  }
}
