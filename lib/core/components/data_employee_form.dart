import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/management/presentation/screens/employee_profile_screen.dart';
import '../entities/field_entity.dart';
import '../utils/animated_navigation.dart';
import 'button_widget.dart';
import 'data_int_field_widget.dart';
import 'data_text_field_widget.dart';
import 'role_field_widget.dart';

class DataEmployeeForm extends StatefulWidget {
  final Map<String, FieldEntity> fields;
  final Function() saveData;
  final Function() closeForm;

  const DataEmployeeForm({
    Key? key,
    required this.saveData,
    required this.closeForm,
    required this.fields,
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
            RoleFieldWidget(fieldEntity: widget.fields['role']!),
            DataIntFieldWidget(fieldEntity: widget.fields['phone']!),
            const SizedBox(height: 10),
            ButtonWidget(text: "save".tr(), onPressed: widget.saveData),
            const SizedBox(height: 10),
            ButtonWidget(
              text: "navigateToEmployeeProfile".tr(),
              onPressed: () {
                AnimatedNavigation.push(
                  context: context,
                  page:   EmployeeProfileScreen(employeeId: widget.fields['id']!.val!,),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
