import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
