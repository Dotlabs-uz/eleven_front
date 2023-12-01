
import 'package:flutter/material.dart';

class CrossInEmployeeScheduleProvider extends ChangeNotifier {
  int row = -1;
  DateTime? dateTime ;
  
  enableCross({required int hoveredRow, required DateTime hoveredDateTime}) {
    
    row = hoveredRow;
    dateTime = hoveredDateTime;

    notifyListeners();

    
  }


  clear( ) {

    row = -1;
    dateTime = null;
    notifyListeners();

  }


}