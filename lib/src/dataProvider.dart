import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'timetable.dart';
import 'database_helper.dart';
import 'cupertinoSwitchListTile.dart';
import 'attendance.dart';
import 'about.dart';

final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],
};

class DataProvider with ChangeNotifier{

   DateTime _selectedDay = DateTime.now();
   DateTime _baseDay = DateTime(2019,07,01);
   DateTime _lastDay = DateTime(2019,10,16);
  Map<DateTime, List> _events = {};
  Map<DateTime, List> _visibleEvents;
  Map<DateTime, List> _visibleHolidays;
  List<String> _selectedEvents;
  String month;
  
 // DataProvider(this._selectedDay, this._baseDay, this._lastDay, this._events, this._visibleEvents, this._visibleHolidays,this._selectedEvents);

  DatabaseHelper _helper = DatabaseHelper();

  DateTime get getSelectedDay => _selectedDay;

  set setSelectedDay(DateTime selectedDay) {

    _selectedDay = selectedDay;
    notifyListeners();
  }

  String selectedMonth(DateTime date) {

    switch (date.month) {
        case 1:
          month = "January";
          break;
        case 2:
          month = "February";
          break;
        case 1:
          month = "March";
          break;
        case 1:
          month = "April";
          break;
        case 1:
          month = "May";
          break;
        case 1:
          month = "June";
          break;
        case 1:
          month = "July";
          break;
        case 1:
          month = "August";
          break;
        case 1:
          month = "September";
          break;
        case 1:
          month = "Ocotober";
          break;
        case 1:
          month = "November";
          break;
        case 1:
          month = "December";
          break;   
                             
      }
      //notifyListeners();
      return month;

  }
   
    void setDays() {
        for(DateTime i=_baseDay; (i.isBefore(_lastDay)); i=i.add(Duration(days: 1)))
      {
          switch (i.weekday) {
            case 1: 
            {
              _events[i] = mon;
              break;
            }
            case 2 : 
            {
              _events[i] = tues;
              break;
            }
            case 3 :
            {
              _events[i] = wed ;
              break;
            }
            case 4: 
            {
            _events[i]= thur;
              break;
            }
            case 5 : 
            {
              _events[i] = fri;
              break;
            }
            default:
            {
            _events[i] = nan;
              break;
            }
        }
        notifyListeners();
      }
    }

    List<String> get getSelectedEvents{
      _selectedEvents = _events[_selectedDay] ?? [];
      notifyListeners();
      return _selectedEvents;
    }

     Map<DateTime, List> get visibleEvents{
       _visibleEvents = _events;
       notifyListeners();
       return _visibleEvents;
    }

    Map<DateTime, List> get visibleHolidays{
       _visibleHolidays = _holidays;
       notifyListeners();
       return _visibleHolidays;
    }

    DatabaseHelper get helper => _helper;

     void onDaySelected(DateTime day, List<dynamic> events) {
      
     _selectedDay = day;
      // _selectedDay = _selectedDay;
      _selectedEvents = events;
      notifyListeners();
  }

   void onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
   
      _visibleEvents = Map.fromEntries(
        _events.entries.where(
          (entry) =>
              entry.key.isAfter(first.subtract(const Duration(days: 1))) &&
              entry.key.isBefore(last.add(const Duration(days: 1))),
        ),
      );

      _visibleHolidays = Map.fromEntries(
        _holidays.entries.where(
          (entry) =>
              entry.key.isAfter(first.subtract(const Duration(days: 1))) &&
              entry.key.isBefore(last.add(const Duration(days: 1))),
        ),
      );
      notifyListeners();
  }
  




}