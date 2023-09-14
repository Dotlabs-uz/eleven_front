import 'customer_entity.dart';

class CustomerResultsEntity {
  final int count;
  final int pageCount;
  final List<CustomerEntity> results;

  CustomerResultsEntity({
    required this.count,
    required this.pageCount,
    required this.results,
  });


}
