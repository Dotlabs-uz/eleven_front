import 'package:eleven_crm/features/products/domain/usecases/service_product.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/service_product_entity.dart';

part 'service_product_state.dart';

class ServiceProductCubit extends Cubit<ServiceProductState> {
  final GetServiceProduct getData;
  final SaveServiceProduct saveData;
  final SaveBarberServiceProducts saveBarberServiceProducts;
  final DeleteServiceProduct deleteData;
  ServiceProductCubit(
    this.getData,
    this.saveData,
    this.saveBarberServiceProducts,
    this.deleteData,
  ) : super(ServiceProductInitial());

  void init() => emit(ServiceProductInitial());

  void save({required ServiceProductEntity customer}) async {
    emit(ServiceProductLoading());
    var save = await saveData(customer);
    save.fold((error) => emit(ServiceProductError(message: error.errorMessage)),
        (data) => emit(ServiceProductSaved(data: data)));
  }

  void saveServicesToBarber({
    required List<ServiceProductEntity> services,
    required String barberId,
  }) async {
    emit(ServiceProductLoading());
    var save = await saveBarberServiceProducts(
      SaveBarberServiceProductsParams(services: services, barberId: barberId),
    );

    save.fold(
      (error) => emit(ServiceProductError(message: error.errorMessage)),
      (data) => emit(const BarberServiceProductSaved()),
    );
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
    String? category,
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
      withCategoryParse: true,
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
