import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/components/loading_circle.dart';
import 'package:eleven_crm/features/management/presentation/cubit/barber/barber_cubit.dart';
import 'package:eleven_crm/features/management/presentation/cubit/employee/employee_cubit.dart';
import 'package:eleven_crm/features/management/presentation/widgets/barber_profile_edit_body.dart';
import 'package:eleven_crm/features/management/presentation/widgets/barber_profile_services_body.dart';
import 'package:eleven_crm/features/management/presentation/widgets/checker_with_title_widget.dart';
import 'package:eleven_crm/features/management/presentation/widgets/employee_profile_schedule_body.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/components/error_flash_bar.dart';
import '../../../../core/components/success_flash_bar.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/utils/constants.dart';
import '../../../../get_it/locator.dart';
import '../../../main/presensation/cubit/avatar/avatar_cubit.dart';
import '../../../products/presensation/cubit/service_product/service_product_cubit.dart';
import '../../domain/entity/barber_entity.dart';
import '../../domain/entity/barber_profile_tabs_entity.dart';
import '../../domain/entity/employee_entity.dart';
import '../widgets/barber_profile_schedule_body.dart';
import '../widgets/schedule_calendar_widget.dart';

class EmployeeProfileScreen extends StatefulWidget {
  final EmployeeEntity employeeEntity;
  const EmployeeProfileScreen({
    Key? key,
    required this.employeeEntity,
  }) : super(key: key);

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  late EmployeeCubit employeeCubit;

  @override
  void initState() {
    employeeCubit = locator();
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
        employeeEntity: widget.employeeEntity,
      ),
    );
  }
}

class ContentWidget extends StatefulWidget {
  final EmployeeEntity employeeEntity;

  const ContentWidget({
    Key? key,
    required this.employeeEntity,
  }) : super(key: key);

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  final List<BarberProfileTabsEntity> listTabs = [
    BarberProfileTabsEntity(
      title: "schedule",
    ),
  ];
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final tab = listTabs[selectedTab];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context),icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white,),),

        title: Text(
            "${widget.employeeEntity.firstName} ${widget.employeeEntity.lastName}"),
        backgroundColor: const Color(0xff071E32),
      ),
      body: SingleChildScrollView(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      _getBody(widget.employeeEntity),
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
                  child: ScheduleCalendarWidget(
                    listSchedule: widget.employeeEntity.schedule,
                    onRefreshTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getBody(EmployeeEntity employeeEntity) {
    if (selectedTab == 0) {
      return EmployeeProfileScheduleBody(employeeEntity: employeeEntity);
    } else {
      return const SizedBox();
    }
  }
}
