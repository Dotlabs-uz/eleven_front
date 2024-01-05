import '../../domain/entity/manager_results_entity.dart';
import 'manager_model.dart';

class ManagerResultsModel extends ManagerResultsEntity {
  const ManagerResultsModel({
    required int count,
    required int pageCount,
    required List<ManagerModel> results,
  }) : super(
          count: count,
          pageCount: pageCount,
          results: results,
        );

  factory ManagerResultsModel.fromJson(Map<String, dynamic> json) {
    return ManagerResultsModel(
      count: json['count'],
      pageCount: json['pageCount'],
      results: List.from(json['results'])
          .map((e) => ManagerModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['count'] = count;
    data['pageCount'] = pageCount;
    data['results'] = results.map((e) => ManagerModel.fromEntity(e).toJson());
    return data;
  }
}
