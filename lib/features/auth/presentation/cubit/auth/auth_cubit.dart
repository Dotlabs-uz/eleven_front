// ignore_for_file: unused_import

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/entities/no_params.dart';
import '../../../domain/usecases/auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LogginedUser logginedUser;

  AuthCubit(
    this.logginedUser,
  ) : super(AuthLoadingState()) {
    userIsAuth();
  }

  userIsAuth() async {
    emit(AuthLoadingState());
    final data = await logginedUser(NoParams());

    data.fold((l) {
      emit(UserIsNotLoggedIn());
    }, (isAuth) {
      log("Is auth $isAuth");
      if (isAuth) {
        emit(UserIsLoggedIn());
      } else {
        emit(UserIsNotLoggedIn());
      }
    });
  }
}
