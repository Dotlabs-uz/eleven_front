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

class SelectServicesWidget extends StatefulWidget {
  final Function( ) onTap;
  const SelectServicesWidget({
    Key? key, required this.onTap,
  }) : super(key: key);

  @override
  State<SelectServicesWidget> createState() => SelectServicesWidgetState();
}

class SelectServicesWidgetState extends State<SelectServicesWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
            onTap: widget.onTap,
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),

                decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.blueGrey, width: 1),
                ),
                child: Center(
                  child: Text(
                    "select".tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
