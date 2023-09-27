import 'package:flutter/material.dart';

import '../../../../core/utils/selections.dart';

class EmployeeScheduleStatus {
  final String title;
  final String description;
  final Color color;

  const EmployeeScheduleStatus(
      {required this.title, required this.color, required this.description});
}

class EmployeeScheduleStatusWidget extends StatefulWidget {
  const EmployeeScheduleStatusWidget({Key? key}) : super(key: key);

  @override
  State<EmployeeScheduleStatusWidget> createState() =>
      _EmployeeScheduleStatusWidgetState();
}

class _EmployeeScheduleStatusWidgetState
    extends State<EmployeeScheduleStatusWidget> {


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...Selections.listStatus.map((e) => _buildItem(e)),
        // _buildItem(listStatus[0]),
      ],
    );
  }

  _buildItem(EmployeeScheduleStatus entity) {
    return Row(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: entity.color,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              entity.title,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: "Nunito",
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          entity.description,
          style:  TextStyle(
            color: Colors.grey.shade700,
            fontFamily: "Nunito",
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),

        const SizedBox(width: 15),


      ],
    );
  }
}
