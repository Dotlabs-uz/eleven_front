part of 'avatar_cubit.dart';

abstract class AvatarState extends Equatable {
  const AvatarState();
}

class AvatarInitial extends AvatarState {
  @override
  List<Object> get props => [];
}


class AvatarLoading extends AvatarState {
  @override
  List<Object> get props => [];
}


class AvatarError extends AvatarState {
  final String message;

  const AvatarError({required this.message});
  @override
  List<Object> get props => [message];
}

class AvatarSaved extends AvatarState {
  @override
  List<Object> get props => [];
}

