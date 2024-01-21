import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/components/image_view_widget.dart';
import 'package:eleven_crm/core/components/loading_circle.dart';
import 'package:eleven_crm/core/utils/route_constants.dart';
import 'package:eleven_crm/features/management/presentation/cubit/barber/barber_cubit.dart';
import 'package:eleven_crm/features/management/presentation/cubit/employee/employee_cubit.dart';
import 'package:eleven_crm/features/management/presentation/widgets/barber_profile_edit_body.dart';
import 'package:eleven_crm/features/management/presentation/widgets/barber_profile_services_body.dart';
import 'package:eleven_crm/features/management/presentation/widgets/checker_with_title_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/components/error_flash_bar.dart';
import '../../../../core/components/success_flash_bar.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../get_it/locator.dart';
import '../../../main/presensation/cubit/avatar/avatar_cubit.dart';
import '../../../products/presensation/cubit/service_product/service_product_cubit.dart';
import '../../domain/entity/barber_entity.dart';
import '../../domain/entity/barber_profile_tabs_entity.dart';
import '../cubit/employee_schedule/employee_schedule_cubit.dart';
import '../widgets/barber_profile_schedule_body.dart';
import '../widgets/schedule_calendar_widget.dart';

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
  late ServiceProductCubit serviceProductCubit;
  late EmployeeCubit employeeCubit;
  late EmployeeScheduleCubit employeeScheduleCubit;

  @override
  void initState() {
    barberCubit = locator();
    employeeCubit = locator();
    serviceProductCubit = locator();
    employeeScheduleCubit = locator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BarberCubit>(
          create: (context) => barberCubit,
        ),
        BlocProvider<EmployeeCubit>(
          create: (context) =>
              employeeCubit..loadEmployee(widget.barberEntity.employeeId),
        ),
        BlocProvider<ServiceProductCubit>(
          create: (context) => serviceProductCubit,
        ),
        BlocProvider<EmployeeScheduleCubit>(
          create: (context) => employeeScheduleCubit,
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
    BarberProfileTabsEntity(
      title: "profile",
    ),
    BarberProfileTabsEntity(
      title: "services",
    ),
    BarberProfileTabsEntity(
      title: "schedule",
    ),
  ];
  final TextEditingController controllerFirstName = TextEditingController();
  final TextEditingController controllerLastName = TextEditingController();
  final TextEditingController controllerPhoneNumber = TextEditingController();
  final TextEditingController controllerRole = TextEditingController();

  int selectedTab = 0;
  File? _file;
  Uint8List webImage = Uint8List(8);

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

  @override
  Widget build(BuildContext context) {
    final tab = listTabs[selectedTab];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {

context.pop();
            BlocProvider.of<BarberCubit>(context).load("");
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        title: Text(
            "${widget.barberEntity.firstName} ${widget.barberEntity.lastName}"),
        backgroundColor: const Color(0xff071E32),
      ),
      body: SingleChildScrollView(
        child: MultiBlocListener(
          listeners: [
            BlocListener<BarberCubit, BarberState>(
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
            ),
            BlocListener<EmployeeScheduleCubit, EmployeeScheduleState>(
              listener: (context, state) {
                if (state is EmployeeScheduleSaved) {
                  SuccessFlushBar("change_success".tr()).show(context);
                  BlocProvider.of<EmployeeCubit>(context)
                      .loadEmployee(widget.barberEntity.employeeId);
                  BlocProvider.of<EmployeeScheduleCubit>(context).init();
                }
                if (state is EmployeeScheduleError) {
                  ErrorFlushBar("change_error".tr(args: [state.message]))
                      .show(context);
                }
              },
            ),
          ],
          child: BlocListener<AvatarCubit, AvatarState>(
            listener: (context, state) {
              if (state is AvatarSaved) {
                if (mounted) {
                  Future.delayed(
                    Duration.zero,
                        () {
                      setState(() {
                        _file = null;
                        webImage = Uint8List(8);
                      });
                    },
                  );
                }
              }
              BlocProvider.of<AvatarCubit>(context).init();
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
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ...List.generate(listTabs.length, (index) {
                              final tab = listTabs[index];

                              return Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: MouseRegion(
                                  child: GestureDetector(
                                    onTap: () => setState(() {
                                      selectedTab = index;
                                    }),
                                    child: Text(
                                      tab.title.tr(),
                                      style: TextStyle(
                                        color: selectedTab == index
                                            ? AppColors.accent
                                            : Colors.black,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _barberCardWithCheckers(widget.barberEntity),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          tab.title.tr(),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Nunito",
                                          ),
                                        ),
                                        // if (tab.editTap != null)
                                        //   ElevatedButton(
                                        //     onPressed: tab.editTap,
                                        //     child: Text("edit".tr()),
                                        //   ),
                                      ],
                                    ),
                                    const Divider(),
                                    const SizedBox(height: 10),
                                    _getBody(widget.barberEntity),
                                    const SizedBox(height: 30),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child:
                                BlocBuilder<EmployeeCubit, EmployeeState>(
                                  builder: (context, state) {


                                    print(state );
                                    if (state is EmployeeEntityLoaded) {
                                      final data = state.data;
                                      return ScheduleCalendarWidget(
                                        listSchedule: data.schedule,
                                        onRefreshTap: () {},
                                        employeeId:
                                        widget.barberEntity.employeeId,
                                      );
                                    }

                                    return const Center(
                                      child: LoadingCircle(),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _getBody(BarberEntity barberEntity) {
    if (selectedTab == 0) {
      return BarberProfileEditBody(barberEntity: barberEntity);
    } else if (selectedTab == 1) {
      return BarberProfileServicesBody(
        barberEntity: barberEntity,
      );
    } else if (selectedTab == 2) {
      return BarberProfileScheduleBody(
        barberEntity: barberEntity,
      );
    } else {
      return const SizedBox();
    }
  }

  _barberCardWithCheckers(BarberEntity barberEntity) {
    return SizedBox(
      width: Constants.sizeOfBarberProfileCard,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
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
                    if (_file != null)
                      IconButton(
                        onPressed: () {
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
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        _pickImage();
                      },
                      child: _AvatarWidget(
                        file: _file,
                        webImage: webImage,
                        barberEntity: widget.barberEntity,
                      ),
                    ),
                    const SizedBox(width: 20),
                    if (_file != null)
                      IconButton(
                        onPressed: () {
                          List<int> list = webImage.cast();

                          BlocProvider.of<AvatarCubit>(context).setAvatar(
                              filePath: list,
                              userId: barberEntity.id,
                              role: 'barbers');
                        },
                        icon: Icon(
                          _file != null ? Icons.check_rounded : Icons.edit,
                          size: 30,
                        ),
                      ),
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
                const SizedBox(height: 10),
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
                  onChange: (value) {
                    barberEntity.isActive = value;

                    BlocProvider.of<BarberCubit>(context)
                        .save(barber: barberEntity);
                  },
                  title: 'masterActive'.tr(),
                ),
                const SizedBox(height: 10),
                CheckerWithTitleWidget(
                  isActive: barberEntity.isOnline,
                  onChange: (value) {
                    barberEntity.isOnline = value;

                    BlocProvider.of<BarberCubit>(context)
                        .save(barber: barberEntity);
                  },
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

class _AvatarWidget extends StatefulWidget {
  final Function(File)? onPicked;
  final File? file;
  final Uint8List webImage;
  final BarberEntity barberEntity;
  const _AvatarWidget({
    Key? key,
    this.onPicked,
    required this.file,
    required this.barberEntity,
    required this.webImage,
  }) : super(key: key);

  @override
  State<_AvatarWidget> createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<_AvatarWidget> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: MaterialStateMouseCursor.clickable,
      onExit: (event) {
        if (isHover == false) return;
        setState(() {
          isHover = false;
        });
      },
      onHover: (data) {
        if (isHover == true) return;
        setState(() {
          isHover = true;
        });
      },
      child: Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
            )
          ],
          color: Colors.grey,
        ),
        child: Stack(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: widget.file == null
                    ? ImageViewWidget(
                        avatar: widget.barberEntity.avatar,
                        size: 120,
                      )
                    : Image.memory(
                        widget.webImage,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                child: isHover
                    ? const Center(
                        child: Icon(
                          Icons.photo_camera_outlined,
                          color: Colors.white,
                          size: 40,
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
