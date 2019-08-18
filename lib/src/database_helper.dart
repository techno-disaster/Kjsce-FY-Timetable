import 'timetable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  DateTime _baseDay = DateTime(2019,07,01);
  DateTime _lastDay = DateTime(2019,10,16);
 
  final Map<DateTime, List> holidays = {
  DateTime(2019, 8, 12): ['Bakrid'],
  DateTime(2019, 8, 15): ['Independance Day, Rakshabandhan'],
  DateTime(2019, 9, 14): ['Muhharam'],
  DateTime(2019, 10, 2): ['Gandhi Jayanti'],
  DateTime(2019, 10, 8): ['Dusshera'],
  DateTime(2019, 10, 27): ['Diwali'],
};
  List<String> listEvents;
  List<DateTime> listHolidays = [
    DateTime(2019, 8, 12),
    DateTime(2019, 8, 15),
    DateTime(2019, 9, 14),
    DateTime(2019, 10, 2),
    DateTime(2019, 10, 8),
    DateTime(2019, 10, 27)
    ];


  void switchListEvents(DateTime i) {
    switch (i.weekday) {
        case 1:
          {
            listEvents = mon;
            break;
          }
        case 2 :
          {
           listEvents = tues;
            break;
          }
        case 3 :
          {
            listEvents = wed ;
            break;
          }
        case 4:
          {
            listEvents = thur;
            break;
          }
        case 5 :
          {
            listEvents = fri;
            break;
          }
    }
  }




  static DatabaseHelper _databaseHelper; //Singleton
  static Database _database; //singleton

  String attendanceTable = 'Attendance_Table';

   String colID = 'id';
   String colDate = 'date';
   String colEvent = 'event';
   String boolVal = "boolVal";
   int m = 0;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

//custom getter
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path,"attendance.db");

  //  await Sqflite.devSetDebugModeOn(true);

    var attendanceDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return attendanceDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $attendanceTable(id INTEGER PRIMARY KEY,$colDate INTEGER,$colEvent TEXT,$boolVal INTEGER)');

     outerloop: for(DateTime i=_baseDay; (i.isBefore(_lastDay) || i.isAtSameMomentAs(_lastDay)); i=i.add(Duration(days: 1))) {
        
        innerloop: for(DateTime h in listHolidays) {
           if(h == i) {
             continue outerloop;
           } else {
             continue innerloop;
           }
         }


        int k = i.millisecondsSinceEpoch;

         
        if(!(i.weekday == 6 || i.weekday==7)){
        switchListEvents(i);
        }
        else{
          continue;
        }

        for (int j = 0; j < listEvents.length ; j++){

          String l = listEvents[j];
           m++;
          await db.insert(
          "$attendanceTable",
          {"id" : "$m","$colDate": "$k", "$colEvent": "$l", "$boolVal": 1});

         }
  }


 }
    
    Future<bool> fetchItem(DateTime date, String event) async {
    Database db = await this.database;

    int dateTime = date.millisecondsSinceEpoch;
    
      var maps = await db.query(
      '$attendanceTable',
      columns: null,
      where: "$colDate = ? AND $colEvent = ?",
      whereArgs: [dateTime, event]
    );
    
    
    if(maps.length > 0)
    {
      bool boolVal1;
       boolVal1 = maps.first['boolVal'] == 1; 
       return boolVal1;
 
    } else {

      return null;
    }

  }

  Future<int> updateItem(DateTime date, String event, bool boolVal2) async {
      Database db = await this.database;
      int boolVal1;

      // if(boolVal) {
      //   boolVal1 = 1;
      // }
      // else {
      //   boolVal1 = 0;
      // }

      boolVal2 ? boolVal1 = 1 : boolVal1 = 0;

       int dateTime = date.millisecondsSinceEpoch;

       return await db.rawUpdate('UPDATE Attendance_Table SET boolVal = ? WHERE date = ? AND event = ?',
    ['$boolVal1', '$dateTime', '$event']);
    }

    
     Future<double> countTrue2(DateTime date) async {
      Database db = await this.database;

      int dateTime = date.millisecondsSinceEpoch;

      var countTrue2 = await db.rawQuery('SELECT COUNT(*) FROM $attendanceTable WHERE $boolVal = 1 AND $colDate <= $dateTime ');

      var countTotal2 = await db.rawQuery('SELECT COUNT(*) FROM $attendanceTable WHERE $colDate<= $dateTime');

      int rCountTrue =  Sqflite.firstIntValue(countTrue2);
      int rCountTotal = Sqflite.firstIntValue(countTotal2);

      double percent = (rCountTrue/rCountTotal)*100;
    
      return percent;
    }


}