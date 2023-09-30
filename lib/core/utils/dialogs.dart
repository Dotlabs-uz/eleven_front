import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/management/domain/entity/employee_entity.dart';
import '../../features/management/domain/entity/employee_schedule_entity.dart';
import '../components/button_widget.dart';
import 'assets.dart';
import 'selections.dart';
import 'string_helper.dart';

class Dialogs {
  static exitDialog({
    required BuildContext context,
    required Function() onExit,
  }) {
    return showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) => AlertDialog(
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Container(
          constraints: BoxConstraints(
            maxWidth: Responsive.isDesktop(context)
                ? 100
                : MediaQuery.of(context).size.width,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 33),
              Container(
                height: 123,
                width: 123,
                decoration: BoxDecoration(
                  color: const Color(0xffFA3E3E).withOpacity(0.75),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    Assets.tWarningIcon,
                    height: 60,
                    width: 60,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'exit'.tr(),
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'DoYouReallyWantToExit'.tr(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    color: const Color(0xff696969),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 66),
              // SizedBox(
              //   height: 34,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Expanded(
              //         child: ButtonWidget(
              //           text: 'back'.tr(),
              //           onPressed: () => Navigator.pop(context),
              //           color: const Color(0xffABACAE),
              //         ),
              //       ),
              //       const SizedBox(width: 15),
              //       Expanded(
              //         child: ButtonWidget(
              //           text: 'exit'.tr(),
              //           color: const Color(0xffFA3E3E).withOpacity(0.75),
              //           onPressed: () {
              //             onExit.call();
              //           },
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  static scheduleField({
    required BuildContext context,
    required Function(int) onConfirm,
    required int day,
    required int month,
    required int year,
  }) {
    return showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) => AlertDialog(
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Container(
          constraints: BoxConstraints(
            maxWidth: Responsive.isDesktop(context)
                ? 100
                : MediaQuery.of(context).size.width,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "pleaseSelectStatus".tr(),
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),

              const SizedBox(height: 5),
              Text(
                "$day ${StringHelper.monthName(month: month)} $year.",
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,),
              ),
              const SizedBox(height: 20),

              ...Selections.listStatus.map((element) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    onConfirm.call(element.status.index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: element.color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              element.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          element.description,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 15),
                      ],
                    ),
                  ),
                );

                return Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: element.color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      element.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 15),
              SizedBox(
                height: 35,
                child: ButtonWidget(
                  text: 'clear'.tr(),
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm.call(EmployeeScheduleStatus.notSelected.index);
                  },
                  color: const Color(0xffABACAE),
                ),
              ),
              // SizedBox(
              //   height: 35,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Expanded(
              //         child: ButtonWidget(
              //           text: 'back'.tr(),
              //           onPressed: () => Navigator.pop(context),
              //           color: const Color(0xffABACAE),
              //         ),
              //       ),
              //       const SizedBox(width: 15),
              //       Expanded(
              //         child: ButtonWidget(
              //           text: 'save'.tr(),
              //           color: const Color(0xff99C499).withOpacity(0.75),
              //           onPressed: () {
              //             onConfirm.call();
              //           },
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // static errorDialog({
  //   required BuildContext context,
  //   String? message,
  //   Function()? onBack,
  // }) {
  //   return showDialog(
  //     context: context,
  //     useSafeArea: true,
  //     builder: (context) => AlertDialog(
  //       alignment: Alignment.center,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       content: Container(
  //         constraints: BoxConstraints(
  //           maxWidth: Responsive.isDesktop(context)
  //               ? 100
  //               : MediaQuery.of(context).size.width,
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const SizedBox(height: 33),
  //             Container(
  //               height: 123,
  //               width: 123,
  //               decoration: const BoxDecoration(
  //                 color: Color(0xffFF6A6A),
  //                 shape: BoxShape.circle,
  //               ),
  //               child: Center(
  //                 child: SvgPicture.asset(
  //                   Assets.tWarningCircle,
  //                   height: 60,
  //                   width: 60,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 15),
  //             Text(
  //               'Error'.tr(),
  //               textAlign: TextAlign.center,
  //               style: GoogleFonts.nunito(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black,
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //             Align(
  //               alignment: Alignment.center,
  //               child: Text(
  //                 message ?? 'SomeThingWentWrong'.tr(),
  //                 textAlign: TextAlign.center,
  //                 style: GoogleFonts.nunito(
  //                   color: const Color(0xff696969),
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 66),
  //             SizedBox(
  //               height: 34,
  //               child: ButtonWidget(
  //                 text: 'back'.tr(),
  //                 color: const Color(0xffFF6A6A),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //
  //                   onBack?.call();
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // static deleteDialog({
  //   required BuildContext context,
  //   Function()? onDelete,
  // }) {
  //   return showDialog(
  //     context: context,
  //     useSafeArea: true,
  //     builder: (context) => AlertDialog(
  //       alignment: Alignment.center,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       content: Container(
  //         constraints: BoxConstraints(
  //           maxWidth: Responsive.isDesktop(context)
  //               ? 100
  //               : MediaQuery.of(context).size.width,
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const SizedBox(height: 33),
  //             Container(
  //               height: 123,
  //               width: 123,
  //               decoration: const BoxDecoration(
  //                 color: Color(0xffFF6A6A),
  //                 shape: BoxShape.circle,
  //               ),
  //               child: Center(
  //                 child: SvgPicture.asset(
  //                   Assets.tWarningCircle,
  //                   height: 60,
  //                   width: 60,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 15),
  //             Text(
  //               'DoYouWantDelete'.tr(),
  //               textAlign: TextAlign.center,
  //               style: GoogleFonts.nunito(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black,
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //             Align(
  //               alignment: Alignment.center,
  //               child: Text(
  //                 'DeleteDialogsText'.tr(),
  //                 textAlign: TextAlign.center,
  //                 style: GoogleFonts.nunito(
  //                   color: const Color(0xff696969),
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 66),
  //             SizedBox(
  //               height: 34,
  //               child: Row(
  //                 children: [
  //                   Expanded(
  //                     child: ButtonWidget(
  //                       text: 'back'.tr(),
  //                       color: Colors.grey,
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                       },
  //                     ),
  //                   ),
  //                   const SizedBox(width: 10),
  //                   Expanded(
  //                     child: ButtonWidget(
  //                       text: 'delete'.tr(),
  //                       color: const Color(0xffFF6A6A),
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //
  //                         onDelete?.call();
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // static successDialog({
  //   required BuildContext context,
  //   Function()? onContinue,
  // }) {
  //   return showDialog(
  //     context: context,
  //     useSafeArea: true,
  //     builder: (context) => AlertDialog(
  //       alignment: Alignment.center,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       content: Container(
  //         constraints: BoxConstraints(
  //           maxWidth: Responsive.isDesktop(context)
  //               ? 100
  //               : MediaQuery.of(context).size.width,
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const SizedBox(height: 33),
  //             Container(
  //               height: 123,
  //               width: 123,
  //               decoration: const BoxDecoration(
  //                 color: Color(0xff86FFA1),
  //                 shape: BoxShape.circle,
  //               ),
  //               child: Center(
  //                 child: SvgPicture.asset(
  //                   Assets.tCheckedIcon,
  //                   height: 60,
  //                   width: 60,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 15),
  //             Text(
  //               'success'.tr(),
  //               textAlign: TextAlign.center,
  //               style: GoogleFonts.nunito(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black,
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //             Align(
  //               alignment: Alignment.center,
  //               child: Text(
  //                 'EverythingWentWell'.tr(),
  //                 textAlign: TextAlign.center,
  //                 style: GoogleFonts.nunito(
  //                   color: const Color(0xff696969),
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 66),
  //             SizedBox(
  //               height: 34,
  //               child: ButtonWidget(
  //                 text: 'Continue'.tr(),
  //                 color: const Color(0xff86FFA1),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   onContinue?.call();
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // static infoDialog({
  //   required BuildContext context,
  //   required String message,
  // }) {
  //   return showDialog(
  //     context: context,
  //     useSafeArea: true,
  //     builder: (context) => AlertDialog(
  //       alignment: Alignment.center,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       content: Container(
  //         constraints: BoxConstraints(
  //           maxWidth: Responsive.isDesktop(context)
  //               ? 100
  //               : MediaQuery.of(context).size.width,
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const SizedBox(height: 33),
  //             Container(
  //               height: 123,
  //               width: 123,
  //               decoration: const BoxDecoration(
  //                 color: Color(0xff416eff),
  //                 shape: BoxShape.circle,
  //               ),
  //               child: const Center(
  //                 child: SizedBox(
  //                   height: 60,
  //                   width: 60,
  //                   child: Icon(
  //                     Icons.info_outline_rounded,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 15),
  //             Text(
  //               'Info'.tr(),
  //               textAlign: TextAlign.center,
  //               style: GoogleFonts.nunito(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black,
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //             Align(
  //               alignment: Alignment.center,
  //               child: Text(
  //                 message,
  //                 textAlign: TextAlign.center,
  //                 style: GoogleFonts.nunito(
  //                   color: const Color(0xff696969),
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 66),
  //             SizedBox(
  //               height: 34,
  //               child: ButtonWidget(
  //                 text: 'OK',
  //                 color: const Color(0xff416eff),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // static filterDialog({
  //   required BuildContext context,
  //   required List<Widget> listWidget,
  // }) {
  //   return showDialog(
  //     context: context,
  //     useSafeArea: true,
  //     builder: (context) => AlertDialog(
  //       alignment: Alignment.center,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       content: Container(
  //         constraints: BoxConstraints(
  //           maxHeight: 400,
  //           maxWidth: Responsive.isDesktop(context)
  //               ? 300
  //               : MediaQuery.of(context).size.width,
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             const SizedBox(height: 10),
  //             Row(
  //               children: [
  //                 Text(
  //                   "filter".tr(),
  //                   style: GoogleFonts.nunito(
  //                     fontWeight: FontWeight.w700,
  //                     fontSize: 24,
  //                   ),
  //                 ),
  //                 const Spacer(),
  //               ],
  //             ),
  //             const SizedBox(height: 20),
  //             Expanded(
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: listWidget,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // static deleteDataDialog({
  //   required BuildContext context,
  //   required List<int> listId,
  //   required Function() onConfirm,
  // }) {
  //   return showDialog(
  //     context: context,
  //     useSafeArea: true,
  //     builder: (context) => AlertDialog(
  //       alignment: Alignment.center,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       content: Container(
  //         constraints: BoxConstraints(
  //           maxHeight: 400,
  //           maxWidth: Responsive.isDesktop(context)
  //               ? 300
  //               : MediaQuery.of(context).size.width,
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             const SizedBox(height: 10),
  //             Row(
  //               children: [
  //                 Text(
  //                   "deleteList".tr(),
  //                   style: GoogleFonts.nunito(
  //                     fontWeight: FontWeight.w700,
  //                     fontSize: 24,
  //                   ),
  //                 ),
  //                 const Spacer(),
  //                 Text("${listId.length}"),
  //               ],
  //             ),
  //             const SizedBox(height: 20),
  //             Expanded(
  //               child: SingleChildScrollView(
  //                 child: Wrap(
  //                   // crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     ...listId.map((e) => Container(
  //                           padding: const EdgeInsets.all(10),
  //                           margin: const EdgeInsets.all(4),
  //                           decoration: const BoxDecoration(
  //                               color: Colors.red,
  //                               borderRadius:
  //                                   BorderRadius.all(Radius.circular(6))),
  //                           child: Center(
  //                             child: Text(
  //                               "#$e",
  //                               style: const TextStyle(
  //                                 fontSize: 16,
  //                                 fontWeight: FontWeight.w500,
  //                                 color: Colors.white,
  //                               ),
  //                             ),
  //                           ),
  //                         )),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             ButtonWidget(
  //               text: 'delete',
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 onConfirm.call();
  //               },
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // static listWidgetDialog({
  //   required BuildContext context,
  //   required List<Widget> listWidget,
  //   String? title,
  //   bool withExit = false,
  // }) {
  //   return showDialog(
  //     context: context,
  //     useSafeArea: true,
  //     builder: (context) => AlertDialog(
  //       alignment: Alignment.center,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       content: Container(
  //         constraints: BoxConstraints(
  //           maxHeight: 400,
  //           maxWidth: Responsive.isDesktop(context)
  //               ? 300
  //               : MediaQuery.of(context).size.width,
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             const SizedBox(height: 10),
  //             if (title != null) const SizedBox(height: 20),
  //             Expanded(
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     ...listWidget,
  //                     if (withExit)
  //                       SizedBox(
  //                         height: 60,
  //                         child: Center(
  //                           child: ButtonWidget(
  //                             text: "back",
  //                             color: Colors.red.shade700,
  //                             onPressed: () => Navigator.pop(context),
  //                           ),
  //                         ),
  //                       ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // static selectDialog({
  //   required BuildContext context,
  //   required List<FilterDialogWidget> listWidget,
  // }) {
  //   return showDialog(
  //     context: context,
  //     useSafeArea: true,
  //     builder: (context) => AlertDialog(
  //       alignment: Alignment.center,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       content: Container(
  //         constraints: BoxConstraints(
  //           maxHeight: 400,
  //           maxWidth: Responsive.isDesktop(context)
  //               ? 100
  //               : MediaQuery.of(context).size.width,
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const SizedBox(height: 20),
  //             Expanded(
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   children: listWidget,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // static balanceDialog({
  //   required BuildContext context,
  //   required List<UserEmployeeEntity> listEntity,
  //   required double balance,
  // }) {
  //   return showDialog(
  //     context: context,
  //     useSafeArea: true,
  //     builder: (context) => AlertDialog(
  //       alignment: Alignment.center,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       content: Container(
  //         constraints: BoxConstraints(
  //           maxHeight: 400,
  //           maxWidth: Responsive.isDesktop(context)
  //               ? 100
  //               : MediaQuery.of(context).size.width,
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             const SizedBox(height: 20),
  //             BalanceDialogItem(
  //               title: 'Balance'.tr(),
  //               balance: balance,
  //             ),
  //             Container(
  //               height: 3,
  //               color: Colors.grey.shade300,
  //             ),
  //             const SizedBox(height: 5),
  //             Expanded(
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   children: [
  //                     ...listEntity.map(
  //                       (data) => BalanceDialogItem(
  //                         title: data.employeeTypeName ?? "",
  //                         balance: data.salary ?? 0,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // static selectTwoDates({
  //   required BuildContext context,
  //   required Function(DateTime, DateTime) onSelect,
  // }) {
  //   DateTime? firstDT;
  //   DateTime? secondDT;
  //
  //   return showDialog(
  //     context: context,
  //     useSafeArea: true,
  //     builder: (context) => StatefulBuilder(
  //       builder: (context, setState) {
  //         return AlertDialog(
  //           alignment: Alignment.center,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(20),
  //           ),
  //           content: Container(
  //             constraints: BoxConstraints(
  //               maxHeight: 400,
  //               maxWidth: Responsive.isDesktop(context)
  //                   ? 100
  //                   : MediaQuery.of(context).size.width,
  //             ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const SizedBox(height: 20),
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 3),
  //                   child: Text(
  //                     "firstDate".tr(),
  //                     style: GoogleFonts.nunito(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                 ),
  //                 Row(
  //                   children: [
  //                     IconButton(
  //                         onPressed: () async {
  //                           firstDT =
  //                               await DateTimeHelper.pickDateTime(context);
  //                           setState(() {});
  //                         },
  //                         icon: const Icon(Icons.calendar_month)),
  //                     Text(
  //                       firstDT != null
  //                           ? "${firstDT?.day}/${firstDT?.month}/${firstDT?.year}"
  //                           : "-----",
  //                       style: GoogleFonts.nunito(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 30),
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 3),
  //                   child: Text(
  //                     "secondDate".tr(),
  //                     style: GoogleFonts.nunito(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                 ),
  //                 Row(
  //                   children: [
  //                     IconButton(
  //                         onPressed: () async {
  //                           secondDT =
  //                               await DateTimeHelper.pickDateTime(context);
  //                           setState(() {});
  //                         },
  //                         icon: const Icon(Icons.calendar_month)),
  //                     Text(
  //                       secondDT != null
  //                           ? "${secondDT?.day}/${secondDT?.month}/${secondDT?.year}"
  //                           : "-----",
  //                       style: GoogleFonts.nunito(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 30),
  //                 Row(
  //                   children: [
  //                     Expanded(
  //                       child: TextButton(
  //                         child: Text(
  //                           "cancel".tr(),
  //                           style: GoogleFonts.nunito(
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.w700,
  //                           ),
  //                         ),
  //                         onPressed: () {
  //                           Navigator.pop(context);
  //                         },
  //                       ),
  //                     ),
  //                     const SizedBox(width: 10),
  //                     Expanded(
  //                       child: TextButton(
  //                         child: Text(
  //                           "select".tr(),
  //                           style: GoogleFonts.nunito(
  //                             fontSize: 16,
  //                             color: firstDT != null && secondDT != null
  //                                 ? Colors.green
  //                                 : Colors.grey,
  //                             fontWeight: FontWeight.w700,
  //                           ),
  //                         ),
  //                         onPressed: () {
  //                           if (firstDT != null && secondDT != null) {
  //                             onSelect.call(firstDT!, secondDT!);
  //                             Navigator.pop(context);
  //                           }
  //                         },
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 20),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}

// class BalanceDialogItem extends StatelessWidget {
//   final String title;
//   final double balance;
//
//   const BalanceDialogItem({
//     Key? key,
//     required this.title,
//     required this.balance,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: GoogleFonts.nunito(
//               color: Colors.black54,
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const Spacer(),
//           Text(
//             NumberHelper.formatNumber(balance),
//             style: GoogleFonts.nunito(
//               color: Colors.black54,
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FilterDialogWidget extends StatelessWidget {
//   final String title;
//   final VoidCallback onTap;
//
//   const FilterDialogWidget({
//     Key? key,
//     required this.title,
//     required this.onTap,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => onTap.call(),
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//         margin: const EdgeInsets.only(bottom: 10),
//         decoration: BoxDecoration(
//           color: Colors.blue,
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Text(
//           title,
//           style: GoogleFonts.nunito(
//             fontWeight: FontWeight.w700,
//             color: Colors.white,
//             fontSize: 16,
//           ),
//         ),
//       ),
//     );
//   }
// }
