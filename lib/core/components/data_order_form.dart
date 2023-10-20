import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/components/barber_field_widget.dart';
import 'package:eleven_crm/core/components/client_field_widget.dart';
import 'package:eleven_crm/core/components/data_double_field_widget.dart';
import 'package:eleven_crm/core/components/date_time_field_widget.dart';
import 'package:eleven_crm/features/main/presensation/widget/services_by_category_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/management/presentation/screens/employee_profile_screen.dart';
import '../../features/products/domain/entity/service_product_entity.dart';
import '../entities/field_entity.dart';
import '../utils/animated_navigation.dart';
import 'button_widget.dart';
import 'data_int_field_widget.dart';
import 'data_text_field_widget.dart';
import 'payment_type_field_widget.dart';
import 'role_field_widget.dart';

class DataOrderForm extends StatefulWidget {
  final Map<String, FieldEntity> fields;
  final Function()  saveData;
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
        maxWidth:600,
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
                    onPressed: widget.closeForm,
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
              DateTimeFieldWidget(
                fieldEntity: widget.fields['orderEnd']!,
                withTime: true,
              ),
              PaymentTypeFieldWidget(
                fieldEntity: widget.fields['paymentType']!,
              ),
              // ServicesWithCategoriesWidget(
              //   onSelect: (entity) {
              //     selectedProducts.add(entity);
              //   },
              //   selectedItems: selectedProducts,
              // ),
              const SizedBox(height: 10),
              ButtonWidget(
                text: "save".tr(),
                onPressed:
                  widget.saveData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
