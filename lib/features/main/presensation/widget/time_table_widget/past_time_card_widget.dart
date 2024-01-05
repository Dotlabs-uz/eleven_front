import 'package:flutter/material.dart';

import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/time_table_helper.dart';

class PastTimeCardWidget extends StatefulWidget {
  final DateTime? dateTime;
  const PastTimeCardWidget({
    Key? key,
    this.dateTime,
  }) : super(key: key);

  @override
  State<PastTimeCardWidget> createState() => _PastTimeCardWidgetState();
}

class _PastTimeCardWidgetState extends State<PastTimeCardWidget> {
  DateTime startTime = DateTime.now()
      .copyWith(hour: Constants.startWork.toInt(), minute: 0)
      .toLocal();
  static DateTime endTime = DateTime.now().toLocal();

  double h = 0;

  @override
  void didUpdateWidget(covariant PastTimeCardWidget oldWidget) {
    if (endTime != widget.dateTime) {
      initialize();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() {
    h = TimeTableHelper.getPastTimeHeight(
      startTime,
      endTime,
      widget.dateTime,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: h,
      color: const Color(0xffDBDBDB).withOpacity(0.05),
      child: const SizedBox.shrink(),
    );
  }
}
