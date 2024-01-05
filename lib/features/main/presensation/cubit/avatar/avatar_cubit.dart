import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eleven_crm/features/main/domain/usecases/photo.dart';
import 'package:equatable/equatable.dart';

part 'avatar_state.dart';

class AvatarCubit extends Cubit<AvatarState> {
  final SaveAvatar saveAvatar;
  AvatarCubit(this.saveAvatar) : super(AvatarInitial());



  init() => emit(AvatarInitial());
  Future<void> setAvatar({
    required List<int> filePath,
    required String  userId,
    required String  role,
  }) async {
    try {
      emit(AvatarLoading());

      final data = await saveAvatar.call(
        SaveAvatarParams(
          filePath,
          userId,
          role,
        ),
      );

      data.fold((l) {
        emit(AvatarError(message: l.errorMessage));
      }, (r) {
          emit(AvatarSaved());
      });
    } catch (error) {
      emit(AvatarError(message: error.toString()));
    }
  }
}
