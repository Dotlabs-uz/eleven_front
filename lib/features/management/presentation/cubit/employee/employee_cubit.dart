import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/employee_entity.dart';
import '../../../domain/usecases/employee.dart';

part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {

  final GetEmployee getData;
  final SaveEmployee saveData;
  final DeleteEmployee deleteData;

  EmployeeCubit(this.getData, this.saveData, this.deleteData) : super(EmployeeInitial());

  init() => emit(EmployeeInitial());



  void save({required EmployeeEntity customer}) async {
    emit(EmployeeLoading());
    var save = await saveData(customer);
    save.fold(
            (error) => emit(EmployeeError(message: error.errorMessage)),
            (data) => emit(EmployeeSaved(data: data)),);
  }

  void delete({required EmployeeEntity entity}) async {
    emit(EmployeeLoading());

    final delete = await deleteData(entity);
    delete.fold(
          (error) => emit(EmployeeError(message: error.errorMessage)),
          (data) => emit(EmployeeDeleted(id: entity.id)),
    );
  }

  load({String search ="", int page = 0})async {
    //loadingCubit.show();
    emit(EmployeeLoading());
    final data = await getData(GetEmployeeParams(
      page: page,
      searchText: search,
    ));
    data.fold(
          (error) => emit(EmployeeError(message: error.errorMessage)),
          (data) {
        emit(EmployeeLoaded(
          data: data.results,
          pageCount: data.pageCount,
          dataCount: data.count,
        ));
      },
    );
    //loadingCubit.hide();
  }

}
