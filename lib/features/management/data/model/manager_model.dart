import '../../../../core/entities/field_entity.dart';
import '../../../products/data/model/filial_model.dart';
import '../../domain/entity/manager_entity.dart';

class ManagerModel extends ManagerEntity {
  const ManagerModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.phone,
    required super.filial,
    required super.password,
    required super.login,
  });

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
        type: Types.int,
        val: phone,
      ),
    ];
  }

  factory ManagerModel.fromJson(Map<String, dynamic> json) {
    return ManagerModel(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      filial: FilialModel.fromJson(json['filial']),
      login: json['login'],
      password: "",
    );
  }

  factory ManagerModel.fromEntity(ManagerEntity entity) {
    return ManagerModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      phone: entity.phone,
      filial: entity.filial,
      password: entity.password,
      login: entity.login,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    // data['_id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['phone'] = phone;
    data['filial'] = filial.id;
    data['login'] = login;
    data['password'] = password;
    return data;
  }
}
