import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'src/myApp.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}
