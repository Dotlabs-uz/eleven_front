import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/date_time_helper.dart';
import '../../../domain/entity/customer_entity.dart';
import '../../../domain/usecases/customer.dart';

part 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  final GetCustomerById getCustomerById;
  final GetCustomer getData;
  final SaveCustomer saveData;
  final DeleteCustomer deleteData;

  CustomerCubit({
    required this.getCustomerById,
    required this.getData,
    required this.saveData,
    required this.deleteData,
  }) : super(CustomerInitial());

  void init() => emit(CustomerInitial());

  void initSize() => emit(InitialSize());

  void save({required CustomerEntity customer}) async {
    emit(CustomerLoading());
    var save = await saveData(customer);
    save.fold((error) => emit(CustomerError(message: error.errorMessage)),
        (data) => emit(CustomerSaved(data: data)));
  }

  void delete({required CustomerEntity entity}) async {
    emit(CustomerLoading());

    final delete = await deleteData(entity);
    delete.fold(
      (error) => emit(CustomerError(message: error.errorMessage)),
      (data) => emit(CustomerDeleted(id: entity.id)),
    );
  }

  void loadCustomer(String id) async {
    final data = await getCustomerById.call(id);

    data.fold(
      (l) => emit(CustomerError(message: l.errorMessage)),
      (r) => emit(CustomerByIdLoaded(entity: r)),
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
    emit(CustomerLoading());
    searchText = searchText;
    final data = await getData(CustomerParams(
      page: page,
      searchText: searchText,
      ordering: ordering,
      endDate: endDate != null ? DateTimeHelper.formatToFilter(endDate) : null,
      startDate:
          startDate != null ? DateTimeHelper.formatToFilter(startDate) : null,
    ));
    data.fold(
      (error) => emit(CustomerError(message: error.errorMessage)),
      (data) {
        emit(CustomerLoaded(
          data: data.results,
          pageCount: data.pageCount,
          dataCount: data.count,
        ));
      },
    );
    //loadingCubit.hide();
  }
}
