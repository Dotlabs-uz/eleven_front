import 'package:clean_calendar/clean_calendar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/features/main/domain/entity/current_user_entity.dart';
import 'package:eleven_crm/features/main/presensation/cubit/current_user/current_user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../utils/dialogs.dart';

class FloatingMenuEntity {
  final String title;
  final int index;
  final IconData icon;
  final String key;

  FloatingMenuEntity({
    required this.title,
    required this.icon,
    required this.key,
    required this.index,
  });
}

class FloatingMenuWidget extends StatefulWidget {
  final Function(FloatingMenuEntity)? onChanged;

  final int selectedIndex;
  final List<FloatingMenuEntity> listEntity;
  final Function() onProfileTap;

  const FloatingMenuWidget({
    Key? key,
    this.onChanged,
    required this.listEntity,
    required this.onProfileTap,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  State<FloatingMenuWidget> createState() => _FloatingMenuWidgetState();
}

class _FloatingMenuWidgetState extends State<FloatingMenuWidget> {
  static bool isOpen = true;
  String version = "";
  static CurrentUserEntity currentUserEntity = CurrentUserEntity.empty();

  @override
  void initState() {
    BlocProvider.of<CurrentUserCubit>(context).load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CurrentUserCubit, CurrentUserState>(
      listener: (context, state) {
        if (state is CurrentUserLoaded) {
          if (mounted) {
            Future.delayed(
              Duration.zero,
              () {
                setState(() {
                  currentUserEntity = state.entity;
                });
              },
            );
          }
        }
      },
      child: Container(
        width: isOpen ? 300 : 100,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: AppColors.sideMenu,

          // color: AppColor.menuBgColor,
          // borderRadius: BorderRadius.circular(15),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 10),

              Padding(
                padding:
                    // !isOpen ? const EdgeInsets.only(left: 5) : EdgeInsets.zero,
                    const EdgeInsets.only(left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => widget.onProfileTap.call(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 25,

                            // backgroundImage: _image(""),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Center(
                                child: currentUserEntity.avatar.isNotEmpty
                                    ? Image.network(currentUserEntity.avatar)
                                    : Image.asset(
                                        Assets.tAvatarPlaceHolder,
                                        fit: BoxFit.fill,
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${currentUserEntity.firstName} ${currentUserEntity.lastName}",
                                style: const TextStyle(
                                  fontFamily: "Nunito",
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                currentUserEntity.role.tr(),
                                style: const TextStyle(
                                  fontFamily: "Nunito",
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onPressed: () {
                        Dialogs.exitDialog(
                          context: context,
                          onExit: () {
                            BlocProvider.of<LoginCubit>(context).logout();
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ...List.generate(widget.listEntity.length, (index) {
                return FloatingMenuItemWidget(
                  entity: widget.listEntity[index],
                  currentIndex: widget.selectedIndex,
                  onTap: (value) => widget.onChanged?.call(value),
                  isOpen: isOpen,
                );
              }),
              //
              const SizedBox(height: 40),
              const CalendarWidget(),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider<Object> _image(String? avatar) {
    if (avatar != null && avatar.isNotEmpty) {
      return NetworkImage(avatar);
    } else {
      return const AssetImage(Assets.tAvatarPlaceHolder);
    }
  }
}

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  @override
  Widget build(BuildContext context) {
    return CleanCalendar(
      enableDenseViewForDates: true,
      enableDenseSplashForDates: true,

      dateSelectionMode: DatePickerSelectionMode.disable,
      startWeekday: WeekDay.monday,

      headerProperties: HeaderProperties(
        monthYearDecoration: MonthYearDecoration(
          monthYearTextColor: Colors.white,
          monthYearTextStyle: const TextStyle(
            color: Colors.white,
            fontFamily: "Nunito",
            fontSize: 16,
          ),
        ),
        navigatorDecoration: NavigatorDecoration(
          navigateLeftButtonIcon: const Icon(
            Icons.chevron_left_rounded,
            color: Colors.white,
          ),
          navigateRightButtonIcon: const Icon(
            Icons.chevron_right_rounded,
            color: Colors.white,
          ),
          navigatorResetButtonIcon: const Icon(
            Icons.date_range_rounded,
            color: Colors.white,
          ),
        ),
      ),

      selectedDatesProperties: DatesProperties(
        datesDecoration: DatesDecoration(
          datesBackgroundColor: Colors.amber,
          datesBorderRadius: 6,
          datesBorderColor: Colors.transparent,
          datesTextStyle: const TextStyle(
            fontFamily: "Nunito",
            color: Colors.white,
          ),
        ),
      ),
      leadingTrailingDatesProperties: DatesProperties(
          datesDecoration: DatesDecoration(
        datesBorderRadius: 6,
        datesBorderColor: Colors.black26,
        datesBackgroundColor: Colors.black26,
        datesTextColor: Colors.black26,
      )),
      // selectedDatesProperties: ,
      generalDatesProperties: DatesProperties(
        datesDecoration: DatesDecoration(
          // datesBackgroundColor: const Color(0xff1A1A1A),
          datesBorderColor: Colors.transparent,
          datesBackgroundColor: Colors.transparent,
          datesTextColor: Colors.white,
          // datesTextStyle: const TextStyle(
          //   fontFamily: "Nunito",
          //   color: Colors.white,
          // )
        ),
      ),

      weekdaysProperties: WeekdaysProperties(
        generalWeekdaysDecoration: WeekdaysDecoration(
            weekdayTextColor: Colors.white,
            weekdayTextStyle: GoogleFonts.nunito(
              color: Colors.white,
            )),
      ),
      selectedDates: [DateTime.now()],
      onCalendarViewDate: (DateTime calendarViewDate) {
        // debugPrint(calendarViewDate);
      },
      onSelectedDates: (List<DateTime> value) {},
    );
  }
}

class FloatingMenuItemWidget extends StatelessWidget {
  final FloatingMenuEntity entity;
  final int currentIndex;
  final bool isOpen;
  final Function(FloatingMenuEntity) onTap;

  const FloatingMenuItemWidget({
    Key? key,
    required this.entity,
    required this.currentIndex,
    required this.onTap,
    required this.isOpen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: GestureDetector(
        onTap: () {
          onTap.call(entity);
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: entity.index == currentIndex
                  ? AppColors.sideMenuSelected
                  : null),
          child: !isOpen
              ? _icon(entity.index == currentIndex)
              : Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 10),
                    _icon(entity.index == currentIndex),
                    const SizedBox(width: 10),
                    FittedBox(
                      child: Text(
                        entity.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: entity.index == currentIndex
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  _icon(bool selected) {
    return SizedBox(
      child: Center(
        child: Icon(
          entity.icon,
          size: 30,
          color: selected ? Colors.white : Colors.white,
        ),
      ),
    );
  }
}
