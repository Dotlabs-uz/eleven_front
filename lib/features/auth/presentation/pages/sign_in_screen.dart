// // ignore_for_file: unused_import
//
// import 'dart:developer';
//
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:taksist/core/utils/field_formatters.dart';
//
// import '../../../../core/components/button_widget.dart';
// import '../../../../core/components/error_flash_bar.dart';
// import '../../../../core/components/text_form_field_widget.dart';
// import '../../../../core/utils/animated_navigation.dart';
// import '../../../../core/utils/app_colors.dart';
// import '../../../../core/utils/assets.dart';
// import '../../../../core/utils/dialogs.dart';
// import '../../../main/presensation/screens/home_screen.dart';
// import '../cubit/get_code/get_code_cubit.dart';
// import '../cubit/login_cubit.dart';
// import 'sign_up_screen.dart';
//
// class SignInScreen extends StatefulWidget {
//
//   const SignInScreen({Key? key})
//       : super(key: key);
//
//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }
//
// class _SignInScreenState extends State<SignInScreen> {
//   final TextEditingController controllerPhone = TextEditingController();
//   final TextEditingController controllerSMSCode = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   late bool enabledSmsCodeField;
//   late bool enabledErrorWidget;
//
//
//
//   @override
//   void initState() {
//     enabledSmsCodeField = false;
//     enabledErrorWidget = false;
//     // setupInteractedMessage();
//
//     // controllerPhone.text = "+994";
//     // controllerSMSCode.text = "208054";
//     super.initState();
//   }
//
//
//   _update({required bool error, required bool field}) {
//     if (mounted) {
//       Future.delayed(
//         Duration.zero,
//             () {
//           setState(() {
//             enabledSmsCodeField = field;
//             enabledErrorWidget = error;
//           });
//         },
//       );
//     }
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     return KeyboardDismissOnTap(
//       child: Scaffold(
//         body: MultiBlocListener(
//           listeners: [
//             BlocListener<GetCodeCubit, GetCodeState>(
//               listener: (context, state) {
//                 debugPrint("Get code $state");
//                 if (state is GetCodeError) {
//                   ErrorFlushBar("change_error".tr(args: [state.message.tr()]))
//                       .show(context);
//                 } else {
//                   if (state is GetCodeIsOnWaiting) {
//                     Dialogs.textWithButton(
//                       context: context,
//                       title: "inWaiting".tr(),
//                       buttonText: "ОК".toUpperCase(),
//                       text: "userInWaiting".tr(),
//                       onTap: () {Navigator.pop(context);},
//                     );
//                   } else if (state is GetCodeSended) {
//                     _update(error: false, field: true);
//
//                   }else if (state is GetCodeIsNotAuth) {
//                     _update(error: true, field: false);
//                   }
//                 }
//               },
//             ),
//             BlocListener<LoginCubit, LoginState>(
//               listener: (context, state) {
//                 print("state $state");
//                 if (state is LoginError) {
//                   ErrorFlushBar("change_error".tr(args: [state.message.tr()]))
//                       .show(context);
//                 }else if (state is SMSCodeIsNotCorrect) {
//                   ErrorFlushBar("change_error".tr(args: ["smsCodeIsNotCorrect".tr()]))
//                       .show(context);
//                 }else {
//                   if (state is LoginSuccess) {
//                     AnimatedNavigation.push(
//                       context: context,
//                       page: const HomeScreen(),
//                     );
//                   }
//                 }
//
//               },
//             ),
//           ],
//           child: Form(
//             key: _formKey,
//             child: SizedBox(
//               height: MediaQuery.of(context).size.height,
//               child: SafeArea(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 35.w),
//                   child: SingleChildScrollView(
//                     physics: const ClampingScrollPhysics(),
//                     child: Center(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           SizedBox(height: 18.h),
//
//                           Text(
//                             "Taksist.az",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w500,
//                               fontStyle: FontStyle.normal,
//                               fontFamily: "SFProDisplay",
//                               fontSize: 36.sp,
//                             ),
//                           ),
//
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "officialPartner".tr(),
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w400,
//                                   fontStyle: FontStyle.normal,
//                                   fontFamily: "SFProDisplay",
//                                   fontSize: 17.sp,
//                                 ),
//                               ),
//                               SizedBox(width: 8.w),
//                               SizedBox(
//                                 width: 54.w,
//                                 height: 32.h,
//                                 child: Image.asset(Assets.tBoltLogo),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 50.h),
//                           //
//                           // const ElTooltip(
//                           //   content: Text("Это иконка с вопросом"),
//                           //   position: ElTooltipPosition.rightStart,
//                           //   child: Icon(Icons.help_outline),
//                           // ),
//                           Text(
//                             "beginStartWorking".tr(),
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontStyle: FontStyle.normal,
//                               fontFamily: "SFProDisplay",
//                               fontWeight: FontWeight.w500,
//                               fontSize: 28.sp,
//                             ),
//                           ),
//                           SizedBox(height: 5.h),
//                           Text(
//                             "signInInfoText".tr(),
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontStyle: FontStyle.normal,
//                               fontFamily: "SFProDisplay",
//                               fontWeight: FontWeight.w400,
//                               fontSize: 17.sp,
//                             ),
//                           ),
//                           SizedBox(height: 30.h),
//                           TextFormFieldWidget(
//                             controller: controllerPhone,
//                             keyboardType:
//                                 const TextInputType.numberWithOptions(),
//                             textInputFormatter:
//                                 FieldFormatters.phoneMaskFormatter,
//                             enableErrorWidget: enabledErrorWidget,
//                             errorWidget: RichText(
//                                 text: TextSpan(children: [
//                               TextSpan(
//                                 text: "yourNumberNotRegistered".tr(),
//                                 style: TextStyle(
//                                   fontFamily: "SFProDisplay",
//                                   fontStyle: FontStyle.normal,
//                                   decoration: TextDecoration.none,
//                                   fontWeight: FontWeight.w500,
//                                   color: AppColors.errorColor,
//                                   fontSize: 15.sp,
//                                 ),
//                               ),
//                               const TextSpan(
//                                 text: " ",
//                               ),
//                               TextSpan(
//                                 text: "register".tr(),
//                                 recognizer: TapGestureRecognizer()
//                                   ..onTap = () => AnimatedNavigation.push(
//                                       context: context, page: SignUpScreen()),
//                                 style: TextStyle(
//                                   fontFamily: "SFProDisplay",
//                                   fontStyle: FontStyle.normal,
//                                   decoration: TextDecoration.underline,
//                                   fontWeight: FontWeight.w500,
//                                   color: AppColors.errorColor,
//                                   fontSize: 15.sp,
//                                 ),
//                               ),
//                             ])),
//                             hintText: "+994",
//                             title: 'phoneNumber',
//                           ),
//                           if (enabledErrorWidget) SizedBox(height: 30.h),
//
//                           if (enabledSmsCodeField)
//                             TextFormFieldWidget(
//                               controller: controllerSMSCode,
//                               hintText: "smsCode".tr().toLowerCase(),
//                               keyboardType:
//                                   const TextInputType.numberWithOptions(),
//                               title: 'smsCode',
//                               isPassword: false,
//                             ),
//                           if (enabledSmsCodeField) SizedBox(height: 30.h),
//                           // SizedBox(height: 20.h),
//                           // TextFormFieldWidget(
//                           //   controller: controllerPassword,
//                           //   hintText: "Password".tr(),
//                           //   validator: FormValidator.empty,
//                           //   prefixImageSvg: Assets.tPasswordIcon,
//                           //   keyboardType: TextInputType.visiblePassword,
//                           //   isPassword: true,
//                           // ),
//                           _buildButtons(controllerPhone, controllerSMSCode),
//                           SizedBox(height: 30.h),
//
//                           Center(
//                             child: Text(
//                               "dontHaveAccount".tr(),
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 15.sp,
//                                 fontStyle: FontStyle.normal,
//                                 fontFamily: "SFProDisplay",
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//
//                           Center(
//                             child: TextButton(
//                               onPressed: () {
//                                 AnimatedNavigation.push(
//                                     context: context, page: SignUpScreen());
//                               },
//                               child: Text(
//                                 "signUp".tr(),
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 17.sp,
//                                   fontStyle: FontStyle.normal,
//                                   decoration: TextDecoration.underline,
//                                   fontFamily: "SFProDisplay",
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 50.h),
//                         ],
//                       ),
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
//
//   _buildButtons(TextEditingController controllerPhoneNumber,
//       TextEditingController controllerSmsCode) {
//     return enabledSmsCodeField
//         ? ButtonWidget(
//             title: 'enter'.tr(),
//             onTap: () {
//               if (_formKey.currentState!.validate()) {
//                 String unformattedValue = controllerPhoneNumber.text
//                     .trim()
//                     .replaceAll("+", "")
//                     .replaceAll("994", "");
//
//                 BlocProvider.of<LoginCubit>(context)
//                     .login(unformattedValue, controllerSmsCode.text);
//               }
//             },
//           )
//         : ButtonWidget(
//             title: 'getPassword'.tr(),
//             onTap: () {
//               String unformattedValue = controllerPhoneNumber.text
//                   .trim()
//                   .replaceAll("+", "")
//                   .replaceAll("994", "");
//               if (_formKey.currentState!.validate()) {
//
//                 BlocProvider.of<GetCodeCubit>(context).getSmsCode(
//                   unformattedValue,
//                 );
//               }
//             },
//           );
//   }
// }
