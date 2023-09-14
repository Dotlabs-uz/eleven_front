import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../utils/date_time_helper.dart';

class DateTimeForTableWidget extends StatelessWidget {
  final PlutoColumnRendererContext data;

  const DateTimeForTableWidget({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      DateTimeHelper.formatForTable(DateTime.parse(data.cell.value)),
      style: GoogleFonts.nunito(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
