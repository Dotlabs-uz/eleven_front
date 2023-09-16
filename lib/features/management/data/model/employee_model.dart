
import '../../../../core/entities/field_entity.dart';
import '../../domain/entity/employee_entity.dart';

class EmployeeModel extends EmployeeEntity {
  const EmployeeModel({
    required int id,
    required String fullName,
    required String createdAt,
    required String phoneNumber,
    required String shopName,
  }) : super(
    id: id,
    fullName: fullName,
    createdAt: createdAt,
    phoneNumber: phoneNumber,
    shopName: shopName,
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
    );
  }

  factory EmployeeModel.fromEntity(EmployeeEntity entity) {
    return EmployeeModel(
      id: entity.id,
      fullName: entity.fullName,
      createdAt: entity.createdAt,
      phoneNumber: entity.phoneNumber,
      shopName: entity.shopName,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['phone_number'] = phoneNumber;
    data['shopName'] = shopName;
    return data;
  }
}
