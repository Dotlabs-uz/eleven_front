import 'package:flutter/material.dart';

import '../../features/management/domain/entity/barber_entity.dart';

class NotSelectedBarbersListWidget extends StatefulWidget {
  final List<BarberEntity> listBarbers;
  final Function(String barberId) onTap;
  const NotSelectedBarbersListWidget(
      {Key? key, required this.listBarbers, required this.onTap})
      : super(key: key);

  @override
  State<NotSelectedBarbersListWidget> createState() =>
      _NotSelectedBarbersListWidgetState();
}

class _NotSelectedBarbersListWidgetState
    extends State<NotSelectedBarbersListWidget> {
  static final List<BarberEntity> listBarbers = [];

  @override
  void didUpdateWidget(covariant NotSelectedBarbersListWidget oldWidget) {
    final newListLen = widget.listBarbers.length;
    if (newListLen != listBarbers.length) {
      initialize();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() {
    listBarbers.clear();

    final List<BarberEntity> employeeListData = widget.listBarbers
        .where((element) => element.inTimeTable == false)
        .toList();

    listBarbers.addAll(employeeListData);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      margin: EdgeInsets.zero,
      child: Container(
        width: 120,
        decoration: const BoxDecoration(
          color: Color(0xffe0e0e0),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          ),
        ),
        child: ListView(
          // mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // const SizedBox(height: 20),
            ...List.generate(listBarbers.length, (index) {
              final el = listBarbers[index];
              return GestureDetector(
                onTap: () {
                  listBarbers.remove(el);
                  widget.onTap.call(el.id);
                },
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
