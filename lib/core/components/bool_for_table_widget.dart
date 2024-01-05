import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class BoolForTableWidget extends StatelessWidget {
  final PlutoColumnRendererContext data;

  const BoolForTableWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      data.cell.value ? Icons.check_rounded : Icons.close_rounded,
      size: 16,
      color: data.cell.value ? Colors.green : Colors.red,
    );
  }
}
