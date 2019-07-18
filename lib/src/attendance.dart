import 'package:flutter/material.dart';
import 'dataProvider.dart';
import 'database_helper.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Attendance extends StatelessWidget {

  

  @override
  Widget build(BuildContext context) {

    final DatabaseHelper helper = DatabaseHelper();

    final data = Provider.of<DataProvider>(context);

    return Column(
     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
     mainAxisSize: MainAxisSize.max,
     crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: 20.0,
        ),
        Expanded(
          flex: 1,
                  child: Container(
            margin: EdgeInsets.fromLTRB(0, 30.0, 0, 15.0),
           alignment: Alignment(-0.75, 0),
            child: Text(
              "Attendance",
              style: TextStyle(
                fontFamily: 'Product_Sans',
                fontWeight: FontWeight.w400,
                fontSize: 40.0,
                color: Colors.white70,
              ),
            ),
          ),
        ),
    Expanded(
      flex: 5,
          child: Card(
            borderOnForeground: true,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)
            ),
            color: Theme.of(context).accentColor,
            margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
            child: Container(
            child: PercentageBuilder(helper: helper, data: data),
            
      ),
          ),
    ),
      ],
    );
  }
}

class PercentageBuilder extends StatelessWidget {
  const PercentageBuilder({
    Key key,
    @required this.helper,
    @required this.data,
  }) : super(key: key);

  final DatabaseHelper helper;
  final DataProvider data;

  @override
  Widget build(BuildContext context) {

    String getMonth() {
      switch (data.getSelectedDay.month) {
        case 1:
          return "January";
          break;
        case 2:
          return "February";
          break;
        case 3:
         return "March";
          break;
        case 4:
         return "April";
          break;
        case 5:
          return "May";
          break;
        case 6:
         return "June";
          break;
        case 7:
          return "July";
          break;
        case 8:
         return "August";
          break;
        case 9:
          return "September";
          break;
        case 10:
          return "October";
          break;
        case 11:
          return "November";
          break;
        case 12:
          return "December";
          break;   
                             
      }
    }
      
      String response(double data){
        
        String retResponse;

        if(data<=72.0) {
          retResponse = "You need to attend more lectures, friend.";
        } else if(data>=72.0 && data<75.0){
          retResponse = "Almost There, Mate!";
        } else if(data == 75.0) {
          retResponse = "Phew! Did it!";
        } else if(data>75 && data<=80) {
          retResponse = 'Wew! Good Job, Mate!';
        } else if(data>80.0 && data<=100.0) {
          retResponse = "Real Pro, Nibba!";
        }
        return retResponse;
      }

      Color responseColor(double data){

        Color retColor;

        if(data < 75.0) {
            retColor = Colors.red;
        } else {
          retColor = Theme.of(context).primaryColor;
        }
        return retColor;
      }

    return FutureBuilder(
      future:  helper.countTrue2(data.getSelectedDay),
      builder: (BuildContext context, AsyncSnapshot<double> snapshot){
      if(!snapshot.hasData){
                        return Container(
                          child: Center(
                            child: Text("Loading..."),
                          ),
                        );
                        } else {
      return Container(
        child: CircularPercentIndicator(
          radius: 200.0,
          lineWidth: 10.0,
          percent: (snapshot.data)/100,
          header: Container(
            margin: EdgeInsets.all(15),
                      child: Text(
              "Your Attendance till " 
              + data.getSelectedDay.day.toString() 
              + ' ' 
              + getMonth() 
              + ' ' 
              + data.getSelectedDay.year.toString() 
              + ' ', 
              style: TextStyle(
                fontSize: 23.0,
                color: Colors.white,
                ) ,
              ),
          ),
          center: Center(
            child: Text(snapshot.data.toStringAsFixed(2), 
            style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold, color: Colors.white70),
            ),
          ),
          animation: true,
         animateFromLastPercent: true,
          animationDuration: 800,
          addAutomaticKeepAlive: false,
          progressColor: responseColor(snapshot.data),
          backgroundColor: Colors.white,

          footer: Container(
            margin: EdgeInsets.all(15.0),
            child: Text(response(snapshot.data),
            style: TextStyle(fontSize: 20.0,
            color: Colors.white70,
            ),
            ),
            ),
            circularStrokeCap: CircularStrokeCap.round,
        ),
      );
    }
    },

    );
  }
}