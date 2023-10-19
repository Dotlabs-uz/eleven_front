import '../../../../core/entities/field_entity.dart';
import '../../domain/entity/employee_entity.dart';
import 'employee_schedule_model.dart';

class EmployeeModel extends EmployeeEntity {
  const EmployeeModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.role,
    required super.phoneNumber,
    required super.schedule,
    required super.password,
    required super.login,
    required super.inTimeTable,
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
        title: "phoneNumber",
        type: Types.int,
        val: phoneNumber,
      ),
      MobileFieldEntity(
        title: "role",
        type: Types.string,
        val: role,
      ),
    ];
  }

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phone'],
      role: json['role'],
      login: "",
      password: "",
      schedule: List.from(json['workTime']).isNotEmpty
          ? List.from(json['workTime'])
              .map((e) =>
                  EmployeeScheduleModel.fromJson(e, json['_id'].toString()))
              .toList()
          : [],
      inTimeTable: json['inTimeTable'] ?? false,
    );
  }

  factory EmployeeModel.fromEntity(EmployeeEntity entity) {
    return EmployeeModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      phoneNumber: entity.phoneNumber,
      role: entity.role,
      schedule: entity.schedule,
      login: entity.login,
      password: entity.password,
      inTimeTable: entity.inTimeTable,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['phone'] = phoneNumber;
    data['role'] = role;
    data['login'] = "test";
    data['password'] = "test";
    // data['workTime'] =
    //     schedule.map((e) => EmployeeScheduleModel.fromEntity(e).toJson());
    return data;
  }
}
