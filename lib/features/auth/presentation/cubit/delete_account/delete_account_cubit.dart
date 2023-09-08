import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/delete_user.dart';

part 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  final DeleteUser _deleteUser;
  DeleteAccountCubit(this._deleteUser)
      : super(DeleteAccountInitial());

  deleteAccount({required String smsCode}) async {
    final data = await _deleteUser.call(DeleteUserParams(smsCode));

    data.fold((l) => emit(DeleteAccountError(l.errorMessage)),
        (r) => emit(DeleteAccountSuccess()));
  }


}
