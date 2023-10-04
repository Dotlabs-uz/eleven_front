part of 'current_user_cubit.dart';

abstract class CurrentUserState extends Equatable {
  const CurrentUserState();
}

class CurrentUserInitial extends CurrentUserState {
  @override
  List<Object> get props => [];
}
class CurrentUserError extends CurrentUserState {
  final String message
  ;

  const CurrentUserError({required this.message});
  @override
  List<Object> get props => [];
}
class CurrentUserLoaded extends CurrentUserState {
  final CurrentUserEntity entity;

  const CurrentUserLoaded(this.entity);
  @override
  List<Object> get props => [entity.id];
}
