import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parkingtechproject/admin/adminlogin.dart';
import 'package:parkingtechproject/model/installparking.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';


class AddParking extends StatelessWidget {
  const AddParking({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final appTitle = 'Add Parking';


    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: addParkingForm(),
      ),
    );
  }
}

class addParkingForm extends StatefulWidget{
  const addParkingForm ({Key? key, this.onSubmitted}) : super(key: key);

  final Function(String? level,String? parkID,String? parking,String? rate,String? section,String? vacancy)? onSubmitted;
  @override

  addParkingFormState createState() {

    return addParkingFormState();
  }
}

class addParkingFormState extends State <addParkingForm> {
  late String level,parkID,parking,rate,section,vacancy;
  double? total;
  String? levelError,sectionError,codeError,rateError;
  static const String _counterKey = 'COUNTER';
  int _counter = 0;
  late final SharedPreferences sp;
  late bool isFetchingCounterValue;
  @override
  void initState() {
    super.initState();
    level="";
    parkID="";
    parking="";
    rate= "";
    section = "";
    vacancy = "available";

    levelError = null;
    sectionError = null;
    codeError = null;
    rateError = null;



    WidgetsBinding.instance.addPostFrameCallback((
        _) async { //make sure that build function is finished then setState
      setState(() {
        isFetchingCounterValue = true;
      });
      sp = await SharedPreferences.getInstance();
      setState(() {
        isFetchingCounterValue = false;
        _counter = sp.getInt(_counterKey) ??
            0; //0 if it's first time you are opening the app
      });
    });
  }


  String userID = FirebaseAuth.instance.currentUser!.uid;

  final TextEditingController parkingname= TextEditingController();
  final TextEditingController parkinglevel= TextEditingController();
  final TextEditingController parkingsection= TextEditingController();
  final GlobalKey<FormState> _formKey=GlobalKey ();


  @override
  Widget build(BuildContext context) {
    void resetErrorText() {
      setState(() {
        levelError = null;
        sectionError = null;
        codeError = null;
        rateError = null;
      });
    }
    bool validate(){
      resetErrorText();
      bool isValid = true;
      if(section.isEmpty){
        setState((){
          sectionError = "Enter section (A-Z)";
        });
        isValid = false;
      }
      if(section.length > 1){
        setState((){
          sectionError = "More than 1";
        });
        isValid = false;
      }
      if(level.isEmpty){
        setState((){
          levelError = "Enter a level (1-10)";
        });
        isValid = false;
      }
      if(parking.isEmpty){
        setState((){
          codeError = "Enter a parking code (exp: A000)";
        });
        isValid = false;
      }

      if(rate.isEmpty){
        setState((){
          rateError = "Enter a rate";
        });
        isValid = false;
      }
      return isValid;
    }

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: isFetchingCounterValue ? const CircularProgressIndicator() : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10,),
            InputField(
              onChanged: (value) {
                setState(() {
                  level = value;
                });
              },
              labelText: 'Parking Level (1-9)',
              errorText: levelError,
            ),
            const SizedBox(height: 10,),
            InputField(
              onChanged: (value) {

                  section = value;

              },
              labelText: 'Parking Section (A-Z)',
              errorText: sectionError,

            ),
            const SizedBox(height: 10,),
            InputField(
              onChanged: (value) {
                setState(() {
                  parking = value;
                });
              },
              labelText: 'Parking Code (Exp : A000)',
              errorText: codeError,

            ),
            const SizedBox(height: 10,),
            InputField(
              onChanged: (value) {
                setState(() {
                  rate = value;
                  total = double.parse(rate)/60;
                });
              },
              labelText: 'Parking Rate (Exp: 5.00/5)',
              errorText: rateError,

            ),

            Container (
              padding: const EdgeInsets.only(left: 40.0, top: 40.0),
              child:
              ElevatedButton(
                  child: const Text('Submit'),

                  onPressed: ()
                  {
                    if (validate()){
                      final add = InstallParking(
                          level: level,
                          parkID: parkID,
                          parking: parking,
                          rate: total.toString(),
                          section: section,
                          vacancy : vacancy
                      );
                      CreateParking(add);
                      Fluttertoast.showToast(msg: "Added");
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => AdminHomePage()));
                    }

                  }
              ),
            ),
          ],
        ),
      ),
    );
}
  Future CreateParking(InstallParking add) async {
    // User? user = FirebaseAuth.instance.currentUser;
    final docMenu = FirebaseFirestore.instance.collection('Parking').doc();

    // add.stallID = user.uid;
    add.parkID = docMenu.id;

    final json = add.toJson();
    await docMenu.set(json);

  }

}




