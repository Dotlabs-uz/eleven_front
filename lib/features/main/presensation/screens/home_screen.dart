import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/api/api_constants.dart';
import 'package:eleven_crm/core/components/empty_widget.dart';
import 'package:eleven_crm/core/components/success_flash_bar.dart';
import 'package:eleven_crm/core/services/web_sockets_service.dart';
import 'package:eleven_crm/core/utils/string_helper.dart';
import 'package:eleven_crm/features/main/presensation/cubit/home_screen_form/home_screen_order_form_cubit.dart';
import 'package:eleven_crm/features/main/presensation/cubit/order_filter_cubit.dart';
import 'package:eleven_crm/features/main/presensation/widget/select_service_dialog_widget.dart';
import 'package:eleven_crm/features/management/domain/entity/barber_entity.dart';
import 'package:eleven_crm/features/management/domain/entity/not_working_hours_entity.dart';
import 'package:eleven_crm/features/management/presentation/cubit/barber/barber_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../core/components/data_order_form.dart';
import '../../../../core/components/not_selected_employee_list_widget.dart';
import '../../../../core/components/responsive_builder.dart';
import '../../../../get_it/locator.dart';
import '../../../management/presentation/cubit/customer/customer_cubit.dart';
import '../../../products/domain/entity/service_product_entity.dart';
import '../../data/model/order_model.dart';
import '../../domain/entity/order_entity.dart';
import '../../domain/entity/top_menu_entity.dart';
import '../cubit/data_form/data_form_cubit.dart';
import '../cubit/order/not_working_hours/not_working_hours_cubit.dart';
import '../cubit/order/order_cubit.dart';
import '../cubit/select_services/select_services_cubit.dart';
import '../cubit/show_select_services/show_select_services_cubit.dart';
import '../cubit/top_menu_cubit/top_menu_cubit.dart';
import '../widget/my_icon_button.dart';
import '../widget/time_table_widget/time_table_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late NotWorkingHoursCubit notWorkingHoursCubit;
  late BarberCubit barberCubit;
  late SelectServicesCubit selectServicesCubit;

  @override
  void initState() {
    notWorkingHoursCubit = locator();
    selectServicesCubit = locator();
    barberCubit = locator();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => notWorkingHoursCubit),
        BlocProvider(create: (context) => selectServicesCubit),
        BlocProvider(create: (context) => barberCubit..load("")),
      ],
      child: const _ContentWidget(),
    );
  }
}

class _ContentWidget extends StatefulWidget {
  const _ContentWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<_ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<_ContentWidget> {
  late OrderEntity activeData;
  late bool showSelectServices;

  late PlutoRow selectedRow;
  late PlutoGridStateManager stateManager;
  final WebSocketsService webSocketService =
      WebSocketsService(ApiConstants.ordersWebSocket);

  DateTime filteredDate = DateTime.now();

  @override
  void initState() {
    initialize();

    super.initState();
  }

  initialize() async {
    webSocketService.connect();
    print("Saved ");

    activeData = OrderEntity.empty();

    showSelectServices = false;

    listBarbers.clear();

    BlocProvider.of<CustomerCubit>(context).load(""); // Need to save local
    _setWidgetTop();
  }

  _setWidgetTop() {
    BlocProvider.of<TopMenuCubit>(context).setWidgets(
      TopMenuEntity(searchCubit: null, enableSearch: false, iconList: [
        MyIconButton(
          onPressed: () {
            activeData = OrderEntity.empty(
              month: filteredDate.month,
              day: filteredDate.day
            );
            _editOrder(activeData);
          },
          icon: const Icon(Icons.add_box_rounded),
        ),
        MyIconButton(
          onPressed: () {
            webSocketService.addFilter({"orderStart": filteredDate});
          },
          icon: const Icon(Icons.refresh),
        ),
      ]),
    );
  }

  void _saveOrder(List<ServiceProductEntity> selectedServices, String barber,
      String client) {

    final entity = OrderEntity.fromFieldsWithSelectedServices(
      selectedServices: selectedServices,
      barber: barber,
      client: client,
    );

    webSocketService.addDataToSocket(OrderModel.fromEntity(entity).toJson());

    // BlocProvider.of<OrderCubit>(context).save(
    //     order: OrderEntity.fromFields(selectedServices: selectedServices));
  }

  void _orderDelete(String orderId) {
    webSocketService.deleteFromSocket(
      {'_id': orderId},
    );

    // BlocProvider.of<OrderCubit>(context).save(
    //     order: OrderEntity.fromFields(selectedServices: selectedServices));
  }

  void _onDeleteNotWorkingHours(
      NotWorkingHoursEntity entity, BarberEntity barberEntity) async {
    if (await confirm(
      super.context,
      title: const Text('confirming').tr(),
      content: const Text('deleteConfirm').tr(),
      textOK: const Text('yes').tr(),
      textCancel: const Text('cancel').tr(),
    )) {
      debugPrint(
          "Barber not working len before ${barberEntity.notWorkingHours.length}");

      barberEntity.notWorkingHours.remove(entity);
      debugPrint(
          "Barber not working len after ${barberEntity.notWorkingHours.length} ${barberEntity.id}");

      // ignore: use_build_context_synchronously
      BlocProvider.of<BarberCubit>(context).save(barber: barberEntity);
    }
  }

  void _editOrder(OrderEntity data) {
    BlocProvider.of<DataFormCubit>(context).editData(data.getFields());

    if (ResponsiveBuilder.isMobile(context)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            body: DataOrderForm(
              saveData: _saveOrder,
              closeForm: () => Navigator.pop(context),
              fields: data.getFields(),
            ),
          ),
        ),
      );
    } else {
      BlocProvider.of<HomeScreenOrderFormCubit>(context).enable();
    }
  }

  Map<int, Widget> children = <int, Widget>{
    0: Text("Day".tr()),
    1: Text("Week".tr()),
  };

  int selectedValue = 0;

  List<BarberEntity> listBarbers = [];

  _dateTimeWidget() {
    final now = DateTime.now();
    const style = TextStyle();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${now.day} ",
          style: style,
        ),
        Text(
          "${StringHelper.monthName(month: now.month).tr().toLowerCase()} ",
          style: style,
        ),
        Text(
          StringHelper.getDayOfWeekType(now).tr().toLowerCase(),
          style: style,
        ),
      ],
    );
  }

  List<OrderEntity> orders = [];

  @override
  void dispose() {
    orders.clear();
    listBarbers.clear();
    selectedValue = 0;
    activeData = OrderEntity.empty();
    showSelectServices = false;

    webSocketService.dispose();

    super.dispose();
  }

  void _updateOrder(OrderEntity order, {bool withOrderEnd = true}) {
    webSocketService.sendData(
      "update",
      {
        "data": OrderModel.fromEntity(order)
            .toJsonUpdate(withOrderEnd: withOrderEnd),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<dynamic>(
          stream: webSocketService.getOrderResponse,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final listSnapData = List.from(snapshot.data);

              if(listSnapData.isNotEmpty) {
                final data = listSnapData
                    .map((e) => OrderModel.fromJson(e, withSubstract: true))
                    .toList();


                orders = data;
                print("Orders $orders");
              }

            }
            return MultiBlocListener(
              listeners: [
                BlocListener<CustomerCubit, CustomerState>(listener: (context, state) {


                  if(state is CustomerSaved) {
                    SuccessFlushBar("change_success".tr()).show(context);
                  }
                },),
                BlocListener<BarberCubit, BarberState>(
                  listener: (context, state) {
                    if (state is BarberLoaded) {
                      if (mounted) {
                        Future.delayed(
                          Duration.zero,
                          () {
                            setState(() {

                              final data = state.data.results;
                              data.removeWhere((element) => element.isCurrentFilial == false);
                              listBarbers = data;
                            });
                          },
                        );
                      }

                      BlocProvider.of<BarberCubit>(context).init();
                    }
                  },
                ),
                BlocListener<OrderFilterCubit, OrderFilterHelper>(
                  listener: (context, state) {
                    if (state.query.isNotEmpty) {
                      webSocketService.addFilter({"orderStart": state.query});
                      filteredDate= DateTime.parse(state.query);
                      print("Filter date init $filteredDate");

                      orders.clear();
                    } else {
                      webSocketService.addFilter("");
                      orders.clear();
                    }
                  },
                ),
                // BlocListener<OrderCubit, OrderState>(
                //   listener: (context, state) {
                //     print("Orders state $state");
                //     if (state is OrderDeleted) {
                //       final element =
                //           orders.firstWhere((element) => element.id == state.orderId);
                //
                //       orders.remove(element);
                //       BlocProvider.of<OrderCubit>(context).init();
                //     } else if (state is OrderSaved) {
                //       if (orders.contains(state.order) == false) {
                //         orders.add(OrderModel.fromEntity(state.order));
                //       }
                //       BlocProvider.of<OrderCubit>(context).init();
                //     }
                //   },
                // ),
                // BlocListener<ShowSelectServicesCubit, ShowSelectedServiceHelper>(
                //   listener: (context, state) {
                //     if (mounted) {
                //       Future.delayed(
                //         Duration.zero,
                //         () {
                //           setState(() {
                //             showSelectServices = state.show;
                //           });
                //         },
                //       );
                //     }
                //   },
                // ),
              ],
              child: Row(
                children: [
                  if (listBarbers.isEmpty)
                    const Expanded(child: EmptyWidget())
                  else
                    Expanded(
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // const Expanded(
                              //     child: CalendarWidget(
                              //   calendarsCount: 3,
                              // )),

                              Expanded(
                                flex: 2,
                                child: BlocBuilder<OrderCubit, OrderState>(
                                  builder: (context, state) {
                                    if (state is OrderDeleted) {
                                      // final element = orders.firstWhere(
                                      //     (element) =>
                                      //         element.id == state.orderId);
                                      //
                                      // orders.remove(element);
                                      // BlocProvider.of<OrderCubit>(context)
                                      //     .init();
                                    } else if (state is OrderSaved) {
                                      // if (orders.contains(state.order) ==
                                      //     false) {
                                      //   orders.add(OrderModel.fromEntity(
                                      //       state.order));
                                      // }
                                      // BlocProvider.of<OrderCubit>(context)
                                      //     .init();
                                    }
                                    return TimeTableWidget(
                                      listBarbers: listBarbers,
                                      onTapNotWorkingHour:
                                          _onDeleteNotWorkingHours,
                                      onOrderDelete: _orderDelete,
                                      orderFilterQuery:
                                          BlocProvider.of<OrderFilterCubit>(
                                                  context)
                                              .state
                                              .query,
                                      onFieldTap: (hour, minute, barberId) {
                                        print("Filter date $filteredDate");
                                        activeData = OrderEntity.empty(
                                          hour: hour,
                                          minute: minute,
                                          barber: barberId,
                                          month: filteredDate.month,
                                          day: filteredDate.day,
                                        );
                                        _editOrder(activeData);
                                      },
                                      onOrderClick: (entity) {
                                        print("Entity $entity");
                                        activeData = entity;
                                        _editOrder(activeData);
                                      },
                                      onDeleteEmployeeFromTable: (employeeId) {
                                        _barberFromTimeTableCardAction(
                                          employeeId,
                                          false,
                                        );
                                      },
                                      onNotWorkingHoursCreate: (
                                        DateTime from,
                                        DateTime to,
                                        String employeeId,
                                      ) {
                                        BlocProvider.of<NotWorkingHoursCubit>(
                                          context,
                                        ).save(
                                          dateFrom: from,
                                          dateTo: to,
                                          employeeId: employeeId,
                                        );
                                      },
                                      listOrders: orders,
                                      onOrderStartResizeEnd: (order) =>
                                          _updateOrder(order),
                                      onOrderEndResizeEnd: (order) =>
                                          _updateOrder(order),
                                      onOrderDragEnd: (order) {
                                        print("Order drag end");
                                        _updateOrder(order, withOrderEnd: true);
                                      },
                                    );
                                  },
                                ),
                              ),
                              BlocBuilder<HomeScreenOrderFormCubit,
                                  HomeScreenOrderFormHelper>(
                                builder: (context, state) {
                                  return AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: state.show == false
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: NotSelectedBarbersListWidget(
                                              listBarbers: listBarbers,
                                              onTap: (String barberId) {
                                                setState(() {});
                                                _barberFromTimeTableCardAction(
                                                  barberId,
                                                  true,
                                                );
                                              },
                                            ),
                                          )
                                        : const SizedBox(),
                                  );
                                },
                              ),
                            ],
                          ),
                          BlocBuilder<ShowSelectServicesCubit,
                              ShowSelectedServiceHelper>(
                            builder: (context, state) {
                              return state.show
                                  ? const SelectServiceDialogWidget()
                                  : const SizedBox();
                            },
                          ),
                        ],
                      ),
                    ),
                  BlocBuilder<HomeScreenOrderFormCubit,
                      HomeScreenOrderFormHelper>(
                    builder: (context, state) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: state.show
                            ? Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 300,
                                ),
                                color: Colors.white,
                                height: MediaQuery.of(context).size.height,
                                child: DataOrderForm(
                                  fields: activeData.getFields(),
                                  saveData: _saveOrder,
                                  closeForm: () {
                                    BlocProvider.of<HomeScreenOrderFormCubit>(
                                            context)
                                        .disable();

                                  },
                                ),
                              )
                            : const SizedBox(),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }

  _barberFromTimeTableCardAction(String employeeId, bool hasInTimeTable) {
    final barber =
        listBarbers.firstWhere((element) => element.id == employeeId);

    barber.inTimeTable = hasInTimeTable;

    print("in time table $hasInTimeTable");

    BlocProvider.of<BarberCubit>(context).save(barber: barber);
  }
}
