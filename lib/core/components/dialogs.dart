import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:golden_price/core/components/toast.dart';

dynamic currentTime;

Future<bool> exitApp(BuildContext ctx) async {
  DateTime now = DateTime.now();

  if (currentTime == null ||
      now.difference(currentTime!) > const Duration(seconds: 2)) {
    currentTime = now;
    toast(ctx, 'klik lagi untuk keluar aplikasi');
    return Future.value(false);
  }
  SystemNavigator.pop();
  exit(0);
}
