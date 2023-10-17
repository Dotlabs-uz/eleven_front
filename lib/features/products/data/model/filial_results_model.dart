
import '../../domain/entity/filial_results_entity.dart';
import 'filial_model.dart';

class FilialResultsModel extends FilialResultsEntity {
  const FilialResultsModel({
    required super.count,
    required super.pageCount,
    required super.results,
  });

  factory FilialResultsModel.fromJson(Map<String, dynamic> json) {
    return FilialResultsModel(
      count: json['count'],
      pageCount: json['pageCount'],
      results: List.from(json['results'])
          .map((e) => FilialModel.fromJson(e))
          .toList(),
    );
  }
}
