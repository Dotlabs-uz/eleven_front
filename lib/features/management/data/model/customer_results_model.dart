import '../../domain/entity/customer_entity.dart';
import '../../domain/entity/customer_results_entity.dart';
import 'customer_model.dart';


class CustomerResultsModel extends CustomerResultsEntity {
  CustomerResultsModel({
    required int count,
    required int pageCount,
    required List<CustomerEntity> results,
  }) : super(count: count, pageCount: pageCount, results: results);

  factory CustomerResultsModel.fromJson(Map<String, dynamic> json) {
    return CustomerResultsModel(
      count: json['count'],
      pageCount: json['page_count'],
      results: List.from(json['results'])
          .map((e) => CustomerModel.fromJson(e))
          .toList(),
    );
  }

  Map<String,dynamic>toJson() {
    final Map<String,dynamic> data= {};
    data['count'] = count;
    data['page_count'] = pageCount;
    data['results'] = results.map((e) =>CustomerModel.fromEntity( e).toJson());
    return data;
  }
}

// @HiveType(typeId: 9)
// class CustomerResultsModel extends HiveObject {
//   @HiveField(0)
//   final int count;
//   @HiveField(1)
//   final int pageCount;
//   @HiveField(2)
//   final List<CustomerEntity> results;
//
//   CustomerResultsModel({
//     required this.count,
//     required this.pageCount,
//     required this.results,
//   });
// }
