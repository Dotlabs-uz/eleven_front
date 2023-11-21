import '../../domain/entity/not_working_hours_entity.dart';
import '../../domain/entity/not_working_hours_for_barber_schedule_entity.dart';

class NotWorkingHoursForBarberScheduleModel extends NotWorkingHoursForBarberScheduleEntity {
  const NotWorkingHoursForBarberScheduleModel({required super.dateFrom, required super.dateTo});

  factory NotWorkingHoursForBarberScheduleModel.fromJson(Map<String, dynamic> json, ) {
    return NotWorkingHoursForBarberScheduleModel(
      dateFrom:DateTime.tryParse( json['from']),
      dateTo:DateTime.tryParse( json['to']),
    );
  }

  factory NotWorkingHoursForBarberScheduleModel.fromEntity(NotWorkingHoursForBarberScheduleEntity entity ) {
    return NotWorkingHoursForBarberScheduleModel(
      dateFrom:entity.dateFrom,
      dateTo:entity.dateTo,
    );
  }




  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if(dateFrom != null) {
    data['from'] = dateFrom!.toIso8601String();

    }
    if(dateTo != null) {
      data['to'] = dateTo!.toIso8601String();

    }
    return data;
  }

}
