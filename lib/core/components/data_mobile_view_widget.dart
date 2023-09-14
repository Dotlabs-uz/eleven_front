// ignore_for_file: unrelated_type_equality_checks

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../entities/field_entity.dart';
import '../utils/date_time_helper.dart';
import '../utils/number_helper.dart';
import '../utils/string_helper.dart';

class DataMobileViewWidget extends StatefulWidget {
  final List<dynamic> data;

  final Function(dynamic) editData;

  final Function(int) deleteData;

  const DataMobileViewWidget({
    Key? key,
    required this.data,
    required this.editData,
    required this.deleteData,
  }) : super(key: key);

  @override
  State<DataMobileViewWidget> createState() => _DataMobileViewWidgetState();
}

class _DataMobileViewWidgetState extends State<DataMobileViewWidget> {

  @override
  void initState() {
    super.initState();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        // shrinkWrap: true,
        children: widget.data
            .map(
              (e) => _MobileViewCard(
                fields: e.getFieldsAndValues(),
                editData: () => widget.editData.call(e),
                deleteData: (val) => widget.deleteData.call(val),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _MobileViewCard extends StatefulWidget {
  final List<MobileFieldEntity> fields;

  final Function() editData;

  final Function(int) deleteData;

  const _MobileViewCard(
      {Key? key,
      required this.fields,
      required this.editData,
      required this.deleteData})
      : super(key: key);

  @override
  State<_MobileViewCard> createState() => _MobileViewCardState();
}

class _MobileViewCardState extends State<_MobileViewCard> {
  bool enableEdit = true;
  List<Widget> ctrlWidgetsFirst = [];
  List<Widget> ctrlWidgets = [];
  int id = 0;

  @override
  void initState() {
    _setParams(widget.fields);
    super.initState();
  }

  void _setParams(List<MobileFieldEntity> fields) {
    ctrlWidgets.clear();
    ctrlWidgetsFirst.clear();

    for (var i = 0; i < fields.length; i++) {
      var field = fields[i];
      enableEdit = field.editable;

      if (field.title == "id") {
        id = field.val;
      } else {
        if (i < 5) {
          _sorting(field, ctrlWidgetsFirst);
        } else {
          _sorting(field, ctrlWidgets);
        }
      }
    }
  }

  _sorting(MobileFieldEntity<dynamic> field, List widgets) {
    if (field.type == Types.bool) {
      widgets.add(
        _fieldWithWidget(
          field.title,
          Icon(
            field.val ? Icons.check_rounded : Icons.close_rounded,
            color: field.val ? Colors.green : Colors.red,
          ),
        ),
      );
    } else if (field.type == Types.double) {
      widgets.add(
        _fieldWithText(field.title, NumberHelper.formatNumber(field.val)),
      );
    }  else if (field.type == Types.dateTime || field.type == Types.date) {
      widgets.add(_fieldWithText(
          field.title,
          field.val != null && field.val.toString().isNotEmpty
              ? DateTimeHelper.formatForTable(
                  DateTime.parse(
                    field.val.toString(),
                  ),
                )
              : ''));
    } else if (field.type == Types.month) {
      widgets.add(_fieldWithText(
          field.title, StringHelper.monthName(index: field.val)));
    }  else {
      widgets.add(_fieldWithText(field.title, field.val));
    }

    return widgets;
  }

  _fieldWithText(String title, dynamic value) {
    return Wrap(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // mainAxisSize: MainAxisSize.min,
      spacing: 5,

      children: [
        Text(
          "${title.tr()}: ",
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          value.toString().tr(),
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  _fieldWithWidget(String title, Widget widget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${title.tr()}: ",
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        widget
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 10,
      ),
      child: ExpansionTile(
        backgroundColor: Colors.white,
        iconColor: Colors.orange,
        tilePadding: const EdgeInsets.only(top: 10, left: 10),
        childrenPadding: const EdgeInsets.only(left: 0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "${"id".tr()} $id",
                  style: GoogleFonts.nunito(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => widget.editData.call(),
                  child: const Icon(
                    Icons.edit,
                    size: 22,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => widget.deleteData.call(id),
                  child: const Icon(
                    Icons.delete_forever,
                    size: 22,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...ctrlWidgetsFirst.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: e,
              ),
            ),
          ],
        ),
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...ctrlWidgets.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10, left: 10),
                    child: e,
                  ),
                ),
                // Wrap(
                //   alignment: WrapAlignment.start,
                //   spacing: 15,
                //   runSpacing: 12,
                //   children: ctrlWidgets,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
