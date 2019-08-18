import 'package:flutter/material.dart';


class DataProvider with ChangeNotifier{

   DateTime _selectedDay = DateTime.now();
  
  DateTime get getSelectedDay => _selectedDay;

  set setSelectedDay(DateTime selectedDay) {

    _selectedDay = selectedDay;
    notifyListeners();
  }

}