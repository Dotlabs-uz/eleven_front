import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/components/empty_widget.dart';
import 'package:eleven_crm/core/utils/string_helper.dart';
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
import '../../../auth/data/datasources/authentication_local_data_source.dart';
import '../../../management/data/model/barber_model.dart';
import '../../../products/domain/entity/filial_entity.dart';
import '../../../products/domain/entity/service_product_category_entity.dart';
import '../../../products/domain/entity/service_product_entity.dart';
import '../../domain/entity/order_entity.dart';
import '../cubit/data_form/data_form_cubit.dart';
import '../cubit/order/not_working_hours/not_working_hours_cubit.dart';
import '../cubit/order/order_cubit.dart';
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

  @override
  void initState() {
    notWorkingHoursCubit = locator();
    barberCubit = locator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => notWorkingHoursCubit),
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
  late AuthenticationLocalDataSource localDataSource;
  late OrderEntity activeData;
  late bool isFormVisible;

  late PlutoRow selectedRow;
  late PlutoGridStateManager stateManager;

  @override
  void initState() {
    localDataSource = locator();

    initialize();

    super.initState();
  }

  initialize() async {
    print("Saved ");

    activeData = OrderEntity.empty();

    isFormVisible = false;

    listBarbers.clear();
    _setWidgetTop();
    // listenSockets();

    await localDataSource.saveSessionId(
      "eyJhbGciOiJIUzI1NiIsInR5cCI6ImFjY2VzcyJ9.eyJ1c2VySWQiOiI2NTMxNDNmNzI2OTUyYjYxOWJlYmZhZjYiLCJwYXRoIjoibWFuYWdlcnMiLCJpYXQiOjE2OTc3OTIwOTUsImV4cCI6MTY5Nzg3ODQ5NSwiYXVkIjoiaHR0cHM6Ly95b3VyZG9tYWluLmNvbSIsImlzcyI6ImZlYXRoZXJzIiwianRpIjoiNWNlYzUwZDMtYWM0OS00ZWI5LWFiMmEtNDAwMDlhMmE4MzNlIn0.glVdrSB3u4vco7t-BdUhkdmCfstsfNHSHmHjS671b_8",
    );
  }

  // listenSockets() {
  //   final webSocketStream = WebSocketsService().getResponse;
  //
  //   webSocketStream.listen((event) {
  //     print("Socket event");
  //   });
  // }

  _setWidgetTop() {
    // final Map<String, dynamic> filtr = {};

    BlocProvider.of<TopMenuCubit>(context).setWidgets(
      [
        MyIconButton(
          onPressed: () {
            activeData = OrderEntity.empty();
            _editOrder(activeData);
          },
          icon: const Icon(Icons.add_box_rounded),
        ),
        MyIconButton(
          onPressed: () {
            listBarbers.clear();
            BlocProvider.of<BarberCubit>(context).load("");
          },
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  void _saveOrder() {
    BlocProvider.of<OrderCubit>(context).save(order: OrderEntity.fromFields());
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
      setState(() => isFormVisible = true);
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

  // List<Order> orders = [
  //   Order(
  //     id: '1',
  //     startTime: DateTime(2023, 10, 7, 9, 0), // Начало заказа
  //     endTime: DateTime(2023, 10, 7, 10, 30), // Конец заказа
  //     title: 'Заказ 1', // Имя клиента или другой заголовок
  //   ),
  // ];

  final List<OrderEntity> orders = [
    // OrderEntity(
    //   orderStart: DateTime(2023, 10, 7, 9, 10),
    //   orderEnd: DateTime(2023, 10, 7, 9, 30),
    //   price: 30,
    //   barberId: "6531612da3b411c75df5e944",
    //   services: [
    //     ServiceProductEntity(
    //       id: "id",
    //       name: "name",
    //       price: 30,
    //       duration: 30,
    //       category: ServiceProductCategoryEntity.empty(),
    //       sex: "man",
    //     ),
    //   ],
    //   discount: 2,
    //   discountPercent: 2,
    //   clientId: "333",
    //   paymentType: OrderPayment.cash,
    //   id: '',
    // ),
    OrderEntity(
      orderStart: DateTime(2023, 10, 7, 9),
      orderEnd: DateTime(2023, 10, 7, 9, 30),
      price: 30,
      barberId: "6531612da3b411c75df5e944",
      services: [
        ServiceProductEntity(
          id: "id",
          name: "name",
          price: 30,
          duration: 30,
          category: ServiceProductCategoryEntity.empty(),
          sex: "man",
        ),
      ],
      discount: 2,
      discountPercent: 2,
      clientId: "333",
      paymentType: OrderPayment.cash,
      id: '',
    ),
    OrderEntity(
      discount: 2,
      discountPercent: 2,
      clientId: "333",
      paymentType: OrderPayment.cash,
      orderStart: DateTime(2023, 10, 7, 12),
      orderEnd: DateTime(2023, 10, 7, 13),
      price: 30,
      barberId: "6531612da3b411c75df5e944",
      services: [],
      id: '',
    ),
    OrderEntity(
      discount: 2,
      discountPercent: 2,
      clientId: "333",
      paymentType: OrderPayment.cash,
      orderStart: DateTime(2023, 10, 7, 20, 30),
      orderEnd: DateTime(2023, 10, 7, 21, 0),
      price: 30,
      barberId: "6531612da3b411c75df5e944",
      services: [],
      id: '',
    ),
    OrderEntity(
      discount: 2,
      discountPercent: 2,
      clientId: "333",
      paymentType: OrderPayment.cash,
      orderStart: DateTime(2023, 10, 7, 16, 0),
      orderEnd: DateTime(2023, 10, 7, 17, 30),
      price: 30,
      barberId: "6531612da3b411c75df5e944",
      services: [],
      id: '',
    ),
    OrderEntity(
      discount: 2,
      discountPercent: 2,
      clientId: "333",
      paymentType: OrderPayment.cash,
      orderStart: DateTime(2023, 10, 7, 10, 0),
      orderEnd: DateTime(2023, 10, 7, 11, 5),
      price: 30,
      barberId: "1",
      services: [],
      id: '',
    ),
  ];

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
                        listBarbers.add(
                          BarberModel(
                              id: "id",
                              firstName: "firstName",
                              lastName: "lastName",
                              password: "password",
                              login: "",
                              phone: 12,
                              notWorkingHours: [
                                NotWorkingHoursEntity(
                                  dateFrom: DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                    16,
                                    15,
                                  ),
                                  dateTo: DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                    17,
                                    45,
                                  ),
                                  barberId: 'id',
                                )
                              ],
                              inTimeTable: true,
                              filial: FilialEntity.empty()),
                        );
                      });
                    },
                  );
                }

                BlocProvider.of<BarberCubit>(context).init();
              }
            },
          ),
        ],
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            listBarbers.isEmpty
                ? const Expanded(child: EmptyWidget())
                : Expanded(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            // CupertinoSlidingSegmentedControl<int>(
                            //   backgroundColor: CupertinoColors.white,
                            //   thumbColor: Colors.grey,
                            //   padding: const EdgeInsets.symmetric(horizontal: 15),
                            //   groupValue: selectedValue,
                            //   children: children,
                            //   onValueChanged: (value) {
                            //     if (value != null) {
                            //       setState(() {
                            //         selectedValue = value;
                            //       });
                            //     }
                            //   },
                            // ),
                            Expanded(child: _dateTimeWidget()),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Row(
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
                                    if (state is OrderSaved) {
                                      print(
                                          "Orders saved state ${state.order.id}");
                                      orders.add(state.order);
                                    }
                                    return TimeTableWidget(
                                      listBarbers: listBarbers,
                                      onOrderClick: (entity) =>
                                          _editOrder(entity),
                                      onDeleteEmployeeFromTable: (employeeId) {
                                        _barberFromTimeTableCardAction(
                                          employeeId,
                                          false,
                                        );
                                      },
                                      onTimeConfirm: (
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
                                    );
                                  },
                                ),
                              ),

                              if (!isFormVisible) const SizedBox(width: 5),
                              if (!isFormVisible)
                                BlocBuilder<BarberCubit, BarberState>(
                                  builder: (context, state) {
                                    return NotSelectedBarbersListWidget(
                                      listBarbers: listBarbers,
                                      onTap: (String barberId) {
                                        print("Select employee $barberId");
                                        setState(() {});
                                        _barberFromTimeTableCardAction(
                                          barberId,
                                          true,
                                        );
                                      },
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
            if (isFormVisible)
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: DataOrderForm(
                    fields: activeData.getFields(),
                    saveData: _saveOrder,
                    closeForm: () => setState(() => isFormVisible = false),
                  ),
                ),
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
