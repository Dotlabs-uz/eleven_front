import 'package:eleven_crm/features/management/domain/entity/weekly_schedule_results_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/employee_entity.dart';
import '../../../domain/usecases/employee.dart';

part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final GetEmployee getData;
  final GetEmployeeEntity getEmployeeEntity;
  final SaveEmployee saveData;
  final SaveEmployeeWeeklySchedule saveEmployeeWeeklySchedule;
  final DeleteEmployee deleteData;

  EmployeeCubit(
    this.getEmployeeEntity,
    this.getData,
    this.saveData,
    this.deleteData,
    this.saveEmployeeWeeklySchedule,
  ) : super(EmployeeInitial());

  init() => emit(EmployeeInitial());

  void save({required EmployeeEntity employee}) async {
    emit(EmployeeLoading());
    var save = await saveData(employee);
    save.fold(
      (error) => emit(EmployeeError(message: error.errorMessage)),
      (data) => emit(EmployeeSaved(data: employee)),
    );
  }

  void saveWeeklySchedule({
    required String employeeId,
    required WeeklyScheduleResultsEntity weeklySchedule,
  }) async {
    emit(EmployeeLoading());
    var save = await saveEmployeeWeeklySchedule(
        SaveEmployeeWeeklyScheduleParams(
            weeklySchedule: weeklySchedule, employeeId: employeeId));
    save.fold(
      (error) => emit(EmployeeError(message: error.errorMessage)),
      (data) => emit(EmployeeWeeklyScheduleSaved()),
    );
  }

  void deleteEmployeeFromTable({required EmployeeEntity employee}) async {
    emit(EmployeeLoading());
    var save = await saveData(employee);
    save.fold(
      (error) => emit(EmployeeError(message: error.errorMessage)),
      (data) => emit(EmployeeSaved(data: employee)),
    );
  }

  void delete({required EmployeeEntity entity}) async {
    emit(EmployeeLoading());

    final delete = await deleteData(entity);
    delete.fold(
      (error) => emit(EmployeeError(message: error.errorMessage)),
      (data) => emit(EmployeeDeleted(id: entity.id)),
    );
  }

  load(String search, {int page = 0}) async {
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

  loadEmployee(String id) async {
    //loadingCubit.show();
    emit(EmployeeLoading());
    final data = await getEmployeeEntity(
      id,
    );
    data.fold(
      (error) => emit(EmployeeError(message: error.errorMessage)),
      (data) {
        emit(EmployeeEntityLoaded(data: data));
      },
    );
    //loadingCubit.hide();
  }
}
