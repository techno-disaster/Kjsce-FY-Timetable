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
  DateTime(2019, 8, 12): ['Bakrid'],
  DateTime(2019, 8, 15): ['Independance Day, Rakshabandhan'],
  DateTime(2019, 9, 14): ['Muhharam'],
  DateTime(2019, 10, 2): ['Gandhi Jayanti'],
  DateTime(2019, 10, 8): ['Dusshera'],
  DateTime(2019, 10, 27): ['Diwali'],
};


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin{
  
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
  bool get wantKeepAlive => true;

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
    

    for(DateTime i=_baseDay; (i.isBefore(_lastDay) || i.isAtSameMomentAs(_lastDay)); i=i.add(Duration(days: 1)))
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
    super.build(context);
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
              height: 35.0,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 30.0, 0, 15.0),
             alignment: Alignment(-0.8, 0),
              child: Text(
                "Table Calendar",
                style: TextStyle(
                  fontFamily: 'Product_Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 35.0,
                  color: Colors.white70,
                ),
              
              ),
            ),
            // Switch out 2 lines below to play with TableCalendar's settings
            //-----------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
              child: Card(
                child: _buildTableCalendar(),
                shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                elevation: 2,
               color: Theme.of(context).accentColor,
              ),
            ),
            // _buildTableCalendarWithBuilders(),
            //const SizedBox(height: 0.0),
            Expanded(
             //flex: 1,
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

        selectedColor: Theme.of(context).primaryColor,
        todayColor: Colors.white12,
        markersColor: Colors.purple[700],
        markersMaxAmount: 0,
        weekendStyle: TextStyle(color: Colors.white70),
        weekdayStyle: TextStyle(color: Theme.of(context).primaryColor)
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Theme.of(context).primaryColor),
        weekendStyle: TextStyle(color: Colors.white70)
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        titleTextStyle: TextStyle().copyWith(color: Colors.white70, fontSize: 18.0),
        rightChevronIcon: Icon(Icons.chevron_right, color: Theme.of(context).primaryColor),
        leftChevronIcon: Icon(Icons.chevron_left, color: Theme.of(context).primaryColor)
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

//  bool _isChecked;
  
  Widget _buildEventList() {
     
     DateTime h1 = DateTime(2019, 8, 12);
    DateTime h2 = DateTime(2019, 8, 15);
    DateTime h3 = DateTime(2019, 9, 14);
    DateTime h4 = DateTime(2019, 10, 2);
    DateTime h5 = DateTime(2019, 10, 8);
    DateTime h6 = DateTime(2019, 10, 27);




      final dp = Provider.of<DataProvider>(context);
      if(dp.getSelectedDay.isBefore(_baseDay) || dp.getSelectedDay.isAfter(_lastDay)) {
       return Container(
        child:Center(
        child: Text("I am not designed for this day yet, xD.", style: TextStyle(fontSize: 17.0),),
        ),
      );
      } else if(dp.getSelectedDay == h1 || dp.getSelectedDay == h2 ||dp.getSelectedDay == h3 ||dp.getSelectedDay == h4 ||dp.getSelectedDay == h5 ||dp.getSelectedDay == h6){
        return Container(
        child:Center(
        child: Text("Nothing Here, Today is a Public Holiday.", style: TextStyle(fontSize: 15.0)),
        ),
      );
      }  else if (!(dp.getSelectedDay.weekday == 6 || dp.getSelectedDay.weekday == 7)) {
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
                     return ListTileTheme(
                       //contentPadding: EdgeInsets.fromLTRB(10.0, 0, 0, 5),
                       //textColor: Theme.of(context).primaryColor,
                       textColor: Colors.white70,
                        child: SwitchListTile(
                            inactiveThumbColor: Colors.white54,
                            inactiveTrackColor: Colors.grey[200],
                            activeColor: Colors.white,
                            activeTrackColor: Color(0xEE1db954),
                            title: Text(event),
                            value: snapshot.data,
                            onChanged: (bool value) {
                              setState(() {
                                helper.updateItem(dp.getSelectedDay, event, value);
                              });
                            },
                          ),
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
        child: Text("No Lectures Today.", style: TextStyle(fontSize: 17.0)), 
        ),
      );
    }
  }

  
}






