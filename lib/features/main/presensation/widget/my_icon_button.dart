import 'package:flutter/material.dart';

import '../../../../core/utils/responsive.dart';

abstract class IconButtonImpl extends StatelessWidget {
  final Function() onPressed;
  final Icon? icon;
  final bool enabled;

  const IconButtonImpl({
    Key? key,
    required this.onPressed,
    this.icon,
    this.enabled = true,
  }) : super(key: key);
}

class MyIconButton extends IconButtonImpl {
  const MyIconButton({
    Key? key,
    required Function() onPressed,
    bool enabled = true,
    Icon? icon,
  }) : super(
          key: key,
          onPressed: onPressed,
          enabled: enabled,
          icon: icon,
        );

  @override
  Widget build(BuildContext context) {
    return IconButton(
      enableFeedback: true,
      onPressed: enabled ? onPressed : null,
      color: enabled ? Colors.orange : Colors.grey,
      iconSize: Responsive.isDesktop(context) ? 26 : null,
      icon: icon!,
    );
  }
}

class MultiSelectIcon extends IconButtonImpl {
  const MultiSelectIcon(
      {Key? key, required Function() onPressed, bool enabled = true})
      : super(key: key, onPressed: onPressed, enabled: enabled);

  @override
  Widget build(BuildContext context) {
    return _MultiSelectIconBody(onPressed: onPressed, enabled: enabled);
  }
}

class _MultiSelectIconBody extends StatefulWidget {
  const _MultiSelectIconBody({
    required this.onPressed,
    required this.enabled,
  });

  final Function() onPressed;
  final bool enabled;

  @override
  State<_MultiSelectIconBody> createState() => _MultiSelectIconState();
}

class _MultiSelectIconState extends State<_MultiSelectIconBody> {
  bool isCheck = true;

  @override
  Widget build(BuildContext context) {
    return MyIconButton(
      onPressed: () {
        widget.onPressed.call();
        setState(() => isCheck = !isCheck);
      },
      icon: !isCheck
          ? const Icon(Icons.check_box_outline_blank)
          : const Icon(Icons.check_box),
    );
  }
}
