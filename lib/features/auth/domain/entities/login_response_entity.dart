import 'package:equatable/equatable.dart';

class LoginResponseEntity extends Equatable {
  final bool status;
  final bool isRegistered;

  LoginResponseEntity({
    required this.status,
    required this.isRegistered,
  });

  @override
  List<Object?> get props => [
        status,
        isRegistered,
      ];
}
