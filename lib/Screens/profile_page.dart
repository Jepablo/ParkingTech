import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../model/parking.dart';

// class to handle display profile page
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  TextEditingController name = TextEditingController();
  TextEditingController username= TextEditingController();
  TextEditingController carplate = TextEditingController();
  TextEditingController phone = TextEditingController();

  // firebase instance
  //   User? user = FirebaseAuth.instance.currentUser;
  String userID = FirebaseAuth.instance.currentUser!.uid;
  User? user = FirebaseAuth.instance.currentUser;


  Parking loginuser = Parking();
  @override
    Future<void> initState() async {
      super.initState();
      FirebaseFirestore.instance
          .collection('parkingTech')
          .doc(user!.uid)
          .get()
          .then((value){
        this.loginuser = Parking.fromMap(value.data());
        setState(() {});
      });
      super.initState();
      FirebaseAuth.instance.userChanges().asyncMap((User? user) =>
          FirebaseFirestore.instance
              .collection('parkingTech')
              .doc(user!.uid)
              .get()
              .then((value) {
            this.loginuser = Parking.fromMap(value.data());
            setState(() {});
              }
              ));
    }

    @override
    Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async{
          return false;
        },

      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile Page"),
          backgroundColor: Colors.amber,
        ),
        body:
           Container(
            padding: const EdgeInsets.only(top:0.0),
            child: Stack(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 80.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),

                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        // const SizedBox(height: 80.0,),
                        Container(

                          padding: const EdgeInsets.only(
                            top: 80.0,
                            left: 20.0,
                            right: 20.0,
                          ),
                          child: Column(
                            children: <Widget>[
                              TextField(
                                enabled: false,
                                controller: name,
                                decoration: InputDecoration(
                                  labelText: "${loginuser.name}",
                                  prefixIcon: const Icon(Icons.person),
                                  border: myInputBorder(),
                                  enabledBorder: myInputBorder(),
                                  focusedBorder: myFocusBorder(),
                                ),
                              ),
                              const SizedBox(height: 20.0,),
                              TextField(
                                enabled: false,
                                controller: username,
                                decoration: InputDecoration(
                                  labelText: "${loginuser.userName}",
                                  prefixIcon: const Icon(Icons.person),
                                  border: myInputBorder(),
                                  enabledBorder: myInputBorder(),
                                  focusedBorder: myFocusBorder(),
                                ),
                              ),
                              const SizedBox(height: 20.0,),
                              TextField(
                                enabled: false,

                                controller: carplate,
                                decoration: InputDecoration(
                                  labelText: "${loginuser.car}",
                                  prefixIcon: const Icon(Icons.car_repair),
                                  border: myInputBorder(),
                                  enabledBorder: myInputBorder(),
                                  focusedBorder: myFocusBorder(),
                                ),
                              ),
                              const SizedBox(height: 20.0,),
                              TextField(
                                enabled: false,
                                controller: phone,
                                decoration: InputDecoration(
                                  labelText: "${loginuser.num}",
                                  prefixIcon: const Icon(Icons.phone),
                                  border: myInputBorder(),
                                  enabledBorder: myInputBorder(),
                                  focusedBorder: myFocusBorder(),
                                ),
                              ),
                              const SizedBox(height: 20.0,),
                              ElevatedButton(
                                onPressed: ()  {
                                  bottomUsername(context);
                                },
                                child: const Text('Edit Profile'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0,
                                    vertical: 20.0,
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Stack(
                      children: <Widget>[
                        ClipOval(
                          child: Image.asset(
                            'assets/images/test.png',
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 15.5,
                          child: Container(
                              padding: const EdgeInsets.all(5.0) ,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              // child: const Icon(Icons.edit,size: 30.0,)
                          ),
                        )
                      ],
                    ),
                  ),
                ]),
          ),
      ));
    // }
  void bottomUsername(BuildContext e){

    String? name = loginuser.name;
    String cusername = name!;

    String? phone = loginuser.num;
    String? number = phone!;

    String? username = loginuser.userName;
    String Name = username!;

    TextEditingController _usernameController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();
    final TextEditingController _nameController = TextEditingController();
    _usernameController.value = TextEditingValue(
      text: username,
    );
    _phoneController.value = TextEditingValue(
      text: phone,
    );
    _nameController.value = TextEditingValue(
      text:name,
    );
    showModalBottomSheet(
        isScrollControlled:true,
        context: e,
        builder: (e) => Padding
          (padding: EdgeInsets.only(
            top:15,
            left:15,
            right:15,
            bottom: MediaQuery.of(e).viewInsets.bottom +15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: "Phone",
                ),
              ),
              TextField(
                controller: _usernameController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: "Username",
                ),
              ),
              TextField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(onPressed: () {
                userUpdate(_phoneController.text,_usernameController.text, _nameController.text, userID);
                Fluttertoast.showToast(msg:"Successful");
                Navigator.pop(context);
              }, child: const Text('Submit'))
            ],
          ),
        )
    );
  }
    OutlineInputBorder myInputBorder(){
      return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Colors.green,
          width: 3,
        ),
      );
    }
    OutlineInputBorder myFocusBorder(){
      return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Colors.greenAccent,
          width: 3,
        ),
      );
    }
}


//EDIT
Future userUpdate(String phone,String username, String name, String userID) async{
  final CollectionReference profile = FirebaseFirestore.instance.collection('parkingTech');
  return await profile.doc(userID).update({'phone':phone , 'userName':username, 'name': name}  );
}
