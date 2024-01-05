import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PageSelectorWidget extends StatefulWidget {
  const PageSelectorWidget({
    Key? key,
    required this.pageCount,
    this.pagesVisible = 3,
    required this.onChanged,
  }) : super(key: key);

  final int pageCount;
  final int pagesVisible;
  final Function(int) onChanged;

  @override
  State<PageSelectorWidget> createState() => _PageSelectorWidgetState();
}

class _PageSelectorWidgetState extends State<PageSelectorWidget> {
  int selectedPage = 1;
  final TextEditingController controllerPage = TextEditingController();

  late int _startPage;
  late int _endPage;

  bool openForm = false;

  @override
  void initState() {
    super.initState();
    _calculateVisiblePages();
  }

  @override
  void didUpdateWidget(PageSelectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _calculateVisiblePages();
  }

  void _calculateVisiblePages() {
    /// If the number of pages is less than or equal to the number of pages visible, then show all the pages
    if (widget.pageCount <= widget.pagesVisible) {
      _startPage = 1;
      _endPage = widget.pageCount;
    } else {
      /// If the number of pages is greater than the number of pages visible, then show the pages visible
      int middle = (widget.pagesVisible - 1) ~/ 2;
      if (selectedPage <= middle + 1) {
        _startPage = 1;
        _endPage = widget.pagesVisible;
      } else if (selectedPage >= widget.pageCount - middle) {
        _startPage = widget.pageCount - (widget.pagesVisible - 1);
        _endPage = widget.pageCount;
      } else {
        _startPage = selectedPage - middle;
        _endPage = selectedPage + middle;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _pageSelector(),
          SizedBox(
            width: 130,
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: controllerPage,
              autofocus: false,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                  ),
                ),
                hintText: "enterPage".tr(),
                labelText: "enterPage".tr(),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              if (controllerPage.text.isEmpty) {
                return;
              }
              var formatted = int.parse(controllerPage.text);
              setState(() {
                if (formatted > widget.pageCount) {
                  formatted = widget.pageCount;
                } else if (formatted < 1) {
                  formatted = 1;
                }

                selectedPage = formatted;
                widget.onChanged.call(formatted);
              });
            },
            icon: const Icon(Icons.check_rounded),
          )
        ],
      ),
    );
  }

  _pageSelector() {
    return Row(
      children: <Widget>[
        if (selectedPage >= 5)
          IconButton(
            onPressed: () {
              setState(() {
                if (selectedPage - 5 <= 1) {
                  debugPrint("first $selectedPage");
                  selectedPage = 1;
                  widget.onChanged.call(selectedPage);
                } else {
                  selectedPage = selectedPage - 5;
                  widget.onChanged.call(selectedPage);
                }
              });
            },
            icon: Icon(
              Icons.keyboard_double_arrow_left_rounded,
              color: selectedPage >= 5 ? Colors.blue : Colors.grey,
              size: 24,
            ),
          ),
        IconButton(
          onPressed: selectedPage != 1
              ? () {
                  setState(() {
                    selectedPage--;

                    widget.onChanged.call(selectedPage);
                  });
                }
              : null,
          icon: Icon(
            Icons.chevron_left_rounded,
            color: selectedPage != 1 ? Colors.blue : Colors.grey,
            size: 24,
          ),
        ),
        const SizedBox(width: 10),
        widget.pageCount >= 3
            ? Row(
                children: [
                  if (selectedPage != 1)
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedPage = 1;
                          widget.onChanged.call(selectedPage);
                        });
                      },
                      child: Ink(
                          child: const Text(
                        "1",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Nunito",
                        ),
                      )),
                    ),
                  if (selectedPage != 1)
                    const Text(
                      "...",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Nunito",
                      ),
                    ),
                  Text(
                    selectedPage.toString(),
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Nunito",
                    ),
                  ),
                  if (selectedPage != widget.pageCount)
                    const Text(
                      "...",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Nunito",
                      ),
                    ),
                  if (selectedPage != widget.pageCount)
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedPage = widget.pageCount;
                          widget.onChanged.call(selectedPage);
                        });
                      },
                      child: Ink(
                        child: Text(
                          widget.pageCount.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Nunito",
                          ),
                        ),
                      ),
                    ),
                ],
              )
            : Row(
                children: [
                  for (int i = _startPage; i <= _endPage; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: _Item(
                        index: i,
                        isActive: selectedPage == i,
                        onTap: (index) {
                          setState(() => selectedPage = index);
                          widget.onChanged.call(selectedPage);
                        },
                      ),
                    ),
                ],
              ),
        const SizedBox(width: 10),
        IconButton(
          onPressed: selectedPage == widget.pageCount
              ? null
              : () {
                  setState(() {
                    selectedPage != widget.pageCount
                        ? selectedPage++
                        : selectedPage = widget.pageCount;

                    widget.onChanged.call(selectedPage);
                  });
                },
          icon: Icon(
            Icons.chevron_right_rounded,
            color: selectedPage == widget.pageCount ? Colors.grey : Colors.blue,
            size: 24,
          ),
        ),

        if (!((selectedPage + 5) > widget.pageCount))
          IconButton(
            onPressed: () {
              setState(() {
                if (selectedPage + 5 > widget.pageCount) {
                  selectedPage = widget.pageCount;
                  widget.onChanged.call(selectedPage);
                }
                selectedPage = selectedPage + 5;
                widget.onChanged.call(selectedPage);
              });
            } ,
            icon: Icon(
              Icons.keyboard_double_arrow_right_rounded,
              color: selectedPage + 5 > widget.pageCount
                  ? Colors.grey
                  : Colors.blue,
              size: 24,
            ),
          ),
      ],
    );
  }

// _pageSelector() {
//   return Row(
//     children: <Widget>[
//       IconButton(
//         onPressed: selectedPage >= 5
//             ? () {
//                 setState(() {
//                   if (selectedPage - 5 <= 1) {
//                     debugPrint("first $selectedPage");
//                     selectedPage = 1;
//                     widget.onChanged.call(selectedPage);
//                   } else {
//                     selectedPage = selectedPage - 5;
//                     widget.onChanged.call(selectedPage);
//                   }
//                 });
//               }
//             : null,
//         icon: Icon(
//           Icons.keyboard_double_arrow_left_rounded,
//           color: selectedPage >= 5 ? Colors.blue : Colors.grey,
//           size: 24,
//         ),
//       ),
//       IconButton(
//         onPressed: selectedPage != 1
//             ? () {
//                 setState(() {
//                   selectedPage--;
//
//                   widget.onChanged.call(selectedPage);
//                 });
//               }
//             : null,
//         icon: Icon(
//           Icons.chevron_left_rounded,
//           color: selectedPage != 1 ? Colors.blue : Colors.grey,
//           size: 24,
//         ),
//       ),
//       const SizedBox(width: 10),
//       for (int i = _startPage; i <= _endPage; i++)
//         AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           child: _Item(
//             index: i,
//             isActive: selectedPage == i,
//             onTap: (index) {
//               setState(() => selectedPage = index);
//               widget.onChanged.call(selectedPage);
//             },
//           ),
//         ),
//       const SizedBox(width: 10),
//       IconButton(
//         onPressed: selectedPage == widget.pageCount
//             ? null
//             : () {
//                 setState(() {
//                   selectedPage != widget.pageCount
//                       ? selectedPage++
//                       : selectedPage = widget.pageCount;
//
//                   widget.onChanged.call(selectedPage);
//                 });
//               },
//         icon: Icon(
//           Icons.chevron_right_rounded,
//           color: selectedPage == widget.pageCount ? Colors.grey : Colors.blue,
//           size: 24,
//         ),
//       ),
//       IconButton(
//         onPressed: selectedPage + 5 > widget.pageCount
//             ? null
//             : () {
//                 setState(() {
//                   if (selectedPage + 5 > widget.pageCount) {
//                     selectedPage = widget.pageCount;
//                     widget.onChanged.call(selectedPage);
//                   }
//                   selectedPage = selectedPage + 5;
//                   widget.onChanged.call(selectedPage);
//                 });
//               },
//         icon: Icon(
//           Icons.keyboard_double_arrow_right_rounded,
//           color:
//               selectedPage + 5 > widget.pageCount ? Colors.grey : Colors.blue,
//           size: 24,
//         ),
//       ),
//     ],
//   );
// }
}

/// ================ v1 ================ //

/*class PageSelectorWidget extends StatefulWidget {
  final int pageCount;
  final Function(int) onChanged;

  const PageSelectorWidget({
    Key? key,
    required this.pageCount,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<PageSelectorWidget> createState() => _PageSelectorWidgetState();
}

class _PageSelectorWidgetState extends State<PageSelectorWidget> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          _button(
            icon: Icons.chevron_left_outlined,
            onTap: () {
              setState(() {
                selectedIndex == 1 ? 1 : selectedIndex--;
                widget.onChanged.call(selectedIndex);
              });
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  ...List.generate(widget.pageCount, (i) {
                    final index = i + 1;
                    return Padding(
                      padding: const EdgeInsets.only(right: 3),
                      child: _Item(
                        index: index,
                        isActive: selectedIndex == index,
                        onTap: (value) {
                          log('value $value');
                          setState(() => selectedIndex = value);
                          widget.onChanged.call(selectedIndex);
                        },
                      ),
                    );
                  }),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
          _button(
            icon: Icons.chevron_right_outlined,
            onTap: () {
              setState(() {
                selectedIndex != widget.pageCount
                    ? selectedIndex++
                    : selectedIndex = widget.pageCount;
                log("inc $selectedIndex");

                widget.onChanged.call(selectedIndex);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _button({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () => onTap.call(),
      child: Ink(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(6),
          color: Colors.blue,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Icon(
              icon,
              color: Colors.white,
            ),
            // child: Text(
            //   title,
            //   style: const TextStyle(
            //     color: Colors.black,
            //     fontWeight: FontWeight.w700,
            //     fontSize: 16,
            //     fontFamily: "Nunito",
            //   ),
            // ),
          ),
        ),
      ),
    );
  }
}*/

class _Item extends StatelessWidget {
  final int index;
  final bool isActive;

  final Function(int) onTap;

  const _Item({
    Key? key,
    required this.index,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap.call(index),
      child: Ink(
        decoration: const BoxDecoration(
            // border: Border.all(color: Colors.blue),
            // color: isActive ? Colors.blue : null,
            // borderRadius: BorderRadius.circular(6),
            ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              index.toString(),
              style: GoogleFonts.nunito(
                color: isActive ? Colors.blue : Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
