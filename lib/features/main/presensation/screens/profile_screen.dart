import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/features/main/presensation/cubit/current_user/current_user_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../../core/components/text_form_field_widget.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/utils/field_masks.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../get_it/locator.dart';
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
          child: BlocListener<CurrentUserCubit, CurrentUserState>(
            listener: (context, state) {
              if (state is CurrentUserLoaded) {
                final entity = state.entity;
                controllerFirstName.text = entity.firstName;
                controllerLastName.text = entity.lastName;
                controllerPhoneNumber.text = entity.phoneNumber.toString();
                controllerUsername.text = entity.login;
                controllerRole.text = entity.role;
              }
            },
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
                    if (kIsWeb == false && Platform.isAndroid)
                      IconButton(
                        onPressed: _file != null
                            ? () => setState(() => _file = null)
                            : null,
                        icon: Icon(
                          Icons.delete_forever_rounded,
                          size: 30,
                          color: _file == null ? Colors.grey : Colors.blue,
                        ),
                      ),
                    if (kIsWeb == false && Platform.isAndroid)
                      const SizedBox(width: 20),
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
                                ? CachedNetworkImage(
                                    imageUrl: Assets
                                        .tAvatarPlaceHolder, // entity.avatar ?? Assets.tAvatarPlaceHolder,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error,
                                      size: 30,
                                      color: Colors.red,
                                    ),
                                  )
                                : Image.file(_file!),
                          ),
                        ),
                      ),
                    ),
                    if (kIsWeb == false && Platform.isAndroid)
                      const SizedBox(width: 20),
                    if (kIsWeb == false && Platform.isAndroid)
                      IconButton(
                        onPressed: () {
                          // setState(() {
                          //   if (_file != null) {
                          //     _saveAvatar(_file!.path);
                          //   } else {
                          //     pickImage();
                          //   }
                          // });
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
                      const SizedBox(height: 15),
                    ],
                  ),
                ),

                //
                // TextFormFieldWidget(
                //   label: "IsStaff".tr(),
                //   controller: controllerIsStaff,
                //   boxConstraints: BoxConstraints(
                //     maxWidth: Responsive.isDesktop(context)
                //         ? 600
                //         : MediaQuery.of(context).size.width,
                //   ),
                //   enabled: false,
                // ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // _saveAvatar(String imagePath) {
  //   BlocProvider.of<UserCubit>(context).setAvatar(
  //     fileName: imagePath,
  //   );
  //   BlocProvider.of<UserCubit>(context).load("");
  // }

  Future pickImage() async {
    try {
      final picker = ImagePicker();
      var image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imagePath = image.path;

      final cropImage = await ImageCropper.platform.cropImage(
        sourcePath: imagePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.red,
            toolbarWidgetColor: Colors.yellow,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            activeControlsWidgetColor: Colors.teal,
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioLockEnabled: true,
          ),
        ],
      );
      if (cropImage == null) return;

      setState(() => _file = File(cropImage.path));
      // _file = cropImage as File?;
    } on PlatformException catch (error) {
      throw PlatformException(code: error.toString());
    }
    //
    // try {
    //   final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    //   if (image == null) return;
    //   final imageTemp = File(image.path);
    //
    //   setState(() => this.image = imageTemp);
    //   log("image ${this.image}");
    // } on PlatformException catch (e) {
    //   debugPrint('Failed to pick image: $e');
    // }
  }
}
