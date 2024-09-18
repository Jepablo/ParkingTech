import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:parkingtechproject/Screens/parking.dart';
import 'package:parkingtechproject/Screens/profile_page.dart';
import 'package:parkingtechproject/Screens/receipt_history.dart';



class PagesNavigate extends StatefulWidget {
  const PagesNavigate({Key? key}) : super(key: key);

  @override
  _PagesNavigate createState() => _PagesNavigate();
}

class _PagesNavigate extends State<PagesNavigate> {

  final List _options=[
    Home(),ReservationHistory(),ProfilePage()
  ];
  int _currentIndex=0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: (_options[_currentIndex])),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.orangeAccent,
        height: 55.0,
        buttonBackgroundColor: Colors.orangeAccent,
        backgroundColor: Colors.white,
        animationCurve: Curves.bounceOut,
        items:  const <Widget>[
          Icon(FlutterIcons.home_outline_mco,color: Colors.black, size: 25),
          Icon(FlutterIcons.receipt_mco,color: Colors.black, size: 25),
          Icon(FlutterIcons.account_outline_mco,color: Colors.black, size: 25),
        ],
        onTap: (index){
          setState(() {
            _currentIndex=index;
          });
        },
      ),
    );
  }
}