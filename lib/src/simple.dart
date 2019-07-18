import 'package:ch1/src/dataProvider.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'timetable.dart';
import 'database_helper.dart';
import 'cupertinoSwitchListTile.dart';
import 'package:provider/provider.dart';
// import 'attendance.dart';
// import 'about.dart';
// import 'percentCal.dart';
// import 'package:query/query.dart';
//import 'package:body_parser/body_parser.dart';
//import 'package:sqflite/sqflite.dart';

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],
};


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  
 //  DateTime _selectedDay;
  DateTime _baseDay;
  DateTime _lastDay;
  Map<DateTime, List> _events;
  Map<DateTime, List> _visibleEvents;
  Map<DateTime, List> _visibleHolidays;
  List<String> _selectedEvents;
  AnimationController _controller;
  DatabaseHelper helper = DatabaseHelper();
  //DataProvider data = DataProvider();
  


  @override
  void initState() {
    super.initState();
    // data.selectedDay = DateTime.now();
    //_selectedDay = DateTime.now();
    // _selectedDay = _selectedDay;
    DataProvider data = DataProvider();
    _baseDay = DateTime(2019,07,01);
    _lastDay = DateTime(2019,10,16);
    _events = {};
    helper.initializeDatabase();
    

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
    }
    
    _selectedEvents = _events[data.getSelectedDay] ?? [];
    _visibleEvents = _events;
    _visibleHolidays = _holidays;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _controller.forward();
  }

  // void didDependencies() {
  //   super.didChangeDependencies();
  //   final dp = Provider.of<DataProvider>(context);

  //   dp.setSelectedDay = DateTime.now();

  //  // _selectedEvents = _events[data.getSelectedDay] ?? [];

  // }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      final dp = Provider.of<DataProvider>(context);
      dp.setSelectedDay = day;
      // _selectedDay = _selectedDay;
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    setState(() {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text(widget.title),
//        backgroundColor: Color(0x121212),
//      ),
      body: Container(
        child: Column(
         mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: 45.0,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20.0, 0, 15.0),
             alignment: Alignment(-0.8, 0),
              child: Text(
                "Table Calendar",
                style: TextStyle(
                  fontFamily: 'Product_Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 30.0,
                ),
              
              ),
            ),
            // Switch out 2 lines below to play with TableCalendar's settings
            //-----------------------
            Card(
              child: _buildTableCalendar(),
              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              elevation: 2
            ),
            // _buildTableCalendarWithBuilders(),
            const SizedBox(height: 6.0),
            Expanded(
             flex: 3,
              child: _buildEventList()),
              //const SizedBox(height: 8.0),  
          ],
        ),
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      locale: 'en_IN',
      events: _visibleEvents,
      holidays: _visibleHolidays,
      initialCalendarFormat: CalendarFormat.week,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
        CalendarFormat.twoWeeks: '2 weeks',
        CalendarFormat.week: 'Week',
      },
      calendarStyle: CalendarStyle(

        selectedColor: Color(0xF11B1B1B),
        todayColor: Colors.black38,
        markersColor: Colors.purple[700],
        markersMaxAmount: 0,
        weekendStyle: TextStyle(color: Colors.deepOrange[600])
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Color(0xEE141414)),
        weekendStyle: TextStyle(color: Colors.deepOrange[600])
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Color(0xF11B1B1B),
          borderRadius: BorderRadius.circular(16.0),
        ),
        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black87),
        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black87)
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

//  bool _isChecked;
  
  Widget _buildEventList() {
      final dp = Provider.of<DataProvider>(context);
    if (!(dp.getSelectedDay.weekday == 6 || dp.getSelectedDay.weekday == 7)) {
      return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                 child: FutureBuilder(
                   future: helper.fetchItem(dp.getSelectedDay, event),
                   builder: (context, AsyncSnapshot<bool> snapshot) {
                     if(!snapshot.hasData){
                          return Container(
                            child: Center(
                              child: Text("Loading..."),
                            ),
                          );
                          } else {
                     return CupertinoSwitchListTile(
                       activeColor: Color(0xF11B1B1B),
                       title: Text(event),
                       value: snapshot.data,
                       onChanged: (bool value) {
                         setState(() {
                           helper.updateItem(dp.getSelectedDay, event, value);
                         });
                       },
                     );
                   }
                   }
                 )
              ))
          .toList(),
    );
    } else {
      return Container(
        child:Center(
        child: Text("No Lectures Today"),
        ),
      );
    }
  }

  
}






