import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/entities/field_entity.dart';
import 'package:eleven_crm/features/main/presensation/cubit/order/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/time_table_helper.dart';
import '../../../../management/domain/entity/not_working_hours_entity.dart';
import '../../../domain/entity/order_entity.dart';

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
    return DateTime.now().hour < Constants.startWork
        ? const SizedBox()
        : Container(
            width: MediaQuery.of(context).size.width,
            height: h,
            color: Colors.blue.withOpacity(0.01),
            child: const SizedBox.shrink(),
          );
  }
}
