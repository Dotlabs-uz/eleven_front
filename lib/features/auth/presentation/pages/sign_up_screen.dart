// // ignore_for_file: unused_import
//
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:taksist/core/components/back_widget.dart';
// import 'package:taksist/core/components/error_flash_bar.dart';
// import 'package:taksist/core/utils/animated_navigation.dart';
// import 'package:taksist/core/utils/field_formatters.dart';
// import 'package:taksist/features/auth/presentation/pages/continue_registration_id_card_screen.dart';
// import 'package:taksist/features/main/domain/entity/driver_entity.dart';
// import 'package:taksist/features/main/presensation/screens/privacy_policy_screen.dart';
//
// import '../../../../core/components/button_widget.dart';
// import '../../../../core/components/custom_check_box.dart';
// import '../../../../core/components/text_form_field_widget.dart';
// import '../../../../core/utils/app_colors.dart';
// import '../../../../core/utils/form_validator.dart';
//
// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends State<SignUpScreen> {
//   final TextEditingController controllerName = TextEditingController();
//   final TextEditingController controllerSurname = TextEditingController();
//   final TextEditingController controllerPhone = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   final entity = DriverEntity.empty();
//   late bool _checkbox;
//
//   @override
//   void initState() {
//     _checkbox = false;
//     controllerPhone.text = "+994";
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return KeyboardDismissOnTap(
//       child: Scaffold(
//         body: Form(
//           key: _formKey,
//           autovalidateMode: AutovalidateMode.disabled,
//           child: SizedBox(
//             height: MediaQuery.of(context).size.height,
//             child: SafeArea(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 35.w),
//                 child: SingleChildScrollView(
//                   physics: const ClampingScrollPhysics(),
//                   child: Center(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         const BackWidget(),
//                         SizedBox(height: 18.h),
//                         Text(
//                           "forContinueRegistration".tr(),
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontStyle: FontStyle.normal,
//                             fontFamily: "SFProDisplay",
//                             fontWeight: FontWeight.w500,
//                             fontSize: 28.sp,
//                           ),
//                         ),
//                         SizedBox(height: 30.h),
//                         TextFormFieldWidget(
//                           controller: controllerName,
//                           hintText: "",
//                           validator: FormValidator.empty,
//                           title: 'name',
//                         ),
//                         SizedBox(height: 10.h),
//                         TextFormFieldWidget(
//                           controller: controllerSurname,
//                           hintText: "",
//                           validator: FormValidator.empty,
//                           title: 'surname',
//                         ),
//                         SizedBox(height: 10.h),
//                         TextFormFieldWidget(
//                           controller: controllerPhone,
//                           validator: FormValidator.empty,
//                           keyboardType: const TextInputType.numberWithOptions(),
//                           textInputFormatter:
//                               FieldFormatters.phoneMaskFormatter,
//                           hintText: "+994",
//                           title: 'phoneNumber',
//                         ),
//                         // SizedBox(height: 10.h),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             CustomCheckBox(
//                               value: _checkbox,
//                               onChanged: (value) {
//                                 HapticFeedback.lightImpact();
//                                 setState(() => _checkbox = !_checkbox);
//                               },
//                               activeColor: const Color(0xff545C9B),
//                               inactiveColor: const Color(0xff283062),
//                             ),
//                             SizedBox(width: 10.w),
//                             TextButton(
//                               style: TextButton.styleFrom(
//                                 padding: EdgeInsets.zero,
//                                 minimumSize: Size(50, 30),
//                                 tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                               ),
//                               child: Text(
//                                 "privacyPolicy".tr(),
//                                 style: TextStyle(
//                                   fontFamily: "SFProDisplay",
//                                   fontStyle: FontStyle.normal,
//                                   decoration: TextDecoration.underline,
//                                   fontWeight: FontWeight.w500,
//                                   color: AppColors.lightTextSecond,
//                                   fontSize: 15.sp,
//                                 ),
//                               ),
//                               onPressed: () {
//                                 AnimatedNavigation.push(
//                                   context: context,
//                                   page: PrivacyPolicyPage(
//                                     onAccept: () => setState(() {
//                                       _checkbox = true;
//                                     }),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 30.h),
//                         ButtonWidget(
//                           enabled: true,
//                           title: 'next'.tr(),
//                           onTap: () {
//                             if (_checkbox == false) {
//                               ErrorFlushBar("acceptPolicy".tr()).show(context);
//                             } else {
//                               if (_formKey.currentState!.validate()) {
//                                 entity.phone = controllerPhone.text;
//                                 entity.lastName = controllerName.text;
//                                 entity.firstName = controllerSurname.text;
//                                 AnimatedNavigation.pushAndRemoveUntil(
//                                   context: context,
//                                   page: ContinueRegistrationIdCard(
//                                     entity: entity,
//                                   ),
//                                 );
//                               }
//                             }
//                           },
//                         ),
//                         SizedBox(height: 50.h),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }