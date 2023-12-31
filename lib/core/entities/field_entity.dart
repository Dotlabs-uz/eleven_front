enum Types {
  undefined,
  string,
  phoneNumber,
  int,
  year,
  month,
  double,
  bool,
  date,
  dateTime,
  customers,
  filial,
  employeeRole,
  serviceCategory,
  paymentType,
  barber,
  barberMultiSelectId,
  client,
  sex,
  role,
  roleForManagers,
  choseServices,
  weeklySchedule,
}

class FieldEntity<T> {
  final String label;
  final String hintText;
  final Types type;
  final bool isRequired;
  final bool isForm;
  final bool isDeletable;
  final int? symbolCount;
  final bool isEnable;
  T val;

  FieldEntity({
    required this.label,
    required this.hintText,
    required this.type,
    this.symbolCount,
    this.isRequired = true,
    this.isDeletable = false,
    this.isEnable = true,
    this.isForm = true,
    required this.val,
  });
}

class MobileFieldEntity<T> {
  final String title;
  final bool editable;
  final Types type;
  T val;

  MobileFieldEntity({
    required this.title,
    this.editable = true,
    this.type = Types.string,
    required this.val,
  });
}
