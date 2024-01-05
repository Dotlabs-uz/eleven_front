import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/api/api_constants.dart';
import 'package:eleven_crm/core/components/barber_field_widget.dart';
import 'package:eleven_crm/core/components/date_time_field_widget.dart';
import 'package:eleven_crm/core/components/select_services_widget.dart';
import 'package:eleven_crm/core/components/success_flash_bar.dart';
import 'package:eleven_crm/core/services/web_sockets_service.dart';
import 'package:eleven_crm/core/utils/number_helper.dart';
import 'package:eleven_crm/features/main/presensation/cubit/show_client_orders_history/show_client_orders_history_cubit.dart';
import 'package:eleven_crm/features/main/presensation/cubit/show_order_history/show_order_history_cubit.dart';
import 'package:eleven_crm/features/main/presensation/cubit/show_select_services/show_select_services_cubit.dart';
import 'package:eleven_crm/features/main/presensation/widget/client_orders_history_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/main/data/model/order_model.dart';
import '../../features/main/domain/entity/order_entity.dart';
import '../../features/main/presensation/widget/order_history_menu_widget.dart';
import '../../features/products/domain/entity/service_product_entity.dart';
import '../entities/field_entity.dart';
import 'button_widget.dart';
import 'client_search_widget.dart';
import 'data_text_field_widget.dart';

class DataOrderForm extends StatefulWidget {
  final Map<String, FieldEntity> fields;
  final Function(List<ServiceProductEntity> selectedServices, String barber,
      String client) saveData;
  final Function() closeForm;
  final WebSocketsService webSocketsService;

  const DataOrderForm({
    Key? key,
    required this.saveData,
    required this.closeForm,
    required this.fields,
    required this.webSocketsService,
  }) : super(key: key);

  @override
  State<DataOrderForm> createState() => DataOrderFormState();
}

class DataOrderFormState extends State<DataOrderForm> {
  static List<ServiceProductEntity> selectedProducts = [];

  double price = 0;
  double duration = 0;
  // DateTime? orderEnd;
  static String clientName = "";
  static int clientPhone = 998;
  static String barberId = "";
  static DateTime orderStart = DateTime.now();

  @override
  void initState() {
    selectedProducts.clear();
    price = widget.fields['price']?.val ?? 0;
    duration = widget.fields['duration']?.val ?? 0;
    clientName = widget.fields['clientName']?.val ?? "";
    clientPhone = widget.fields['clientPhone']?.val ?? 998;
    barberId = widget.fields['barberId']?.val ?? "";
    orderStart = widget.fields['orderStart']?.val ?? DateTime.now();
    selectedProducts = List.from(widget.fields['services']?.val ?? []);

    if (mounted) {
      Future.delayed(
        Duration.zero,
        () {
          setState(() {});
        },
      );
    }

    super.initState();
  }

  clearData() {
    clientName = "";
    clientPhone = 998;
    barberId = "";
    orderStart = DateTime.now();
    selectedProducts.clear();
  }

  getPriceAndDuration(List<ServiceProductEntity> listData) {
    double localPrice = 0;
    double localDuration = 0;

    for (var e in selectedProducts) {
      localPrice += e.price;
      localDuration += e.duration;
      debugPrint("Price ${e.price}");
      debugPrint("Duration ${e.duration}");
    }

    price = localPrice;
    duration = localDuration;

    setState(() {});
  }

  @override
  void dispose() {
    clearData();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocBuilder<ShowClientOrdersHistoryCubit,
            ShowClientOrdersHistoryHelper>(
          builder: (context, state) {
            return state.show
                ? const ClientOrdersHistoryMenuWidget()
                : const SizedBox();
          },
        ),
        BlocBuilder<ShowOrderHistoryCubit, ShowOrderHistoryHelper>(
          builder: (context, state) {
            return state.show
                ? const OrderHistoryMenuWidget()
                : const SizedBox();
          },
        ),
        Container(
          constraints: const BoxConstraints(
            maxWidth: 300,
          ),
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: const Offset(-10, 10),
                blurRadius: 16,
                color: Colors.black.withOpacity(0.1),
              )
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (widget.fields['id']?.val != null &&
                              widget.fields['id']!.val.toString().isNotEmpty)
                            IconButton(
                              onPressed: () {
                                final DateTime createdAt =
                                    widget.fields['createdAt']!.val;
                                final bool fromSite =
                                    widget.fields['fromSite']!.val;
                                BlocProvider.of<ShowClientOrdersHistoryCubit>(
                                        context)
                                    .disable();
                                BlocProvider.of<ShowOrderHistoryCubit>(context)
                                    .enable(
                                        selectedProducts,
                                        clientPhone
                                            .toString(), // TODO CLIENT !!!!!
                                        clientName,
                                        fromSite,
                                        createdAt);
                              },
                              icon: const Icon(Icons.history),
                            ),
                          TextButton(
                            onPressed: () {
                              widget.closeForm.call();
                              BlocProvider.of<ShowClientOrdersHistoryCubit>(
                                      context)
                                  .disable();
                              BlocProvider.of<ShowOrderHistoryCubit>(context)
                                  .disable();

                              BlocProvider.of<ShowSelectServicesCubit>(context)
                                  .disable();
                            },
                            child: Text(
                              'close'.tr(),
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                      DataTextFieldWidget(
                        fieldEntity: widget.fields['description']!,
                      ),
                      ClientSearchWidget(
                        label: 'client'.tr(),
                        onNameChanged: (value) {
                          widget.fields['clientName']!.val = value;
                          clientName = value;
                          if(mounted) {
                            Future.delayed(Duration.zero,() {
                              setState(() {});

                            },);
                          }
                        },
                        onPhoneChanged: (value) {
                          widget.fields['clientPhone']!.val = value;
                          clientPhone = value;

                          if(mounted) {
                            Future.delayed(Duration.zero,() {
                              setState(() {});

                            },);
                          }
                        },
                        clientPhone: clientPhone,
                        clientName: clientName,
                        enableHistoryButton: widget.fields['id']?.val != null &&
                            widget.fields['id']!.val.toString().isNotEmpty,
                        onHistoryTap: () {
                          BlocProvider.of<ShowOrderHistoryCubit>(context)
                              .disable();
                          BlocProvider.of<ShowClientOrdersHistoryCubit>(context)
                              .enable(widget.fields['clientId']?.val);
                        },
                      ),
                      // ClientFieldWidget(
                      //   fieldEntity: widget.fields['clientId']!,
                      //   onCreate: () {
                      //     widget.closeForm.call();
                      //   },
                      //   onChange: (value) {
                      //     widget.fields['clientId']!.val = value.id;
                      //     clientId = value.id;
                      //   },
                      // ),
                      BarberFieldWidget(
                        fieldEntity: widget.fields['barberId']!,
                        onChange: (value) {
                          widget.fields['barberId']!.val = value.id;
                          barberId = value.id;
                          setState(() {});
                        },
                      ),
                      // PaymentTypeFieldWidget(
                      //   fieldEntity: widget.fields['paymentType']!,
                      // ),
                      DateTimeFieldWidget(
                        fieldEntity: widget.fields['orderStart']!,
                        withTime: true,
                        onChanged: (value) {
                          if (mounted) {
                            Future.delayed(
                              Duration.zero,
                              () {
                                setState(() {
                                  orderStart = value;
                                });
                              },
                            );
                          }
                        },
                      ),
                      // const SizedBox(height: 10),`
                      // DateTimeFieldWidget(
                      //   fieldEntity: widget.fields['orderEnd']!,
                      //   withTime: true,
                      // ),

                      const SizedBox(height: 10),

                      if (barberId.isNotEmpty)
                        SelectServicesWidget(
                          fieldEntity: widget.fields["services"]!,
                          onChanged: (listData) {
                            selectedProducts = listData;
                            debugPrint("Selected services $selectedProducts");
                            widget.fields['services']!.val = selectedProducts;
                            getPriceAndDuration(selectedProducts);
                          },
                          barberId: barberId,
                        ),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              Container(
                width: 300,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 14,
                    )
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    _infoWidget("${'price'.tr()}:",
                        NumberHelper.formatNumber(price.toInt()), "сум"),
                    const SizedBox(height: 15),
                    _infoWidget("${'duration'.tr()}:", duration, "мин"),
                    const SizedBox(height: 30),
                    ButtonWidget(
                      text: "save".tr(),
                      onPressed: () async {
                        debugPrint(
                            "Client name $clientName client phone $clientPhone");
                        if (clientName.isEmpty &&
                            clientPhone.toString() == "998") {
                          await confirm(
                            context,
                            title: const Text('client').tr(),
                            content: const Text('pleaseEnterClientNameAndPhone')
                                .tr(),
                            textOK: const Text('ok').tr(),
                            enableCancel: false,
                          );
                          return;
                        } else if (barberId.isEmpty) {
                          await confirm(
                            context,
                            title: const Text('barber').tr(),
                            content: const Text('pleaseSelectBarber').tr(),
                            textOK: const Text('ok').tr(),
                            enableCancel: false,
                          );
                          return;
                        } else if (selectedProducts.isEmpty) {
                          await confirm(
                            context,
                            title: const Text('services').tr(),
                            content: const Text('pleaseSelectServices').tr(),
                            textOK: const Text('ok').tr(),
                            enableCancel: false,
                          );
                          return;
                        } else if (orderStart.isBefore(DateTime.now().copyWith(second: 0,microsecond: 0,millisecond: 0))) {
                          await confirm(
                            context,
                            title: const Text('orderStart').tr(),
                            content: const Text(
                                    'youCantChooseThisOrderStartInThisTime')
                                .tr(),
                            textOK: const Text('ok').tr(),
                            enableCancel: false,
                          );
                          return;
                        }

                        widget.saveData
                            .call(selectedProducts, barberId, clientName);
                        clearData();
                        BlocProvider.of<ShowSelectServicesCubit>(context)
                            .disable();
                        widget.closeForm.call();
                        SuccessFlushBar("change_success".tr()).show(context);
                      },
                    ),
                    if (widget.fields['id']?.val != null &&
                        widget.fields['id']!.val.toString().isNotEmpty)
                      const SizedBox(height: 10),
                    if (widget.fields['id']?.val != null &&
                        widget.fields['id']!.val.toString().isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: ButtonWidget(
                                text: "delete".tr(),
                                color: Colors.red,
                                onPressed: () async {
                                  if (await confirm(
                                    super.context,
                                    title: const Text('confirming').tr(),
                                    content: const Text('deleteConfirm').tr(),
                                    textOK: const Text('yes').tr(),
                                    textCancel: const Text('cancel').tr(),
                                  )) {
                                    widget.webSocketsService.deleteFromSocket(
                                      {'_id': widget.fields['id']?.val},
                                    );
                                  }
                                }),
                          ),
                          if (widget.fields['status']?.val != null &&
                              widget.fields['status']!.val ==
                                  OrderStatus.waitingToView)
                            const SizedBox(width: 10),
                          if (widget.fields['status']?.val != null &&
                              widget.fields['status']!.val ==
                                  OrderStatus.waitingToView)
                            Expanded(
                              child: ButtonWidget(
                                text: "checked".tr(),
                                color: Colors.blue,
                                onPressed: () async {
                                  _updateOrder(OrderEntity.fromFields());
                                },
                              ),
                            ),
                        ],
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _updateOrder(OrderEntity order, {bool withOrderEnd = true}) {
    order.status = OrderStatus.viewed;
    WebSocketsService(ApiConstants.baseApiUrl).sendData(
      "update",
      {
        "data": OrderModel.fromEntity(order)
            .toJsonUpdate(withOrderEnd: withOrderEnd),
      },
    );
  }

  _infoWidget(String title, dynamic value, String valueText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "$value $valueText",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
