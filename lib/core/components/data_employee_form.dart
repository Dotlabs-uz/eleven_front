import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/components/data_phone_number_field_widget.dart';
import 'package:eleven_crm/features/management/domain/entity/employee_entity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/management/presentation/screens/employee_profile_screen.dart';
import '../entities/field_entity.dart';
import '../utils/animated_navigation.dart';
import 'button_widget.dart';
import 'data_text_field_widget.dart';
import 'role_field_widget.dart';

class DataEmployeeForm extends StatefulWidget {
  final Map<String, FieldEntity> fields;
  final Function() saveData;
  final Function() closeForm;
  final Function() onBackFromProfile;

  const DataEmployeeForm({
    Key? key,
    required this.saveData,
    required this.closeForm,
    required this.fields,
    required this.onBackFromProfile,
  }) : super(key: key);

  @override
  State<DataEmployeeForm> createState() => DataEmployeeFormState();
}

class DataEmployeeFormState extends State<DataEmployeeForm> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Container(
                //   height: 30,
                //   // width: 35,
                //   decoration: BoxDecoration(
                //     color: Colors.red.shade300,
                //     borderRadius: BorderRadius.circular(50),
                //     // border: Border.all(color: Colors.white, width: 3),
                //   ),
                //   child: Center(
                //     child: Padding(
                //       padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                //       child: Text(
                //         "${"element".tr()} № ${widget.fields['id']?.val.toString()}",
                //         style: GoogleFonts.nunito(
                //           color: Colors.white,
                //           fontWeight: FontWeight.bold,
                //           fontSize: 14,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
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
            DataTextFieldWidget(fieldEntity: widget.fields['firstName']!),
            DataTextFieldWidget(fieldEntity: widget.fields['lastName']!),
            // DataTextFieldWidget(fieldEntity: widget.fields['login']!),
            // DataTextFieldWidget(fieldEntity: widget.fields['password']!),
            RoleFieldWidget(fieldEntity: widget.fields['role']!),
            DataPhoneNumberFieldWidget(
                fieldEntity: widget.fields['phone']!,
                id: widget.fields['id']?.val),
            const SizedBox(height: 10),
            ButtonWidget(text: "save".tr(), onPressed: widget.saveData),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            ButtonWidget(
              text: "navigateToEmployeeProfile".tr(),
              onPressed: () {
                AnimatedNavigation.push(
                  context: context,
                  page: EmployeeProfileScreen(
                    employeeEntity: EmployeeEntity.fromFields(),
                    onBack: widget.onBackFromProfile,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
