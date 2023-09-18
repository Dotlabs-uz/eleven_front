import 'package:equatable/equatable.dart';

class ServiceProductEntity extends Equatable {
  final int id;
  final String name;
  final double price;
  final int duration;
  final int categoryId;
  final int sex;

  const ServiceProductEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.categoryId,
    required this.sex,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        price,
      ];
}
