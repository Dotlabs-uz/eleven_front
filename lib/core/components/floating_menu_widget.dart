import 'package:clean_calendar/clean_calendar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_colors.dart';
import '../utils/assets.dart';

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
  final Function() onTapProfil;
  final List<FloatingMenuEntity> listEntity;

  const FloatingMenuWidget({
    Key? key,
    this.onChanged,
    required this.listEntity,
    required this.onTapProfil,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  State<FloatingMenuWidget> createState() => _FloatingMenuWidgetState();
}

class _FloatingMenuWidgetState extends State<FloatingMenuWidget> {
  static bool isOpen = true;
  String version = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  !isOpen ? const EdgeInsets.only(left: 5) : EdgeInsets.zero,
              child: CircleAvatar(
                radius: 35,
                backgroundImage: _image(""),
                // child: Container(
                //   child: Center(
                //     child: avatar.isNotEmpty
                //         ? Image.network(avatar)
                //         : Image.asset(
                //             Assets.tAvatarPlaceHolder,
                //             fit: BoxFit.fill,
                //           ),
                //   ),
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
    );
  }

  ImageProvider<Object> _image(String? avatar) {
    print("Avatar $avatar");
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
        // print(calendarViewDate);
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
