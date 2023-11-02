import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/api/api_constants.dart';
import 'package:eleven_crm/core/components/empty_widget.dart';
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
  const _ContentWidget({Key? key}) : super(key: key);

  @override
  State<_ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<_ContentWidget> {
  late OrderEntity activeData;
  late bool showSelectServices;

  late PlutoRow selectedRow;
  late PlutoGridStateManager stateManager;

  static final WebSocketsService webSocketService =
      WebSocketsService(ApiConstants.ordersWebSocket);

  @override
  void initState() {
    initialize();

    super.initState();
  }

  initialize() async {
    print("Saved ");

    activeData = OrderEntity.empty();
    webSocketService.connect();

    showSelectServices = false;

    listBarbers.clear();
    _setWidgetTop();
  }

  _setWidgetTop() {
    BlocProvider.of<TopMenuCubit>(context).setWidgets(
      TopMenuEntity(searchCubit: null, enableSearch: false, iconList: [
        MyIconButton(
          onPressed: () {
            // activeData = OrderEntity(
            //   id: "",
            //   discount: 0,
            //   discountPercent: 0,
            //   paymentType: OrderPayment.cash,
            //   orderStart: DateTime.now().copyWith(hour: 18),
            //   orderEnd: DateTime.now().copyWith(hour: 18, minute: 30),
            //   price: 30,
            //   barberId: "6531612da3b411c75df5e944",
            //   clientId: "65316125a3b411c75df5e938",
            //   services: [
            //     ServiceProductEntity(
            //       id: "652a8270523968b4b942b123",
            //       name: "",
            //       price: 30,
            //       duration: 10,
            //       category: ServiceProductCategoryEntity.empty(),
            //       sex: 'women',
            //     )
            //   ],
            // );
            // _saveOrderLocal(activeData);

            activeData = OrderEntity.empty();
            _editOrder(activeData);
          },
          icon: const Icon(Icons.add_box_rounded),
        ),
      ]),
    );
  }

  void _saveOrder(List<ServiceProductEntity> selectedServices) {
    BlocProvider.of<OrderCubit>(context).save(
        order: OrderEntity.fromFields(selectedServices: selectedServices));
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

  List<BarberEntity> listBarbers = [
    // EmployeeEntity(
    //   id: "1",
    //   firstName: "Sam",
    //   lastName: "Satt",
    //   password: "Satt",
    //   login: "Satt",
    //   phoneNumber: 99,
    //   role: "manager",
    //   schedule: [],
    //   inTimeTable: false,
    //   notWorkingHours: [],
    // ),
    // EmployeeEntity(
    //   id: "2",
    //   firstName: "Sam",
    //   lastName: "Satt",
    //   password: "Satt",
    //   login: "Satt",
    //   phoneNumber: 99,
    //   role: "manager",
    //   schedule: [],
    //   inTimeTable: false,
    //   notWorkingHours: [
    //     NotWorkingHoursEntity(
    //       dateFrom: DateTime(2023, 10, 19, 16),
    //       dateTo: DateTime(2023, 10, 19, 17, 30),
    //     ),
    //   ],
    // ),
  ];

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: MultiBlocListener(
        listeners: [
          BlocListener<BarberCubit, BarberState>(
            listener: (context, state) {
              if (state is BarberLoaded) {
                if (mounted) {
                  Future.delayed(
                    Duration.zero,
                    () {
                      setState(() {
                        listBarbers = state.data.results;
                      });
                    },
                  );
                }

                BlocProvider.of<BarberCubit>(context).init();
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
                          child:
                              BlocBuilder<OrderFilterCubit, OrderFilterHelper>(
                            builder: (context, state) {
                              if (state.query.isNotEmpty) {
                                webSocketService.addFilter(state.query);
                              } else {
                                webSocketService.addFilter("");
                              }
                              return StreamBuilder(
                                  stream: webSocketService.getResponse,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final listSnapData =
                                          List.from(snapshot.data);
                                      final data = listSnapData
                                          .map((e) => OrderModel.fromJson(e))
                                          .toList();

                                      print("Shanshot has data ${data.length}");
                                      orders = data;
                                    }

                                    return BlocBuilder<OrderCubit, OrderState>(
                                      builder: (context, state) {
                                        if (state is OrderDeleted) {
                                          final element = orders.firstWhere(
                                              (element) =>
                                                  element.id == state.orderId);

                                          orders.remove(element);
                                          BlocProvider.of<OrderCubit>(context)
                                              .init();
                                        } else if (state is OrderSaved) {
                                          if (orders.contains(state.order) ==
                                              false) {
                                            orders.add(OrderModel.fromEntity(
                                                state.order));
                                          }
                                          BlocProvider.of<OrderCubit>(context)
                                              .init();
                                        }
                                        return TimeTableWidget(
                                          listBarbers: listBarbers,
                                          onTapNotWorkingHour:
                                              _onDeleteNotWorkingHours,
                                          onFieldTap: (hour, minute) {
                                            activeData = OrderEntity.empty(
                                              hour: hour,
                                              minute: minute,
                                            );
                                            _editOrder(activeData);
                                          },
                                          onOrderClick: (entity) {
                                            print("Entity $entity");
                                            activeData = entity;
                                            _editOrder(activeData);
                                          },
                                          onDeleteEmployeeFromTable:
                                              (employeeId) {
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
                                            BlocProvider.of<
                                                NotWorkingHoursCubit>(
                                              context,
                                            ).save(
                                              dateFrom: from,
                                              dateTo: to,
                                              employeeId: employeeId,
                                            );
                                          },
                                          listOrders: orders,
                                          onTopOrderEnd: (order) {
                                            print(
                                                "Order start ${order.orderStart.toString()}");
                                            BlocProvider.of<OrderCubit>(context)
                                                .save(order: order);
                                            // BlocProvider.of<OrderCubit>(context).init();
                                          },
                                          onBottomOrderEnd: (order) {
                                            print(
                                                "Order bottom ${order.orderEnd.toString()}");
                                            BlocProvider.of<OrderCubit>(context)
                                                .save(order: order);
                                          },
                                        );
                                      },
                                    );
                                  });
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
                                      padding: const EdgeInsets.only(left: 5),
                                      child:
                                          BlocBuilder<BarberCubit, BarberState>(
                                        builder: (context, state) {
                                          return NotSelectedBarbersListWidget(
                                            listBarbers: listBarbers,
                                            onTap: (String barberId) {
                                              setState(() {});
                                              _barberFromTimeTableCardAction(
                                                barberId,
                                                true,
                                              );
                                            },
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
            BlocBuilder<HomeScreenOrderFormCubit, HomeScreenOrderFormHelper>(
              builder: (context, state) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: state.show
                      ? Container(
                          constraints: const BoxConstraints(
                            maxWidth: 300,
                          ),
                          height: MediaQuery.of(context).size.height,
                          child: SingleChildScrollView(
                            child: DataOrderForm(
                              fields: activeData.getFields(),
                              saveData: _saveOrder,
                              closeForm: () {
                                BlocProvider.of<HomeScreenOrderFormCubit>(
                                        context)
                                    .disable();
                              },
                            ),
                          ),
                        )
                      : const SizedBox(),
                );
              },
            ),
          ],
        ),
      ),
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
