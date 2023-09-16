// ignore_for_file: unused_import

import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/entities/no_params.dart';
import '../../data/models/request_token_model.dart';
import '../../domain/entities/login_request_params.dart';
import '../../domain/usecases/change_password.dart';
import '../../domain/usecases/delete_user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUser loginUser;
  final ChangePassword passwordChange;
  final LogoutUser logoutUser;
  LoginCubit({
    required this.loginUser,
    required this.logoutUser,
    required this.passwordChange,
  }) : super(LoginInitial());

  void init() {
    emit(LoginInitial());
  }


  void login(
    String phoneNumber,
    String code,
  ) async {
    log("Sign in method");
    final model = RequestTokenModel(phoneNumber: phoneNumber, code: code);
    final eitherResponse = await loginUser(model);

    eitherResponse.fold(
      (l) {
        debugPrint("Error ${l.errorMessage}");
        final message = l.errorMessage;

        if (message.contains("server error")) {
          emit(SMSCodeIsNotCorrect());
        } else {
          emit(LoginError(message));
        }
      },
      (r) async {
        debugPrint("Login Success $r");
        if (r) {

          emit(LoginSuccess());
        }


      },
    );
  }

  void changePassword({required String newPassword}) async {
    log("Sign in method");
    final data = await passwordChange(
      ChangePasswordParams(
        newPassword: newPassword,
      ),
    );

    data.fold(
      (l) {
        debugPrint("change password error ${l.errorMessage}");
        emit(ChangePasswordError(l.errorMessage));
      },
      (r) {
        emit(ChangePasswordSuccess());
      },
    );
  }

  void initiateGuestLogin() async {
    emit(LoginSuccess());
  }

  void logout() async {
    await logoutUser(NoParams());
    emit(LogoutSuccess());
  }
}
