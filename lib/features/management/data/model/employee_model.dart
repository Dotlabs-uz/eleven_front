
import '../../../../core/entities/field_entity.dart';
import '../../domain/entity/employee_entity.dart';

class EmployeeModel extends EmployeeEntity {
  const EmployeeModel({
    required int id,
    required String fullName,
    required String createdAt,
    required String updatedAt,
    required String phoneNumber,
    required String address,
  }) : super(
    id: id,
    fullName: fullName,
    createdAt: createdAt,
    updatedAt: updatedAt,
    phoneNumber: phoneNumber,
    address: address,
  );


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
        title: "address",
        type: Types.string,
        val: address,
      ),
    ];
  }

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      fullName: json['full_name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      phoneNumber: json['phone_number'],
      address: json['address'],
    );
  }

  factory EmployeeModel.fromEntity(EmployeeEntity entity) {
    return EmployeeModel(
      id: entity.id,
      fullName: entity.fullName,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      phoneNumber: entity.phoneNumber,
      address: entity.address,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['phone_number'] = phoneNumber;
    data['address'] = address;
    return data;
  }
}
