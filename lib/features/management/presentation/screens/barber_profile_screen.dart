import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/features/management/presentation/cubit/barber/barber_cubit.dart';
import 'package:eleven_crm/features/management/presentation/widgets/checker_with_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/components/error_flash_bar.dart';
import '../../../../core/components/success_flash_bar.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/utils/constants.dart';
import '../../../../get_it/locator.dart';
import '../../domain/entity/barber_entity.dart';
import '../../domain/entity/barber_profile_tabs_entity.dart';

class BarberProfileScreen extends StatefulWidget {
  final String barberId;
  final BarberEntity barberEntity;
  const BarberProfileScreen({
    Key? key,
    required this.barberId,
    required this.barberEntity,
  }) : super(key: key);

  @override
  State<BarberProfileScreen> createState() => _BarberProfileScreenState();
}

class _BarberProfileScreenState extends State<BarberProfileScreen> {
  late BarberCubit barberCubit;

  @override
  void initState() {
    barberCubit = locator<BarberCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BarberCubit>(
          create: (context) => barberCubit,
        ),
      ],
      child: ContentWidget(
        barberCubit: barberCubit,
        barberEntity: widget.barberEntity,
        barberId: widget.barberId,
      ),
    );
  }
}

class ContentWidget extends StatefulWidget {
  final BarberCubit barberCubit;

  final String barberId;
  final BarberEntity barberEntity;

  const ContentWidget({
    Key? key,
    required this.barberCubit,
    required this.barberId,
    required this.barberEntity,
  }) : super(key: key);

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  final List<BarberProfileTabsEntity> listTabs = [
    BarberProfileTabsEntity("test"),
    BarberProfileTabsEntity("test"),
    BarberProfileTabsEntity("test"),
    BarberProfileTabsEntity("test"),
    BarberProfileTabsEntity("test"),
    BarberProfileTabsEntity("test"),
    BarberProfileTabsEntity("test"),
  ];
  final TextEditingController controllerFirstName = TextEditingController();
  final TextEditingController controllerLastName = TextEditingController();
  final TextEditingController controllerPhoneNumber = TextEditingController();
  final TextEditingController controllerRole = TextEditingController();

  int selectedTab = 0;

  File? _file;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    controllerFirstName.text = widget.barberEntity.firstName;
    controllerLastName.text = widget.barberEntity.lastName;
    controllerPhoneNumber.text = widget.barberEntity.phone.toString();
  }

  initCubit() {
    BlocProvider.of<BarberCubit>(context).init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.barberEntity.firstName} ${widget.barberEntity.lastName}"),
        backgroundColor: const Color(0xff071E32),
      ),
      body: SingleChildScrollView(
        child: BlocListener<BarberCubit, BarberState>(
          listener: (context, state) {
            {
              if (state is BarberSaved) {
                SuccessFlushBar("change_success".tr()).show(context);
              } else if (state is BarberDeleted) {
                SuccessFlushBar("data_deleted".tr()).show(context);
              } else if (state is BarberError) {
                ErrorFlushBar("change_error".tr(args: [state.message]))
                    .show(context);
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),

                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ...List.generate(listTabs.length, (index) {
                            final tab = listTabs[index];

                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: MouseRegion(
                                child: GestureDetector(
                                  onTap: () => setState(() {
                                      selectedTab = index;
                                    }),
                                  child: Text(
                                    tab.title,
                                    style: TextStyle(
                                      color: selectedTab == index ? AppColors.accent :  Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Nunito",
                                      fontSize: 16,

                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _barberCardWithCheckers(widget.barberEntity),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4)),
                          child: Column(
                            children: const [
                              Text("test"),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _barberCardWithCheckers(BarberEntity barberEntity) {
    return SizedBox(
      width: Constants.sizeOfBarberProfileCard,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // if (_file != null)
                    //   IconButton(
                    //     onPressed: _file != null
                    //         ? () => setState(() => _file = null)
                    //         : null,
                    //     icon: Icon(
                    //       Icons.delete_forever_rounded,
                    //       size: 30,
                    //       color: _file == null ? Colors.grey : Colors.blue,
                    //     ),
                    //   ),
                    // const SizedBox(width: 20),
                    Container(
                      height: 120,
                      width: 120,
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
                    // const SizedBox(width: 20),
                    // IconButton(
                    //   onPressed: () {
                    //     // setState(() {
                    //     //   if (_file != null) {
                    //     //     _saveAvatar(_file!.path);
                    //     //   } else {
                    //     //     pickImage();
                    //     //   }
                    //     // });
                    //   },
                    //   icon: Icon(
                    //     _file != null ? Icons.check_rounded : Icons.edit,
                    //     size: 30,
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "${barberEntity.firstName} ${barberEntity.lastName}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: "Nunito",
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "barber".tr(),
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontFamily: "Nunito",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.amberAccent.shade400,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CheckerWithTitleWidget(
                  isActive: barberEntity.isActive,
                  title: 'masterActive'.tr(),
                ),
                const SizedBox(height: 10),
                CheckerWithTitleWidget(
                  isActive: true,
                  title: 'showInOnline'.tr(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
