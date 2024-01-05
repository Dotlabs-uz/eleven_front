import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eleven_crm/features/management/domain/entity/manager_entity.dart';
import 'package:eleven_crm/features/management/domain/usecases/manager.dart';
import 'package:equatable/equatable.dart';

part 'manager_state.dart';

class ManagerCubit extends Cubit<ManagerState> {
  final GetManager getData;
  final SaveManager saveData;
  final DeleteManager deleteData;
  ManagerCubit(this.getData, this.saveData, this.deleteData)
      : super(ManagerInitial());
  init() => emit(ManagerInitial());

  void save({required ManagerEntity employee}) async {
    emit(EmployeeLoading());
    var save = await saveData(employee);
    save.fold(
      (error) => emit(ManagerError(message: error.errorMessage)),
      (data) => emit(ManagerSaved(employee)),
    );
  }

  void delete({required ManagerEntity entity}) async {
    emit(EmployeeLoading());

    final delete = await deleteData(entity);
    delete.fold(
      (error) => emit(ManagerError(message: error.errorMessage)),
      (data) => emit(ManagerDeleted(id: entity.id)),
    );
  }

  load(String search,{int page = 0}) async {
    //loadingCubit.show();
    emit(EmployeeLoading());
    final data = await getData(GetManagerParams(
      page: page,
      searchText: search,
    ));
    data.fold(
      (error) => emit(ManagerError(message: error.errorMessage)),
      (data) {
        emit(ManagerLoaded(
          data: data.results,
          pageCount: data.pageCount,
          dataCount: data.count,
        ));
      },
    );
    //loadingCubit.hide();
  }
}
