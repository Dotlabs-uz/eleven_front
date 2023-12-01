import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/application/application.dart';
import 'package:eleven_crm/get_it/locator.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sweet_cookie/sweet_cookie.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();


  final box = await Hive.openBox("orderFilter");

  box.put("filter", DateTime.now().toIso8601String());



  setup();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('ru', 'RU'),
        Locale('uz', 'UZ'),
      ],
      fallbackLocale: const Locale('ru', 'RU'),
      path: 'assets/translations',
      child: const Application(),
    ),
  );
}
