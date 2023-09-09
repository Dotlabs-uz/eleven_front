import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
const kBorderRadius = 10.0;
const kSpacing = 20.0;
const defaultPadding = 16.0;


class SelectionButtonData {
  final IconData activeIcon;
  final IconData icon;
  final String label;
  final String key;
  final int? totalNotif;

  SelectionButtonData({
    required this.key,
    required this.activeIcon,
    required this.icon,
    required this.label,
    this.totalNotif,
  });
}

class SelectionButton extends StatefulWidget {
  const SelectionButton({
    this.initialSelected = 1,
    required this.data,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  final int initialSelected;
  final List<SelectionButtonData> data;
  final Function(int index, SelectionButtonData value) onSelected;

  @override
  State<SelectionButton> createState() => _SelectionButtonState();
}

class _SelectionButtonState extends State<SelectionButton> {
  late int selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.data.asMap().entries.map((e) {
        final index = e.key;
        final data = e.value;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: _Button(
            selected: selected == index,
            onPressed: () {
              widget.onSelected(index, data);
              setState(() {
                selected = index;
              });
            },
            data: data,
          ),
        );
      }).toList(),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.selected,
    required this.data,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final bool selected;
  final SelectionButtonData data;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      // borderRadius: BorderRadius.circular(kBorderRadius),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              _buildIcon(),
              const SizedBox(width: kSpacing / 2),
              Expanded(child: _buildLabel()),
              if (data.totalNotif != null)
                Padding(
                  padding: const EdgeInsets.only(left: kSpacing / 2),
                  child: _buildNotif(),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Icon(
      (!selected) ? data.icon : data.activeIcon,
      size: 20,
      color: (selected)
          ? Colors.red
          : Colors.green,
      // (!selected) ? kFontColorPallets[1] : Theme.of(Gcontext!).primaryColor,
    );
  }

  Widget _buildLabel() {
    return Text(
      data.label,
      style: GoogleFonts.nunito(
        color: (selected)
            ? Colors.red
            : Colors.green,

        // color: (!selected)
        //     ? kFontColorPallets[1]
        //     : Theme.of(context!).primaryColor,
        fontWeight: FontWeight.bold,
        letterSpacing: .8,
        fontSize: 14,
      ),
    );
  }

  Widget _buildNotif() {
    return (data.totalNotif == null || data.totalNotif! <= 0)
        ? Container()
        : Container(
            width: 30,
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              (data.totalNotif! >= 100) ? "99+" : "${data.totalNotif}",
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          );
  }
}

// class _Button extends StatelessWidget {
//   const _Button({
//     required this.selected,
//     required this.data,
//     required this.onPressed,
//     Key? key,
//   }) : super(key: key);

//   final bool selected;
//   final SelectionButtonData data;
//   final Function() onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color:
//           (!selected) ? null : Theme.of(context).primaryColor.withOpacity(.1),
//       borderRadius: BorderRadius.circular(kBorderRadius),
//       child: InkWell(
//         onTap: onPressed,
//         borderRadius: BorderRadius.circular(10),
//         child: Padding(
//           padding: const EdgeInsets.all(15),
//           child: Row(
//             children: [
//               _buildIcon(),
//               const SizedBox(width: kSpacing / 2),
//               Expanded(child: _buildLabel()),
//               if (data.totalNotif != null)
//                 Padding(
//                   padding: const EdgeInsets.only(left: kSpacing / 2),
//                   child: _buildNotif(),
//                 )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildIcon() {
//     return Icon(
//       (!selected) ? data.icon : data.activeIcon,
//       size: 20,
//       color: kFontColorPallets[1],
//       // (!selected) ? kFontColorPallets[1] : Theme.of(Gcontext!).primaryColor,
//     );
//   }

//   Widget _buildLabel() {
//     return Text(
//       data.label,
//       style: TextStyle(
//         color: kFontColorPallets[1],

//         // color: (!selected)
//         //     ? kFontColorPallets[1]
//         //     : Theme.of(context!).primaryColor,
//         fontWeight: FontWeight.bold,
//         letterSpacing: .8,
//         fontSize: 14,
//       ),
//     );
//   }

//   Widget _buildNotif() {
//     return (data.totalNotif == null || data.totalNotif! <= 0)
//         ? Container()
//         : Container(
//             width: 30,
//             padding: const EdgeInsets.all(5),
//             decoration: const BoxDecoration(
//               color: Colors.orange,
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(10),
//                 bottomRight: Radius.circular(10),
//                 topRight: Radius.circular(10),
//               ),
//             ),
//             alignment: Alignment.center,
//             child: Text(
//               (data.totalNotif! >= 100) ? "99+" : "${data.totalNotif}",
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 10,
//                 fontWeight: FontWeight.w600,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           );
//   }
// }
