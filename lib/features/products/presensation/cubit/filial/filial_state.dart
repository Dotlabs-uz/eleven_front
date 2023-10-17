part of 'filial_cubit.dart';

abstract class FilialState extends Equatable {
  const FilialState();
}

class FilialInitial extends FilialState {
  @override
  List<Object> get props => [];
}

class FilialError extends FilialState {
  final String message;

  const FilialError(this.message);
  @override
  List<Object> get props => [
        message,
      ];
}

class FilialLoaded extends FilialState {
  final FilialResultsEntity result;

  const FilialLoaded(this.result);
  @override
  List<Object> get props => [];
}

class FilialLoading extends FilialState {
  @override
  List<Object> get props => [];
}

class FilialSaved extends FilialState {

  final FilialEntity data;

  const FilialSaved(this.data);
  @override
  List<Object> get props => [data];
}
