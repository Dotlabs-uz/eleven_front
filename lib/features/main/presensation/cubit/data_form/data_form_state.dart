part of 'data_form_cubit.dart';

@immutable
abstract class DataFormState {}

class DataFormNoData extends DataFormState {}

class DataFormLoadedData extends DataFormState {
  final Map<String, FieldEntity> fields;

  DataFormLoadedData(this.fields);
}
