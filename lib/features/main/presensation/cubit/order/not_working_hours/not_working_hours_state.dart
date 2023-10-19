part of 'not_working_hours_cubit.dart';

abstract class NotWorkingHoursState extends Equatable {
  const NotWorkingHoursState();
}

class NotWorkingHoursInitial extends NotWorkingHoursState {
  @override
  List<Object> get props => [];
}
class NotWorkingHoursError extends NotWorkingHoursState {
  final String message;

  const NotWorkingHoursError({required this.message});
  @override
  List<Object> get props => [];
}
class NotWorkingHoursSaved extends NotWorkingHoursState {
  @override
  List<Object> get props => [];
}
class NotWorkingHoursLoading extends NotWorkingHoursState {
  @override
  List<Object> get props => [];
}
