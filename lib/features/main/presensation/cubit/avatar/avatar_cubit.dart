import 'package:bloc/bloc.dart';
import 'package:eleven_crm/features/main/domain/usecases/photo.dart';
import 'package:equatable/equatable.dart';

part 'avatar_state.dart';

class AvatarCubit extends Cubit<AvatarState> {
  final SaveAvatar saveAvatar;
  AvatarCubit(this.saveAvatar) : super(AvatarInitial());

  Future<void> setAvatar({
    required String fileName,
    required String  userId,
  }) async {
    try {
      emit(AvatarLoading());

      final data = await saveAvatar.call(
        SaveAvatarParams(
          fileName,
          userId,
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
