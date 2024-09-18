import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../model/parking.dart';

class ReservationHistory extends StatefulWidget {
  const ReservationHistory({Key? key}) : super(key: key);

  @override
  _ReservationHistoryState createState() => _ReservationHistoryState();
}

class _ReservationHistoryState extends State<ReservationHistory> {
  User? user = FirebaseAuth.instance.currentUser;
  Parking loginuser = Parking();
  @override
  void initState(){
    super.initState();
    FirebaseFirestore.instance
        .collection('parkingTech')
        .doc(user!.uid)
        .get()
        .then((value){
      this.loginuser = Parking.fromMap(value.data());
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async{
        return false;
      },
  // {
    child: Scaffold(
      appBar: AppBar(
        title: const Text("Receipt History"),
        backgroundColor: Colors.amber,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('DisplayReceipt' ).where('uid',isEqualTo: loginuser.uid)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasData) {

            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 480 ,
                  childAspectRatio: 3/5,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 125,

                ), itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext ctx, index) {
                  final DocumentSnapshot documentSnapshot = (snapshot.data!.docs[index]);
                  return Center(
                      child: Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height - 60.0,
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width - 15.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color:Colors.orangeAccent,
                                    gradient: const LinearGradient(
                                        colors: [
                                          Colors.orangeAccent,
                                          Color(0xffc98a2a)
                                        ],
                                        begin: Alignment.centerRight,
                                        end: Alignment(-1.0, -1.0)
                                    ), //Gradient
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: <Widget>[
                                          //Text
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0),
                                            child: Container(
                                              child: const Text(
                                                'Receipt History',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24.0,
                                                  fontWeight: FontWeight.bold,
                                                ),),
                                            ),
                                          ),
                                          DataTable(
                                            columns: const <DataColumn>[
                                              DataColumn(
                                                label: Text(''),
                                              ),
                                              DataColumn(
                                                label: Text(''),
                                              ),
                                            ],
                                            rows: <DataRow>[
                                              DataRow(
                                                  cells: <DataCell>[
                                                    DataCell(
                                                      DataIcon(
                                                          FontAwesomeIcons
                                                              .user,
                                                          "Name"),
                                                    ),
                                                    DataCell(
                                                      Text(documentSnapshot['name'],
                                                        overflow: TextOverflow.ellipsis,
                                                        softWrap: true,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                        ),),
                                                    ),
                                                  ]
                                              ),
                                              DataRow(
                                                  cells: <DataCell>[
                                                    DataCell(
                                                      DataIcon(
                                                          FontAwesomeIcons
                                                              .car,
                                                          "Car Plate"),
                                                    ),
                                                    DataCell(
                                                      Text(
                                                        documentSnapshot['car'], style: const TextStyle(
                                                        color: Colors.white,
                                                      ),),
                                                    ),
                                                  ]
                                              ),
                                              DataRow(
                                                  cells: <DataCell>[
                                                    DataCell(
                                                      DataIcon(
                                                          FontAwesomeIcons
                                                              .phone,
                                                          "Phone Number"),
                                                    ),
                                                    DataCell(
                                                      Text(
                                                        documentSnapshot['number'], style: const TextStyle(
                                                        color: Colors.white,
                                                      ),),
                                                    ),
                                                  ]
                                              ),
                                              DataRow(
                                                  cells: <DataCell>[
                                                    DataCell(
                                                      DataIcon(
                                                          FontAwesomeIcons
                                                              .moneyBill,
                                                          "Parking Price"),
                                                    ),
                                                    DataCell(
                                                      Text(
                                                        'RM :' + documentSnapshot['price'], style: const TextStyle(
                                                        color: Colors.white,
                                                      ),),
                                                    ),
                                                  ]
                                              ),
                                              DataRow(
                                                  cells: <DataCell>[
                                                    DataCell(
                                                      DataIcon(
                                                          FontAwesomeIcons
                                                              .clock,
                                                          "Parking Hour"),
                                                    ),
                                                    DataCell(
                                                      Text(
                                                        documentSnapshot['totalhour'], style: const TextStyle(
                                                        color: Colors.white,
                                                      ),),
                                                    ),

                                                  ]
                                              ),
                                            ],
                                          ),
                                        ],),
                                    ],),
                                ),
                              ),
                            ]),
                      )
                  );
              }
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      )));
// }

ListTile DataIcon(IconData iconVal, String rowVal) {
  return ListTile(
    leading: Icon(iconVal,
        color: new Color(0xffffffff)),
    title: Text(rowVal, style: const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),),
  );
}}