import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
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
  State<_ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<_ContentWidget> {
  final TextEditingController controllerSearch = TextEditingController();
  Map<String, String> mapValues = {};
  String selectedValue = "cash";

  @override
  void initState() {
    mapValues = TypeChooses.paymentType;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fieldEntity != null) {
      final OrderPayment paymentType = widget.fieldEntity!.val;
      selectedValue = paymentType.name;
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
            width: MediaQuery.of(context).size.width,
            child: CupertinoSegmentedControl<String>(
              selectedColor: const Color(0xff071E32),
              groupValue: selectedValue,
              borderColor: const Color(0xff071E32),
              padding: EdgeInsets.zero,
              onValueChanged: (String value) {
                setState(() {
                  selectedValue = value;
                  widget.fieldEntity?.val = _getPaymentTypeByString(value);

                  widget.onChanged?.call(value);
                });
              },
              children: <String, Widget>{
                "cash": Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.money_rounded),
                    const SizedBox(width: 3),
                    Text('cash'.tr()),
                  ],
                ),
                "card": Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.credit_card),
                    const SizedBox(width: 3),
                    Text('card'.tr()),
                  ],
                ),
              },
            ),
          ),
        ],
      ),
    );
  }

  _getPaymentTypeByString(String value) {
    switch (value) {
      case "cash":
        return OrderPayment.cash;
      case "card":
        return OrderPayment.card;
    }
  }
}
