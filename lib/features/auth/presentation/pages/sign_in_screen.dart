import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/features/auth/presentation/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../../../core/components/button_widget.dart';
import '../../../../core/components/error_flash_bar.dart';
import '../../../../core/components/logo_widget.dart';
import '../../../../core/components/success_flash_bar.dart';
import '../../../../core/components/text_form_field_widget.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/route_constants.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController controllerLogin = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();




  @override
  void initState() {
    // controllerLogin.text = "manager";
    // controllerPassword.text = "manager123";
    super.initState();
  }


  @override
  void dispose() {
    controllerLogin.dispose();
    controllerPassword.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              RouteList.home,
              (route) => false,
            );
          } else if (state is LoginError) {
            ErrorFlushBar("change_error".tr(args: [state.message.tr()]))
                .show(context);
          }
        },
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: Responsive.isDesktop(context)
                    ? 500
                    : MediaQuery.of(context).size.width,
              ),
              padding: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LogoWidget(
                    height: 100,
                  ),
                  Text(
                    "welcome".tr(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: TextFormFieldWidget(
                      controller: controllerLogin,
                      defaultBorderColor: Colors.black.withOpacity(0.3),
                      label: 'login'.tr(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: TextFormFieldWidget(
                      controller: controllerPassword,
                      isPassword: true,
                      defaultBorderColor: Colors.black.withOpacity(0.3),
                      label: 'password'.tr(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ButtonWidget(
                    borderRadius: BorderRadius.circular(14),
                    onPressed: () {

                      BlocProvider.of<LoginCubit>(context).login(
                        controllerLogin.text,
                        controllerPassword.text,
                      );
                    },
                    text: "enter".tr(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
