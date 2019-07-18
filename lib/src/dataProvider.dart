import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'timetable.dart';
import 'database_helper.dart';
import 'cupertinoSwitchListTile.dart';
import 'attendance.dart';
import 'about.dart';

class DataProvider with ChangeNotifier{

   DateTime _selectedDay = DateTime.now();
  
  DateTime get getSelectedDay => _selectedDay;

  set setSelectedDay(DateTime selectedDay) {

    _selectedDay = selectedDay;
    notifyListeners();
  }

}