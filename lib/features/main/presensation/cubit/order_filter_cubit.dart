import 'package:flutter_bloc/flutter_bloc.dart';

class OrderFilterHelper {
  final String query;

  const OrderFilterHelper({this.query = ""});
}

class OrderFilterCubit extends Cubit<OrderFilterHelper> {
  OrderFilterCubit() : super(const OrderFilterHelper());

  setFilter({required String query}) => emit(OrderFilterHelper(query: query));

  clearFilter() => emit(const OrderFilterHelper(query: ""));
}
