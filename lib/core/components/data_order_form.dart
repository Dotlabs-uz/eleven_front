import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/components/barber_field_widget.dart';
import 'package:eleven_crm/core/components/client_field_widget.dart';
import 'package:eleven_crm/core/components/date_time_field_widget.dart';
import 'package:eleven_crm/core/components/select_services_widget.dart';
import 'package:eleven_crm/features/main/presensation/cubit/select_services/select_services_cubit.dart';
import 'package:eleven_crm/features/main/presensation/cubit/show_select_services/show_select_services_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/products/domain/entity/service_product_entity.dart';
import '../entities/field_entity.dart';
import 'button_widget.dart';
import 'data_int_field_widget.dart';
import 'payment_type_field_widget.dart';

class DataOrderForm extends StatefulWidget {
  final Map<String, FieldEntity> fields;
  final Function(List<ServiceProductEntity> selectedServices, String barber,
      String client) saveData;
  final Function() closeForm;

  const DataOrderForm({
    Key? key,
    required this.saveData,
    required this.closeForm,
    required this.fields,
  }) : super(key: key);

  @override
  State<DataOrderForm> createState() => DataOrderFormState();
}

class DataOrderFormState extends State<DataOrderForm> {
  List<ServiceProductEntity> selectedProducts = [];

  double price = 0;
  double duration = 0;
  // DateTime? orderEnd;
  static String client = "";
  static String barber = "";

  @override
  void initState() {
    price = widget.fields['price']?.val ?? 0;
    duration = widget.fields['duration']?.val ?? 0;
    client = widget.fields['barberId']?.val ?? "";
    barber = widget.fields['clientId']?.val ?? "";

    super.initState();
  }

  getPriceAndDuration(List<ServiceProductEntity> listData) {
    double localPrice = 0;
    double localDuration = 0;

    for (var e in selectedProducts) {
      localPrice += e.price;
      localDuration += e.duration;
      print("Price ${e.price}");
      print("Duration ${e.duration}");
    }

    price = localPrice;
    duration = localDuration;
    setState(() {});
  }

  @override
  void dispose() {
    client = '';
    barber = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  widget.closeForm.call();
                  BlocProvider.of<ShowSelectServicesCubit>(context).disable();
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
          ClientFieldWidget(
            fieldEntity: widget.fields['clientId']!,
            onChange: (value) {
              widget.fields['clientId']!.val = value.id;
              client = value.id;
            },
          ),
          BarberFieldWidget(
            fieldEntity: widget.fields['barberId']!,
            onChange: (value) {
              widget.fields['barberId']!.val = value.id;
              barber = value.id;
            },
          ),
          DateTimeFieldWidget(
            fieldEntity: widget.fields['orderStart']!,
            withTime: true,
          ),
          // const SizedBox(height: 10),
          // DateTimeFieldWidget(
          //   fieldEntity: widget.fields['orderEnd']!,
          //   withTime: true,
          // ),
          PaymentTypeFieldWidget(
            fieldEntity: widget.fields['paymentType']!,
          ),
          SelectServicesWidget(
            fieldEntity: widget.fields["services"]!,
            onChanged: (listData) {
              selectedProducts = listData;
              widget.fields['services']!.val = listData;
              print("Selected services $selectedProducts");
              getPriceAndDuration(selectedProducts);
            },
          ),
          const SizedBox(height: 10),
          ButtonWidget(
            text: "save".tr(),
            onPressed: () async {
              if (client.isEmpty) {
                await confirm(
                  context,
                  title: const Text('client').tr(),
                  content: const Text('pleaseSelectClient').tr(),
                  textOK: const Text('ok').tr(),
                  enableCancel: false,
                );
              } else if (barber.isEmpty) {
                await confirm(
                  context,
                  title: const Text('barber').tr(),
                  content: const Text('pleaseSelectBarber').tr(),
                  textOK: const Text('ok').tr(),
                  enableCancel: false,
                );
              } else if (selectedProducts.isEmpty) {
                await confirm(
                  context,
                  title: const Text('services').tr(),
                  content: const Text('pleaseSelectServices').tr(),
                  textOK: const Text('ok').tr(),
                  enableCancel: false,
                );
              } else {
                widget.saveData.call(selectedProducts, barber, client);
              }
            },
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${'price'.tr()}:",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const TextSpan(text: " "),
                                TextSpan(
                                  text: price.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${'duration'.tr()}:",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const TextSpan(text: " "),
                                TextSpan(
                                  text: duration.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      // RichText(
                      //   text: TextSpan(
                      //     children: [
                      //       orderEnd != null
                      //           ? TextSpan(
                      //               text: 'almostOrderDateEnd'.tr(),
                      //               style: const TextStyle(
                      //                 fontSize: 16,
                      //                 color: Colors.black,
                      //                 fontWeight: FontWeight.w500,
                      //               ),
                      //             )
                      //           : const TextSpan(text: ""),
                      //       orderEnd != null
                      //           ? TextSpan(
                      //               text: DateFormat("hh:mm")
                      //                   .format(orderEnd!),
                      //               style: const TextStyle(
                      //                 fontSize: 16,
                      //                 color: Colors.black,
                      //                 fontWeight: FontWeight.w600,
                      //               ),
                      //             )
                      //           : const TextSpan(text: ""),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
