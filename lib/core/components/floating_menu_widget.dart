import 'package:cached_network_image/cached_network_image.dart';
import 'package:clean_calendar/clean_calendar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/services/web_sockets_service.dart';
import 'package:eleven_crm/features/main/domain/entity/current_user_entity.dart';
import 'package:eleven_crm/features/main/presensation/cubit/current_user/current_user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/main/domain/entity/order_entity.dart';
import '../../features/main/presensation/cubit/order_filter_cubit.dart';
import '../../features/main/presensation/widget/calendar_widget.dart';
import '../api/api_constants.dart';
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

  List<DateTime> listBlinkDates = [];

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
                          Container(
                            height: 60,
                            width: 60,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: currentUserEntity.avatar.isEmpty
                                  ? Assets.tAvatarPlaceHolder
                                  : currentUserEntity.avatar,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.error,
                                size: 30,
                                color: Colors.white,
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
              CalendarWidget(
                onRefreshTap: () {
                  BlocProvider.of<OrderFilterCubit>(context).setFilter(
                    query: DateTime.now().toIso8601String(),
                  );
                },
                onDateTap: (DateTime dateTime) {
                  BlocProvider.of<OrderFilterCubit>(context).setFilter(
                    query: dateTime.toIso8601String(),
                  );
                },
                listBlinkDates: listBlinkDates,
              ),
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
            // color: entity.index == currentIndex
            //     ? AppColors.sideMenuSelected
            //     : null),
          ),
          child: !isOpen
              ? _icon(entity.index == currentIndex)
              : Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _icon(entity.index == currentIndex),
                    const SizedBox(width: 10),
                    FittedBox(
                      child: Text(
                        entity.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                          color: entity.index == currentIndex
                              ? Colors.white
                              : Colors.grey.shade300,
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
          color: selected ? Colors.white : Colors.grey.shade300,
        ),
      ),
    );
  }
}
