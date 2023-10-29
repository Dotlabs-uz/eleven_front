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
  final Function(List<ServiceProductEntity> selectedServices) saveData;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 600,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      widget.closeForm.call();
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
              ClientFieldWidget(
                fieldEntity: widget.fields['client']!,
              ),
              BarberFieldWidget(
                fieldEntity: widget.fields['barber']!,
              ),
              DataIntFieldWidget(
                fieldEntity: widget.fields['price']!,
              ),
              // DataDoubleFieldWidget(
              //   fieldEntity: widget.fields['discountPercent']!,
              // ),
              // DataDoubleFieldWidget(
              //   fieldEntity: widget.fields['discount']!,
              // ),
              DateTimeFieldWidget(
                fieldEntity: widget.fields['orderStart']!,
                withTime: true,
              ),
              const SizedBox(height: 10),
              DateTimeFieldWidget(
                fieldEntity: widget.fields['orderEnd']!,
                withTime: true,
              ),

              PaymentTypeFieldWidget(
                fieldEntity: widget.fields['paymentType']!,
              ),
              SelectServicesWidget(
                fieldEntity: widget.fields["services"]!,
                onChanged: (listData) {
                  selectedProducts = listData;
                  widget.fields['services']!.val = listData;
                  print("Selected services ${widget.fields['services']!.val}");
                  setState(() {});
                },
              ),
              const SizedBox(height: 10),
              ButtonWidget(
                text: "save".tr(),
                onPressed: () => widget.saveData.call(selectedProducts),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
