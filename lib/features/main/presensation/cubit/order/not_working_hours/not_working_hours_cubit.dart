import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/not_working_hours.dart';

part 'not_working_hours_state.dart';

class NotWorkingHoursCubit extends Cubit<NotWorkingHoursState> {
  final SaveNotWorkingHours saveNotWorkingHours;
  NotWorkingHoursCubit(this.saveNotWorkingHours)
      : super(NotWorkingHoursInitial());


  init() => emit(NotWorkingHoursInitial());
  void save({
    required DateTime dateFrom,
    required DateTime dateTo,
    required String employeeId,
  }) async {
    emit(NotWorkingHoursLoading());
    final data = await saveNotWorkingHours.call(
      SaveNotWorkingHoursParams(
        from: dateFrom,
        to: dateTo,
        employeeId: employeeId,
      ),
    );

    data.fold(
      (l) => emit(NotWorkingHoursError(message: l.errorMessage)),
      (r) {
        emit(NotWorkingHoursSaved(dateFrom: dateFrom, dateTo: dateTo, employeeId: employeeId));
      },
    );
  }
}
