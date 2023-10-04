

import '../../domain/entity/barber_results_entity.dart';
import 'barber_model.dart';

class BarberResultsModel extends BarberResultsEntity {
  const BarberResultsModel({
    required int count,
    required int pageCount,
    required List<BarberModel> results,
  }) : super(count: count, pageCount: pageCount, results: results,);

  factory BarberResultsModel.fromJson(Map<String, dynamic> json) {
    return BarberResultsModel(
      count: json['count'],
      pageCount: json['page_count'],
      results: List.from(json['results'])
          .map((e) => BarberModel.fromJson(e))
          .toList(),
    );
  }

  Map<String,dynamic>toJson() {
    final Map<String,dynamic> data= {};
    data['count'] = count;
    data['page_count'] = pageCount;
    data['results'] = results.map((e) =>BarberModel.fromEntity( e).toJson());
    return data;
  }
}
