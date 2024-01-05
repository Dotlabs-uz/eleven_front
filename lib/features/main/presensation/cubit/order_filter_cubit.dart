// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class OrderFilterHelper extends Equatable{
  final String query;

  const OrderFilterHelper({this.query = ""});

  @override
  List<Object?> get props => [query];


}

class OrderFilterCubit extends Cubit<OrderFilterHelper> {
  OrderFilterCubit() : super(const OrderFilterHelper());

  setFilter({required String query})async  {
    document.cookie="date=$query";


    final box = await Hive.openBox("orderFilter");
    box.put("filter", query);

    emit(OrderFilterHelper(query: query));
  }

  clearFilter() => emit(const OrderFilterHelper(query: ""));
}
