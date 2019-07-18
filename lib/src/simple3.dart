import 'package:flutter/material.dart';
import 'dataProvider.dart';
import 'database_helper.dart';
import 'package:table_calendar/table_calendar.dart';
import 'timetable.dart';
import 'cupertinoSwitchListTile.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {

  final DataProvider dataProvider = DataProvider();
  

  @override
  Widget build(BuildContext context) {
    final DataProvider dp = Provider.of<DataProvider>(context);

    dp.setDays();
    

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
              child: _buildTableCalendar(context),
              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              elevation: 2
            ),
            // _buildTableCalendarWithBuilders(),
            const SizedBox(height: 6.0),
            Expanded(
             flex: 3,
              child: _buildEventList(context)
              ),
              //const SizedBox(height: 8.0),  
          ],
        ),
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar(context) {
    final DataProvider dp = Provider.of<DataProvider>(context);
    return TableCalendar(
      locale: 'en_IN',
      events: dp.visibleEvents,
      holidays: dp.visibleHolidays,
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
      onDaySelected: dp.onDaySelected,
      onVisibleDaysChanged: dp.onVisibleDaysChanged,
    );
  }

  
  Widget _buildEventList(context) {
      final DataProvider dp = Provider.of<DataProvider>(context);
    if (!(dp.getSelectedDay.weekday == 6 || dp.getSelectedDay.weekday == 7)) {
      return ListView(
      children: dp.getSelectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                 child: FutureBuilder(
                   future: dp.helper.fetchItem(dp.getSelectedDay, event),
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
                       onChanged: (bool value) => dp.helper.updateItem(dp.getSelectedDay, event, value)
    
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