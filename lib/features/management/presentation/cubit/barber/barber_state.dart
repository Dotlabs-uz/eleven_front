part of 'barber_cubit.dart';

abstract class BarberState extends Equatable {
  const BarberState();
}

class BarberInitial extends BarberState {
  @override
  List<Object> get props => [];
}

class BarberError extends BarberState {
  final String message;

  const BarberError({required this.message});
  @override
  List<Object> get props => [message];
}

class BarberLoading extends BarberState {
  @override
  List<Object> get props => [];
}

class BarberLoaded extends BarberState {
  final BarberResultsEntity data;

  const BarberLoaded(this.data);
  @override
  List<Object> get props => [
        data.results,
      ];
}

class BarberSaved extends BarberState {
  final BarberEntity entity;

  const BarberSaved(this.entity);
  @override
  List<Object> get props => [entity];
}

class BarberDeleted extends BarberState {
  final String id;

  const BarberDeleted(this.id);
  @override
  List<Object> get props => [id];
}
