
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowSelectServicesCubit extends Cubit<bool> {
  ShowSelectServicesCubit() : super(false);


  enable()=> emit( true);

  disable()=> emit( false);


}
