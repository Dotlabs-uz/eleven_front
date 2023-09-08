// import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class FieldFormatters {
  static MaskTextInputFormatter phoneMaskFormatter = MaskTextInputFormatter(

    mask: '+994#########',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );
  static MaskTextInputFormatter creditCardFormatter = MaskTextInputFormatter(
    mask: '#### #### #### ####',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );
/*  static CurrencyTextInputFormatter numberFormatter =
      CurrencyTextInputFormatter(
    decimalDigits: 0,
    locale: 'ru',
    symbol: '',
  );*/


  static FilteringTextInputFormatter numberWithDot =
      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}'));
}
