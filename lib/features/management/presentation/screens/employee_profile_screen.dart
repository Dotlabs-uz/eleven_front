import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clean_calendar/clean_calendar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/components/button_widget.dart';
import 'package:eleven_crm/core/components/loading_circle.dart';
import 'package:eleven_crm/features/main/presensation/widget/calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/components/error_flash_bar.dart';
import '../../../../core/components/floating_menu_widget.dart';
import '../../../../core/components/success_flash_bar.dart';
import '../../../../core/components/text_form_field_widget.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/utils/field_masks.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../get_it/locator.dart';
import '../../../main/presensation/widget/calendar_employee_widget.dart';
import '../../domain/entity/employee_entity.dart';
import '../cubit/employee/employee_cubit.dart';

class EmployeeProfileScreen extends StatefulWidget {
  final String employeeId;
  final String employeeName;
  const EmployeeProfileScreen(
      {Key? key, required this.employeeId, required this.employeeName})
      : super(key: key);

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  late EmployeeCubit employeeCubit;

  @override
  void initState() {
    employeeCubit = locator<EmployeeCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EmployeeCubit>(
          create: (context) => employeeCubit,
        ),
      ],
      child: ContentWidget(
        employeeCubit: employeeCubit,
        employeeName: widget.employeeName,
        employeeId: widget.employeeId,
      ),
    );
  }
}

class ContentWidget extends StatefulWidget {
  final EmployeeCubit employeeCubit;

  final String employeeId;
  final String employeeName;

  const ContentWidget({
    Key? key,
    required this.employeeCubit,
    required this.employeeId,
    required this.employeeName,
  }) : super(key: key);

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  final TextEditingController controllerFirstName = TextEditingController();
  final TextEditingController controllerLastName = TextEditingController();
  final TextEditingController controllerPhoneNumber = TextEditingController();
  final TextEditingController controllerFilial = TextEditingController();
  final TextEditingController controllerRole = TextEditingController();

  File? _file;

  void _saveData() {
    BlocProvider.of<EmployeeCubit>(context)
        .save(employee: EmployeeEntity.fromFields());
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    print(widget.employeeName.toString());
    BlocProvider.of<EmployeeCubit>(context).load("");
  }

  fetch(
    int page,
  ) async {
    BlocProvider.of<EmployeeCubit>(context).load("", page: page);
  }

  initCubit() {
    BlocProvider.of<EmployeeCubit>(context).init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.employeeName)),
      body: SingleChildScrollView(
        child: BlocListener<EmployeeCubit, EmployeeState>(
          listener: (context, state) {
            if (state is EmployeeLoaded) {
              // customers = state.data;
              // dataCount = state.dataCount;
            }

            {
              if (state is EmployeeSaved) {
                SuccessFlushBar("change_success".tr()).show(context);
              } else if (state is EmployeeDeleted) {
                SuccessFlushBar("data_deleted".tr()).show(context);
              } else if (state is EmployeeError) {
                ErrorFlushBar("change_error".tr(args: [state.message]))
                    .show(context);
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                      const SizedBox(width: 20),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _bodyWidget(),
                        // const SizedBox(width: 20),
                        // _calendarWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _bodyWidget() {
    return Container(
      constraints: BoxConstraints(
        maxWidth: Responsive.isDesktop(context)
            ? 400
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
            label: "role".tr(),
            controller: controllerRole,
            enabled: false,
          ),
          const SizedBox(height: 15),
          const SizedBox(height: 25),
          ButtonWidget(
            text: "save".tr(),
            onPressed: () {
              _saveData();
            },
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  _calendarWidget() {
    return BlocBuilder<EmployeeCubit, EmployeeState>(
      builder: (context, state) {
        if (state is EmployeeLoaded) {
          final entity = state.data.first;

          return CalendarEmployeeWidget(
            onRefreshTap: () {},
            onDateTap: (dateTime) {},
            listSchedule: entity.schedule,
          );
        }

        return const LoadingCircle();
      },
    );
  }
}
