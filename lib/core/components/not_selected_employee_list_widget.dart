import 'package:flutter/material.dart';

import '../../features/management/domain/entity/employee_entity.dart';

class NotSelectedEmployeeListWidget extends StatefulWidget {
  final List<EmployeeEntity> listEmployee;
  final Function(String emplyoeeId) onTap;
  const NotSelectedEmployeeListWidget({Key? key, required this.listEmployee, required this.onTap})
      : super(key: key);

  @override
  State<NotSelectedEmployeeListWidget> createState() =>
      _NotSelectedEmployeeListWidgetState();
}

class _NotSelectedEmployeeListWidgetState
    extends State<NotSelectedEmployeeListWidget> {
  final List<EmployeeEntity> listEmployee = [];

  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() {
    listEmployee.clear();

    final List<EmployeeEntity> employeeListData = widget.listEmployee
        .where((element) => element.inTimeTable == false)
        .toList();

    listEmployee.addAll(employeeListData);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      margin: EdgeInsets.zero,
      child: Container(
        width: 120,
        color: const Color(0xffe0e0e0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // const SizedBox(height: 20),
            ...List.generate(listEmployee.length, (index) {
              final el = listEmployee[index];
              return GestureDetector(
                onTap: () => widget.onTap.call(el.id),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${el.firstName} ${el.lastName}",
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
