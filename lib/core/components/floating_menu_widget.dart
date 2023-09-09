import 'package:easy_localization/easy_localization.dart';
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
  static bool isOpen = false;
  String version = "";

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: isOpen ? 230 : 100,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.amber,

        // color: AppColor.menuBgColor,
        // borderRadius: BorderRadius.circular(15),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
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
            const SizedBox(height: 15),
            ...List.generate(widget.listEntity.length, (index) {
              return FloatingMenuItemWidget(
                entity: widget.listEntity[index],
                currentIndex: widget.selectedIndex,
                onTap: (value) => widget.onChanged?.call(value),
                isOpen: isOpen,
              );
            }),

            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: GestureDetector(
                onTap: () => setState(() => isOpen = !isOpen),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        !isOpen
                            ? Icons.chevron_right_rounded
                            : Icons.chevron_left_rounded,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
              color: entity.index == currentIndex ? Colors.orange : null),
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
                          color: Colors.black,
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
          color: selected ? Colors.black : Colors.black,
        ),
      ),
    );
  }
}
