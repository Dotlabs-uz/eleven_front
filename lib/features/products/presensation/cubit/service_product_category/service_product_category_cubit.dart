import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/service_product_category_entity.dart';
import '../../../domain/usecases/service_product_category.dart';


part 'service_product_category_state.dart';

class ServiceProductCategoryCubit extends Cubit<ServiceProductCategoryState> {
  final GetServiceProductCategory getData;
  final SaveServiceProductCategory saveData;
  final DeleteServiceProductCategory deleteData;
  ServiceProductCategoryCubit(this.getData, this.saveData, this.deleteData,) : super(ServiceProductCategoryInitial());


  void init() => emit(ServiceProductCategoryInitial());

  void save({required ServiceProductCategoryEntity customer}) async {
    emit(ServiceProductCategoryLoading());
    var save = await saveData(customer);
    save.fold((error) => emit(ServiceProductCategoryError(message: error.errorMessage)),
            (data) => emit(ServiceProductCategorySaved(data: data)));
  }

  void delete({required ServiceProductCategoryEntity entity}) async {
    emit(ServiceProductCategoryLoading());

    final delete = await deleteData(entity);
    delete.fold(
          (error) => emit(ServiceProductCategoryError(message: error.errorMessage)),
          (data) => emit(ServiceProductCategoryDeleted(id: entity.id)),
    );
  }

  void load(
      String searchText, {
        String? ordering,
        int page = 1,
      }) async {
    emit(ServiceProductCategoryLoading());
    final data = await getData(GetServiceProductCategoryParams(
      page: page,
      searchText: searchText,
      ordering: ordering,
    ));

    data.fold(
          (error) => emit(ServiceProductCategoryError(message: error.errorMessage)),
          (data) {
        emit(ServiceProductCategoryLoaded(
          data: data.results,
          pageCount: data.pageCount,
          dataCount: data.count,
        ));
      },
    );
  }
}
