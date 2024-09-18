import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:parkingtechproject/Screens/QrPage.dart';
import 'package:parkingtechproject/model/installparking.dart';
import '../model/Reservation.dart';
import '../model/parking.dart';

class Reservation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Car Reservation';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MyCustomForm(),
      ),
    );
  }
}
// Create a Form widget.

class MyCustomForm extends StatefulWidget {
  const MyCustomForm ({Key? key, this.onSubmitted}) : super(key: key);
  final Function(String? name,String? phone,String? plate,String? uid,String? parkID)? onSubmitted;
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class. This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  final TextEditingController controller= TextEditingController();
  String vacancy = 'occupied';
  final GlobalKey<FormState> _formKey=GlobalKey ();
  late String name,phone,plate,uid,parkID;
  //firebase instance
  User? user = FirebaseAuth.instance.currentUser;
  String test ='occupied';
  InstallParking spot = InstallParking();
  Parking loginuser = Parking();
  @override
  void initState(){
    super.initState();
    name="";
    phone="";
    plate="";
    uid="";
    parkID="";
    FirebaseFirestore.instance
        .collection('parkingTech')
        .doc(user!.uid)
        .get()
        .then((value){
      this.loginuser = Parking.fromMap(value.data());
      setState(() {});
    });
  }
  var dropdownvalue3;
  var drop;
  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async{
      return false;
    },
  // {
    // var uid = loginuser.uid;
    child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          // title: const Text('Car reservation',
          //   style:TextStyle(
          //     color: Color(0xFF121212),
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          centerTitle:true,
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 30,),
                const SizedBox(height: 10,),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Parking')
                      .where('vacancy' , isEqualTo: 'available' )
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator(),
                      );
                    }
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [
                              Colors.blue,
                              Colors.blue,
                              Colors.blue
                              //add more colors
                            ]),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left:30, right:30),
                        child: DropdownButton(
                          isExpanded: false,
                          // value: selectedValue,
                          items: snapshot.data?.docs.map((value) {
                            return DropdownMenuItem(
                              value: value.get('parkID'),
                              child: Text('${value.get('parking')}'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(
                                    () {
                                  dropdownvalue3 = value;
                                }

                            );
                          },
                          // value: dropdownvalue3,
                          hint: const Text('Parking Spot    '),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 25),
                Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          child: const Text('Submit'),
                          onPressed: () async{
                            if(dropdownvalue3 == null){
                              Fluttertoast.showToast(msg: "Please Reserve a parking spot");
                            }
                            else if(dropdownvalue3 != null){
                              // FieldValue t = FieldValue.serverTimestamp();
                              DateTime e = DateTime.now();
                              String t =  DateFormat.E().format((e)).toString();
                              final add = Reservationn(
                                  name: loginuser.name,
                                  phone: loginuser.num,
                                  plate: loginuser.car,
                                  uid: loginuser.uid,
                                  parkID: dropdownvalue3,
                                  timestamp: t

                                //letak price untuk kira nanti
                              );
                              CreateReservation(add);
                              // Fluttertoast.showToast(msg: "Added");

                              final collection1 = FirebaseFirestore.instance.collection('Parking');
                              await collection1.doc(dropdownvalue3).update({
                                'vacancy': 'occupied'
                              });
                              Navigator.push(context, MaterialPageRoute(builder: (context) => QrPage(parkID:dropdownvalue3,time: t)));
                            }
                          }
                      ),
                      const SizedBox(width : 12),
                    ]
                ),
              ],
            ),
          ),
        ),
      ),
    ));


  }

  // //EDIT
  // Future updateParking(String vacancy, String userID) async{
  //   final CollectionReference profile = FirebaseFirestore.instance.collection('Parking');
  //   return await profile.doc(userID).update({'vacancy':vacancy}  );
  // }
  Future CreateReservation(Reservationn add) async {
    // User? user = FirebaseAuth.instance.currentUser;
    final docMenu = FirebaseFirestore.instance.collection('Reservation').doc();
    // add.stallID = user.uid;
    add.ResId = docMenu.id;
    final json = add.toJson();
    await docMenu.set(json);
  }
// }





