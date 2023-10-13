import '../../../../core/entities/field_entity.dart';
import '../../domain/entity/barber_entity.dart';
import '../../domain/entity/employee_entity.dart';
import 'employee_schedule_model.dart';

class BarberModel extends BarberEntity {
  const BarberModel(
      {required super.id,
      required super.firstName,
      required super.lastName,
      required super.phoneNumber,
      required super.filialId,
      required super.password,
      required super.login});

  List<MobileFieldEntity> getFieldsAndValues() {
    return [
      MobileFieldEntity(
        title: "id",
        type: Types.int,
        val: id,
      ),
      MobileFieldEntity(
        title: "firstName",
        type: Types.string,
        val: firstName,
      ),
      MobileFieldEntity(
        title: "lastName",
        type: Types.string,
        val: lastName,
      ),
      MobileFieldEntity(
        title: "password",
        type: Types.string,
        val: password,
      ),
      MobileFieldEntity(
        title: "login",
        type: Types.string,
        val: login,
      ),
      MobileFieldEntity(
        title: "phoneNumber",
        type: Types.string,
        val: phoneNumber,
      ),
    ];
  }

  factory BarberModel.fromJson(Map<String, dynamic> json) {
    return BarberModel(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phone_number'],
      filialId: json['filialId'],
      login: json['login'],
      password: json['password'],
    );
  }

  factory BarberModel.fromEntity(BarberEntity entity) {
    return BarberModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      phoneNumber: entity.phoneNumber,
      filialId: entity.filialId,
      password: entity.password,
      login: entity.login,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['phoneNumber'] = phoneNumber;
    data['filialId'] = filialId;
    data['login'] = login;
    data['password'] = password;
    return data;
  }
}
