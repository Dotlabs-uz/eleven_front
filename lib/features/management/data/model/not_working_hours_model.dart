import '../../domain/entity/not_working_hours_entity.dart';

class NotWorkingHoursModel extends NotWorkingHoursEntity {
  const NotWorkingHoursModel({required super.dateFrom, required super.dateTo});

  factory NotWorkingHoursModel.fromJson(Map<String, dynamic> json, ) {
    return NotWorkingHoursModel(
      dateFrom:DateTime.parse( json['from']),
      dateTo:DateTime.parse( json['to']),
    );
  }

  factory NotWorkingHoursModel.fromEntity(NotWorkingHoursEntity entity ) {
    return NotWorkingHoursModel(
      dateFrom:entity.dateFrom,
      dateTo:entity.dateTo,
    );
  }




  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['from'] = dateFrom.toIso8601String();
    data['to'] = dateTo.toIso8601String();
    return data;
  }

}
