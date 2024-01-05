import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('ru', 'RU'));

  change(Locale locale) => emit(locale);
}
