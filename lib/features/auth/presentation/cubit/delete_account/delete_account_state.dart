part of 'delete_account_cubit.dart';

abstract class DeleteAccountState extends Equatable {
  const DeleteAccountState();
}

class DeleteAccountInitial extends DeleteAccountState {
  @override
  List<Object> get props => [];
}

class DeleteAccountError extends DeleteAccountState {
  final String message;

  const DeleteAccountError(this.message);
  @override
  List<Object> get props => [message];
}

class DeleteAccountLoading extends DeleteAccountState {
  @override
  List<Object> get props => [];
}

class DeleteAccountSuccess extends DeleteAccountState {
  @override
  List<Object> get props => [];
}

class DeleteAccountSendCodeSuccess extends DeleteAccountState {
  @override
  List<Object> get props => [];
}
