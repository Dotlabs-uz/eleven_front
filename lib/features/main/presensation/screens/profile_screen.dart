import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/components/button_widget.dart';
import 'package:eleven_crm/core/components/loading_circle.dart';
import 'package:eleven_crm/features/main/domain/entity/current_user_entity.dart';
import 'package:eleven_crm/features/main/presensation/cubit/avatar/avatar_cubit.dart';
import 'package:eleven_crm/features/management/presentation/cubit/manager/manager_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../core/components/success_flash_bar.dart';
import '../../../../core/components/text_form_field_widget.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/utils/field_masks.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../get_it/locator.dart';
import '../../../management/presentation/cubit/employee/employee_cubit.dart';
import '../cubit/current_user/current_user_cubit.dart';
import '../cubit/locale/locale_cubit.dart';
import '../cubit/top_menu_cubit/top_menu_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late CurrentUserCubit currentUserCubit;
  @override
  void initState() {
    currentUserCubit = locator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: currentUserCubit..load()),
      ],
      child: const _ContentWidget(),
    );
  }
}

class _ContentWidget extends StatefulWidget {
  const _ContentWidget({Key? key}) : super(key: key);

  @override
  State<_ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<_ContentWidget> {
  bool isUzbekLanguage = false;

  final TextEditingController controllerUsername = TextEditingController();
  final TextEditingController controllerFirstName = TextEditingController();
  final TextEditingController controllerLastName = TextEditingController();
  final TextEditingController controllerPhoneNumber = TextEditingController();
  final TextEditingController controllerFilial = TextEditingController();
  final TextEditingController controllerRole = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  File? _file;
  Uint8List webImage = Uint8List(8);

  static CurrentUserEntity entity = CurrentUserEntity.empty();
  @override
  void initState() {
    initialize();

    super.initState();
  }

  initialize() {
    BlocProvider.of<TopMenuCubit>(context).clear();

    Future.delayed(
      Duration.zero,
      () {
        log(context.locale.countryCode.toString());
        if (context.locale.countryCode == 'uz' ||
            context.locale.countryCode == 'UZ') {
          setState(() => isUzbekLanguage = true);
        } else {
          setState(() => isUzbekLanguage = false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: MultiBlocListener(
            listeners: [
              BlocListener<CurrentUserCubit, CurrentUserState>(
                listener: (context, state) {
                  if (state is CurrentUserLoaded) {
                    entity = state.entity;

                    controllerFirstName.text = entity.firstName;
                    controllerLastName.text = entity.lastName;
                    controllerPhoneNumber.text = entity.phoneNumber.toString();
                    controllerUsername.text = entity.login;
                    controllerRole.text = entity.role;
                  }
                  if (state is CurrentUserSaved) {
                    SuccessFlushBar("change_success".tr()).show(context);
                  }
                },
              ),
              BlocListener<AvatarCubit, AvatarState>(
                listener: (context, state) {
                  if (state is AvatarSaved) {
                    SuccessFlushBar("change_success".tr()).show(context);
                  }
                },
              ),
            ],
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (!isUzbekLanguage) {
                            isUzbekLanguage = true;
                            context.setLocale(const Locale('uz', 'UZ'));
                          } else {
                            isUzbekLanguage = false;

                            context.setLocale(const Locale('ru', 'RU'));
                          }
                        });
                        BlocProvider.of<LocaleCubit>(context)
                            .change(context.locale);
                      },
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircleAvatar(
                          backgroundColor: AppColors.background,
                          child: Center(
                            child: Text(
                              context.locale.languageCode,
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_file != null)
                      IconButton(
                        onPressed: () async {
                          setState(() {
                            _file = null;
                            webImage = Uint8List(8);
                          });
                        },
                        icon: Icon(
                          Icons.delete_forever_rounded,
                          size: 30,
                          color: _file == null ? Colors.grey : Colors.blue,
                        ),
                      ),
                    if (_file != null) const SizedBox(width: 20),
                    Center(
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                            )
                          ],
                          color: Colors.white,
                        ),
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: _file == null
                                ? entity.avatar.contains("placeholder.png")
                                    ? Image.asset(Assets.tAvatarPlaceHolder)
                                    : Image.network(entity.avatar)
                                : Image.memory(
                                    webImage,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: _file != null
                          ? () {
                              List<int> list = webImage.cast();

                              BlocProvider.of<AvatarCubit>(context).setAvatar(
                                  filePath: list,
                                  userId: entity.id,
                                  role: 'managers');
                            }
                          : () async {
                              _pickImage();
                            },
                      icon: Icon(
                        _file != null ? Icons.check_rounded : Icons.edit,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: Responsive.isDesktop(context)
                        ? 600
                        : MediaQuery.of(context).size.width,
                  ),
                  child: Column(
                    children: [
                      TextFormFieldWidget(
                        label: "firstName".tr(),
                        controller: controllerFirstName,
                      ),
                      const SizedBox(height: 15),
                      TextFormFieldWidget(
                        label: "lastName".tr(),
                        controller: controllerLastName,
                      ),
                      const SizedBox(height: 15),
                      TextFormFieldWidget(
                        label: "shopName".tr(),
                        controller: controllerFilial,
                      ),
                      const SizedBox(height: 15),
                      TextFormFieldWidget(
                        label: "phone".tr(),
                        controller: controllerPhoneNumber,
                        textInputFormatter: FieldMasks.phoneMaskFormatter,
                      ),
                      const SizedBox(height: 15),
                      TextFormFieldWidget(
                        label: "username".tr(),
                        controller: controllerUsername,
                        enabled: false,
                      ),
                      const SizedBox(height: 15),
                      TextFormFieldWidget(
                        label: "password".tr(),
                        controller: controllerPassword,
                        enabled: true,
                      ),
                      const SizedBox(height: 15),
                      TextFormFieldWidget(
                        label: "role".tr(),
                        controller: controllerRole,
                        enabled: false,
                      ),
                      const SizedBox(height: 25),
                      ButtonWidget(
                        text: "save".tr(),
                        onPressed: () {
                          final newCurrentUser = CurrentUserEntity(
                              id: entity.id,
                              firstName: controllerFirstName.text,
                              lastName: controllerLastName.text,
                              avatar: "",
                              phoneNumber: int.tryParse(
                                    controllerPhoneNumber.text,
                                  ) ??
                                  99,
                              password: controllerPassword.text,
                              login: entity.role,
                              role: entity.role);
                          BlocProvider.of<CurrentUserCubit>(context)
                              .save(newCurrentUser);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _pickImage() async {
    final picker = ImagePicker();

    if (kIsWeb) {
      XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var bytes = await image.readAsBytes();
        setState(() {
          webImage = bytes;
          _file = File(image.path);
        });
      }
    }
  }

  // _saveAvatar(String imagePath) {
  //   BlocProvider.of<UserCubit>(context).setAvatar(
  //     fileName: imagePath,
  //   );
  //   BlocProvider.of<UserCubit>(context).load("");
  // }
}
