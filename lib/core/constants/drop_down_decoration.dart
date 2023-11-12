import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropDownDecoration {
  static dropDownColor(String hint, String label, bool isRequired) {
    return DropDownDecoratorProps(
      dropdownSearchDecoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        hintStyle: const TextStyle(
          color: Colors.black54,
          fontSize: 14,

        ),
        labelStyle: const TextStyle(
          color: Colors.black54,
          fontSize: 14,
        ),
        enabledBorder: isRequired
            ? const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xff071E32),

                ),

              )
            : null,
        focusedBorder: const OutlineInputBorder(

          borderSide: BorderSide(
            color: Color(0xff071E32),
          ),


        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            width: 2,
          ),
        ),
        labelText: label,
        hintText: hint,
      ),
    );
  }
}
