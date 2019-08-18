import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:about/about.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
     mainAxisSize: MainAxisSize.max,
     crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SafeArea(
                  child: SizedBox(
            height: 25.0,
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
            child: AboutPage(
                applicationDescription: Text("An App That Saves You The Hassle Of Remembering Daily TimeTable And Managing Your Lecture-Bunks.",
                style: TextStyle(
                  fontSize: 14.0
                ),
                ),
                applicationName: "Bunk it!",
                applicationVersion: "Version 0.0.1 (Beta)",
                title: Text(
                  "About", 
                  style: TextStyle(
                    fontSize: 35.0, 
                    fontFamily: 'Product_Sans',
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).accentColor,
                    ),
                    ),
                applicationLegalese: "Apache 2.0 (LICENSE)",
                applicationIcon: Container(
                  margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                  child: Image(
                    image: AssetImage("assets/icon.png"),
                    height: 150.0,
                  ),
                ),
                children: <Widget>[
                 Row(
                   mainAxisSize: MainAxisSize.max,
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: <Widget>[
                     Text('How to use this App? '),
                     RichText(
                       text: TextSpan(
                         text: 'Click Here!', 
                         style: TextStyle(
                         color: Theme.of(context).primaryColor,
                       ),
                       recognizer: TapGestureRecognizer()
                       ..onTap = () => launch('https://github.com/Techno-Disaster/Kjsce-FY-Timetable/blob/master/README.md'),
                       ),
                     )
                     
                   ],
                 ),
                 SizedBox(height: 15.0,),
                 Row(
                   mainAxisSize: MainAxisSize.max,
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: <Widget>[
                     Text('Want To Contribute or Just see the code? '),
                    RichText(
                       text: TextSpan(
                         text: 'Github', 
                         style: TextStyle(
                         color: Theme.of(context).primaryColor,
                       ),
                       recognizer: TapGestureRecognizer()
                       ..onTap = () => launch('https://technodisaster.me'),
                       ),
                     ),
                   ],
                 ),
                 SizedBox(height: 15.0,),
                  Row(
                     mainAxisSize: MainAxisSize.max,
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: <Widget>[
                       Text('Found a Bug? ',
                       ),
                       Text("Report me on Telegram  ",
                       style: TextStyle(
                         color: Theme.of(context).primaryColor,
                       ),
                       ),
                     ],
                   ),
                   SizedBox(height: 15.0,),
                  Row(
                     mainAxisSize: MainAxisSize.max,
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: <Widget>[
                       Text('Have any other Query? ',
                       ),
                       Text("Ask me on ",
                       style: TextStyle(
                         color: Theme.of(context).primaryColor,
                       ),
                       ),
                       RichText(
                       text: TextSpan(
                         text: 'Telegram', 
                         style: TextStyle(
                         color: Theme.of(context).primaryColor,
                         decoration: TextDecoration.underline
                       ),
                       recognizer: TapGestureRecognizer()
                       ..onTap = () => launch('http://t.me/techno_disaster'),
                       ),
                     )
                     ],
                   ),
                    SizedBox(height: 15.0,),
                  Row(
                     mainAxisSize: MainAxisSize.max,
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: <Widget>[
                       Text('Follow Me on: ',
                       ),
                        RichText(
                       text: TextSpan(
                         text: 'Instagram', 
                         style: TextStyle(
                         color: Theme.of(context).primaryColor,
                         decoration: TextDecoration.underline
                       ),
                       recognizer: TapGestureRecognizer()
                       ..onTap = () => launch('https://www.instagram.com/techno_disaster/'),
                       ),
                     ),
                     Text(" and ", style: TextStyle(color: Theme.of(context).primaryColor),),
                     RichText(
                       text: TextSpan(
                         text: 'Twitter', 
                         style: TextStyle(
                         color: Theme.of(context).primaryColor,
                         decoration: TextDecoration.underline
                       ),
                       recognizer: TapGestureRecognizer()
                       ..onTap = () => launch('https://twitter.com/techno_disaster'),
                       ),
                     ),
                     ],
                   ),
                ],
              )
      ),
          ),
    ),
      ],
    );
  }
}
      
    
