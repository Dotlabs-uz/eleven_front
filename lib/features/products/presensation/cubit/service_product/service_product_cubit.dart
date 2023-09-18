import 'package:bloc/bloc.dart';
import 'package:eleven_crm/features/products/domain/usecases/service_product.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entity/service_product_entity.dart';

part 'service_product_state.dart';

class ServiceProductCubit extends Cubit<ServiceProductState> {
  final GetServiceProduct getData;
  final SaveServiceProduct saveData;
  final DeleteServiceProduct deleteData;
  ServiceProductCubit(
    this.getData,
    this.saveData,
    this.deleteData,
  ) : super(ServiceProductInitial());

  void init() => emit(ServiceProductInitial());

  void save({required ServiceProductEntity customer}) async {
    emit(ServiceProductLoading());
    var save = await saveData(customer);
    save.fold((error) => emit(ServiceProductError(message: error.errorMessage)),
        (data) => emit(ServiceProductSaved(data: data)));
  }

  void delete({required ServiceProductEntity entity}) async {
    emit(ServiceProductLoading());

    final delete = await deleteData(entity);
    delete.fold(
      (error) => emit(ServiceProductError(message: error.errorMessage)),
      (data) => emit(ServiceProductDeleted(id: entity.id)),
    );
  }

  void load(
    String searchText, {
    String? ordering,
    int page = 1,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    //loadingCubit.show();
    emit(ServiceProductLoading());
    searchText = searchText;
    final data = await getData(GetServiceProductParams(
      page: page,
      searchText: searchText,
      ordering: ordering,
    ));
    data.fold(
      (error) => emit(ServiceProductError(message: error.errorMessage)),
      (data) {
        emit(ServiceProductLoaded(
          data: data.results,
          pageCount: data.pageCount,
          dataCount: data.count,
        ));
      },
    );
    //loadingCubit.hide();
  }
}
