import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/drop_down_decoration.dart';
import '../constants/type_constants.dart';
import '../entities/field_entity.dart';

class RoleForManagersFieldWidget extends StatelessWidget {
  const RoleForManagersFieldWidget({
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
    return CustomerOrderFieldContent(
      onChanged: onChanged,
      padding: padding,
      enabled: enabled,
      fieldEntity: fieldEntity,
    );
  }
}

class CustomerOrderFieldContent extends StatefulWidget {
  final Function(String)? onChanged;
  final bool enabled;
  final EdgeInsets? padding;
  final FieldEntity? fieldEntity;

  const CustomerOrderFieldContent({
    Key? key,
    required this.fieldEntity,
    required this.onChanged,
    required this.enabled,
    this.padding,
  }) : super(key: key);

  @override
  State<CustomerOrderFieldContent> createState() =>
      _CustomerOrderFieldContentState();
}

class _CustomerOrderFieldContentState extends State<CustomerOrderFieldContent> {
  final TextEditingController controllerSearch = TextEditingController();
  List<String> itemsList = [];
  @override
  void initState() {
    itemsList = TypeChooses.roleForManagers;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int ind = 0;
    if (widget.fieldEntity != null) {
      ind =  widget.fieldEntity!.val == "reception" ? 0 : 1;
      widget.fieldEntity!.val = TypeChooses.role[ind];
    }

    return Padding(
      padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
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
          dropdownDecoratorProps: DropDownDecoration.dropDownColor(
            'role'.tr(),
            "role".tr().toUpperCase(),
            widget.fieldEntity?.isRequired ?? false,
          ),              onChanged: (val) {
            if (val != null) {
              widget.fieldEntity?.val = val;

              widget.onChanged?.call(val);
            }
          },
        ),
      ),
    );
  }
}
