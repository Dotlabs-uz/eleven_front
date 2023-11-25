import 'package:eleven_crm/core/entities/no_params.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/current_user_entity.dart';
import '../../../domain/usecases/current_user.dart';

part 'current_user_state.dart';

class CurrentUserCubit extends Cubit<CurrentUserState> {
  final GetCurrentUser getCurrentUser;
  final SaveCurrentUser saveCurrentUser;
  CurrentUserCubit(this.getCurrentUser, this.saveCurrentUser)
      : super(CurrentUserInitial());

  static bool _isReception = false;

  bool get isReception => _isReception;

  load() async {
    final data = await getCurrentUser.call(NoParams());

    data.fold((l) => emit(CurrentUserError(message: l.errorMessage)), (entity) {
      debugPrint("Loaded current user $entity");
      _isReception = entity.role =="reception";

      emit(CurrentUserLoaded(entity));
    });
  }

  save(CurrentUserEntity entity) async {
    final data = await saveCurrentUser.call(entity);


    data.fold((l) => emit(CurrentUserError(message: l.errorMessage)),
        (r) => emit(CurrentUserSaved()));
  }
}
