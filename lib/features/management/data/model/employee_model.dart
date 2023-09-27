import '../../../../core/entities/field_entity.dart';
import '../../domain/entity/employee_entity.dart';
import 'employee_schedule_model.dart';

class EmployeeModel extends EmployeeEntity {
  const EmployeeModel({required super.id, required super.fullName, required super.createdAt, required super.phoneNumber, required super.shopName, required super.schedule});


  List<MobileFieldEntity> getFieldsAndValues() {
    return [
      MobileFieldEntity(
        title: "id",
        type: Types.int,
        val: id,
      ),
      MobileFieldEntity(
        title: "fullName",
        type: Types.string,
        val: fullName,
      ),
      MobileFieldEntity(
        title: "phoneNumber",
        type: Types.string,
        val: phoneNumber,
      ),
      MobileFieldEntity(
        title: "shopName",
        type: Types.string,
        val: shopName,
      ),
    ];
  }

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      fullName: json['full_name'],
      createdAt: json['created_at'],
      phoneNumber: json['phone_number'],
      shopName: json['shopName'],
      schedule: List.from(json['work_time'])
          .map((e) => EmployeeScheduleModel.fromJson(e))
          .toList(),
    );
  }

  factory EmployeeModel.fromEntity(EmployeeEntity entity) {
    return EmployeeModel(
      id: entity.id,
      fullName: entity.fullName,
      createdAt: entity.createdAt,
      phoneNumber: entity.phoneNumber,
      shopName: entity.shopName,
      schedule: entity.schedule,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['phone_number'] = phoneNumber;
    data['shopName'] = shopName;
    data['work_time'] = schedule.map((e) =>EmployeeScheduleModel.fromEntity(e).toJson());
    return data;
  }


}
