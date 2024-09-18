import 'package:easy_geofencing/easy_geofencing.dart';
import 'package:easy_geofencing/enums/geofence_status.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:parkingtechproject/Screens/reportfeedback.dart';
import '../authenticate/sign_in.dart';
import '../model/parking.dart';
import 'car_reservation.dart';

class Home extends StatefulWidget{
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late StreamSubscription<GeofenceStatus> geofenceStatusStream;
  Geolocator geolocator = Geolocator();
  String geofenceStatus = '';
  bool isReady = false;
  late Position position;

  User? user = FirebaseAuth.instance.currentUser;
  Parking loginuser = Parking();
  dynamic data;
  bool isButtonActive = false;
  int _spot = 0;
  late StreamSubscription _listener;


  
  Future<dynamic> getData() async {

    final DocumentReference document =   FirebaseFirestore.instance.collection("Reservation").doc('uid');
    await document.get().then<dynamic>(( DocumentSnapshot snapshot) async{
      setState(() {
        data = snapshot.data;
      });
    });
  }

  @override
  void initState(){
    getCurrentPosition();
    super.initState();
    _listener = FirebaseFirestore.instance.collection('Parking')
    .snapshots().listen((snap) {
      final space = snap.docs.map((doc) => doc.data());

      _spot = 0;
      for (var spaceData in space) {
        if (spaceData['vacancy'] == 'available') _spot++;
      }
      setState(() {});
    });
    // Provider.of<LocationProvider>(context,listen:false).initalization();
    // location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    // location.enableBackgroundMode(enable: true);
    FirebaseFirestore.instance
        .collection('parkingTech')
        .doc(user!.uid)
        .get()
        .then((value){
      this.loginuser = Parking.fromMap(value.data());
      // setState(() {});
    });
    getData();
    // getCount();

  }

  //Sign Out
  Future <void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) =>  const LoginScreen(),
      ),
          (route) => false,
    );
  MaterialPageRoute(builder: (context) => const LoginScreen());
  }

  getCurrentPosition() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("LOCATION => ${position.toJson()}");
    setState((){
      isReady = (position != null) ? true : false;
    });

    EasyGeofencing.startGeofenceService(
      // pointedLatitude: "2.2277763",
      // pointedLongitude: " 102.45652",
      pointedLatitude: "3.1037401",
        pointedLongitude: "101.5466909",
        radiusMeter: "60",
        eventPeriodInSeconds: 5
    );
    StreamSubscription<GeofenceStatus> geofenceStatusStream = EasyGeofencing.getGeofenceStream()!.listen(
            (GeofenceStatus status) {
          print(status.toString());
          startGeofence(status.toString());
          // testing(status.toString());

            });
  }

  void startGeofence(String enter) {
    if (enter == "GeofenceStatus.enter") {
        FirebaseFirestore.instance.collection("parkingTech").doc(user!.uid).set(
          {
            "geo" : "1",
          },SetOptions(merge:true)).then((_)
            {
              print("Inside");
            }
        );
    }
    else {
      FirebaseFirestore.instance.collection("parkingTech").doc(user!.uid).set(
          {
            "geo" : "0",
          },SetOptions(merge:true)).then((_)
      {
        print("Outside");
      }
      );
    }
  }
  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async{
      return false;
    },
  // {
  //   return Scaffold(
    child: Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
          backgroundColor: Colors.amber,
          elevation: 0.0,
          title: const Text('Parking Tech',
            style:TextStyle(
              color: Color(0xFF121212),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle:true,
          actions: [
            IconButton(onPressed: (){
              logout(context);
            },
              icon: const Icon(
                Icons.logout,
                size: 25,
              ),
            ),
          ]
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('parkingTech')
          .where('uid', isEqualTo: loginuser.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          final geo = loginuser.geo;
          if(snapshot.hasData) {
            if(geo == "1"){
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/Parkingtech.png'
                            ),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Color(0xFF121212),
                      width: double.infinity,
                      child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text("Parking Spot remaining :  $_spot",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: <Color>[
                                              Color(0xFFF59222),
                                              Color(0xFFF59222),
                                              Color(0xFFF59222),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white, padding: const EdgeInsets.all(10.0),
                                        textStyle: const TextStyle(fontSize: 15),
                                      ),
                                      onPressed: () {
                                        showDialog(context: context,
                                            builder: (
                                                context) => Reservation());
                                      },
                                      child: const Text('Reserve a parking'),
                                    ),


                                  ],
                                ),
                              ),
                              const SizedBox(height: 15,),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: <Color>[
                                              Color(0xFFF62626),
                                              Color(0xFFF62626),
                                              Color(0xFFF62626),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white, padding: const EdgeInsets.all(10.0),
                                        textStyle: const TextStyle(fontSize: 15),
                                      ),
                                      onPressed: () {
                                        showDialog(context: context,
                                            builder: (
                                                context) => const FeedbackDialog());
                                      },
                                      child: const Text('Make a report ?    '),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12,),
                            ],
                          )
                      ),
                    ),
                  ),
                ],
              );
            }
            else if (geo == "0" || geo == "" || geo == " "){
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/Parkingtech.png'
                            ),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Color(0xFF121212),
                      width: double.infinity,
                      child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text("Parking Spot remaining : $_spot",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: <Color>[
                                              Color(0xFFF59222),
                                              Color(0xFFF59222),
                                              Color(0xFFF59222),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white, padding: const EdgeInsets.all(10.0),
                                        textStyle: const TextStyle(fontSize: 15),
                                      ),
                                      onPressed: () {
                                            Fluttertoast.showToast(msg: "Not in a radius");
                                      },
                                      child: const Text('Reserve a parking'),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15,),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: <Color>[
                                              Color(0xFFF62626),
                                              Color(0xFFF62626),
                                              Color(0xFFF62626),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white, padding: const EdgeInsets.all(10.0),
                                        textStyle: const TextStyle(fontSize: 15),
                                      ),
                                      onPressed: () {
                                        showDialog(context: context,
                                            builder: (
                                                context) => const FeedbackDialog());
                                      },
                                      child: const Text('Make a report ?    '),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12,),
                            ],
                          )
                      ),
                    ),
                  ),
                ],
              );
            }

          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      ),
    ));
  }




