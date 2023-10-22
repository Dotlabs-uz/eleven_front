import 'package:flutter/material.dart';

import '../../../../../core/utils/time_table_helper.dart';
import '../../../../management/domain/entity/not_working_hours_entity.dart';

class NotWorkingHoursCard extends StatelessWidget {
  final NotWorkingHoursEntity notWorkingHoursEntity;
  const NotWorkingHoursCard({
    Key? key,
    required this.notWorkingHoursEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: TimeTableHelper.getCardHeight(
        notWorkingHoursEntity.dateFrom,
        notWorkingHoursEntity.dateTo,
      ),
      color: Colors.brown.withOpacity(0.5),
      child: const SizedBox.expand(),
    );
  }
}
