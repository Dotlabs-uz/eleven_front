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
  const PastTimeCardWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<PastTimeCardWidget> createState() => _PastTimeCardWidgetState();
}

class _PastTimeCardWidgetState extends State<PastTimeCardWidget> {
  final startTime = DateTime.now().copyWith(hour: Constants.startWork.toInt(), minute: 0).toLocal();
  DateTime endTime =  DateTime.now();

  @override
  void initState() {

    if(endTime.hour >= 22) {
      endTime =  DateTime.now().copyWith(hour: 22,minute: 0).toLocal();
    }
    super.initState();
  }







  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: TimeTableHelper.getCardHeight(
        startTime,
        endTime,
      ),
      color: Colors.blue.withOpacity(0.01),

      child: const SizedBox.shrink(),
    );
  }
}
