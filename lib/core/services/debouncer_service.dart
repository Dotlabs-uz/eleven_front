import 'dart:async';

import 'package:flutter/foundation.dart';

class DebouncerService {
  final int milliseconds;
  Timer? _timer;

  DebouncerService({required this.milliseconds});

   call(VoidCallback action)   {
    _timer?.cancel();
    _timer =   Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}