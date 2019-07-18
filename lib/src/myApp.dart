import 'package:flutter/material.dart';
import 'simple2.dart';
import 'attendance.dart';
import 'about.dart';
import 'dataProvider.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'splashscreen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => DataProvider(),
    child: MaterialApp(
      title: 'Bunk it!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
         scaffoldBackgroundColor: Colors.black,
         primaryColor: Color(0xff1db954),
         accentColor: Color(0xff191414),
       // accentColor: Colors.white,
        brightness: Brightness.dark,
        fontFamily: 'Product_Sans',
      ),
     // home: DashboardScreen(),
     home: MySplashScreen(),
    )
    );
  }

}

class DashboardScreen extends StatefulWidget {

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController _pageController;
  int _page = 0;
  //MyHomePageState home = MyHomePageState();
  // DateTime _selectedDay = home.selectedDay;
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
    // MyHomePage home = MyHomePage();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }


  void navigationTapped(int page) {
    // Animating to the page.
    // You can use whatever duration and curve you like
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
              bucket: bucket,
              child: PageView(
          children: [
            MyHomePage(),
           Attendance(),
             About(),
          ],
          onPageChanged: onPageChanged,
          controller: _pageController,
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
              canvasColor: const Color(0xFF167F67),
            ), // sets the inactive color of the `BottomNavigationBar`
        child: BottomNavigationBar(
                backgroundColor: Colors.black,
                elevation: 0,
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor: Colors.white70,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today),
                    title: Text("TimeTable")
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.streetview),
                    title: Text("Attendance"),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.style),
                    title: Text("About")
                  ),
                ],
              onTap: navigationTapped,
          currentIndex: _page,
              )
      ),
    );
  }
}

