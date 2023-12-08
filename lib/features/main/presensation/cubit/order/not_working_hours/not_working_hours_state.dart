part of 'not_working_hours_cubit.dart';

abstract class NotWorkingHoursState  {
  const NotWorkingHoursState();
}

class NotWorkingHoursInitial extends NotWorkingHoursState {
}
class NotWorkingHoursError extends NotWorkingHoursState {
  final String message;

  const NotWorkingHoursError({required this.message});
}
class NotWorkingHoursSaved extends NotWorkingHoursState {
}
class NotWorkingHoursLoading extends NotWorkingHoursState {
}
