import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/main/domain/entity/order_entity.dart';
import '../constants/type_constants.dart';
import '../entities/field_entity.dart';

class PaymentTypeFieldWidget extends StatelessWidget {
  const PaymentTypeFieldWidget({
    Key? key,
    this.fieldEntity,
    this.onChanged,
    this.enabled = true,
    this.padding,
  }) : super(key: key);
  final bool enabled;
  final EdgeInsets? padding;
  final FieldEntity? fieldEntity;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return _ContentWidget(
      onChanged: onChanged,
      padding: padding,
      enabled: enabled,
      fieldEntity: fieldEntity,
    );
  }
}

class _ContentWidget extends StatefulWidget {
  final Function(String)? onChanged;
  final bool enabled;
  final EdgeInsets? padding;
  final FieldEntity? fieldEntity;

  const _ContentWidget({
    Key? key,
    required this.fieldEntity,
    required this.onChanged,
    required this.enabled,
    this.padding,
  }) : super(key: key);

  @override
  State<_ContentWidget> createState() =>
      _ContentWidgetState();
}

class _ContentWidgetState extends State<_ContentWidget> {
  final TextEditingController controllerSearch = TextEditingController();
  List<String> itemsList = [];
  @override
  void initState() {
    itemsList = TypeChooses.paymentType;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int ind = 0;
    if (widget.fieldEntity != null) {
      final OrderPayment paymentType = widget.fieldEntity!.val;
      ind = paymentType.name == "cash" ? 0 : 1;
    }

    return Padding(
      padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.fieldEntity?.label.tr().toUpperCase() ?? "",
            // style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.start,
            style: GoogleFonts.nunito(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          SizedBox(
            height: 40,
            child: DropdownSearch<String>(
              items: itemsList,
              enabled: widget.enabled,
              itemAsString: (item) => item.tr(),
              selectedItem: itemsList[ind],
              popupProps: PopupPropsMultiSelection.menu(
                showSelectedItems: true,
                itemBuilder: (context, item, isSelected) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 5,
                      left: 10,
                      top: 5,
                    ),
                    child: Text(
                      item.tr(),
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  );
                },
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  controller: controllerSearch,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => controllerSearch.clear(),
                    ),
                  ),
                ),
              ),
              compareFn: (item, selectedItem) => (item == selectedItem),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.blue,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      width: 2,
                    ),
                  ),
                  hintText: "status".tr().toUpperCase(),
                ),
              ),
              onChanged: (val) {
                if (val != null) {
                  widget.fieldEntity?.val = val;

                  widget.onChanged?.call(val);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}