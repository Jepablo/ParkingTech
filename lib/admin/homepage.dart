import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parkingtechproject/admin/adminlogin.dart';
import 'package:parkingtechproject/admin/userfeedback.dart';
import 'chart.dart';
import 'addparking.dart';

class AdminHomePage extends StatefulWidget {
  // const AdminHomePage({Key? key}) : super(key: key);
  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}



class _AdminHomePageState extends State<AdminHomePage> {
  CollectionReference ref = FirebaseFirestore.instance.collection('Parking');
  String userID = FirebaseAuth.instance.currentUser!.uid;

 StreamSubscription? listener;
  int _user = 0;

  //DELETE
  Future<void> _deleteProduct(String productId) async {

    await ref.doc(productId).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }
  //Sign Out
  Future <void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) =>  const AdminLogin(),
      ),
          (route) => false,
    );
    // Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => AdminLogin()));
  }

  @override
  void initState(){
    super.initState();
    listener = FirebaseFirestore.instance.collection('parkingTech')
        .snapshots().listen((snap) {
      final user = snap.docs.map((doc) => doc.data());
      _user = 0;
      for (var users in user) {
        if (users['uid'] != null) _user++;
      }
      setState(() {});
    });
  }
  @override
  // ignore: deprecated_member_use
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async{
        return false;
      },
  // {

    child: Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
          backgroundColor: Color(0xFF121212),
          elevation: 0.0,
          title:  Text('Admin Homepage',
            style:const TextStyle(
              color: Color(0xFFFFFFFF),
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
                size: 30,
              ),
            ),
          ]
      ),
      body: Column(
        children: [
          new Align(alignment: Alignment.centerLeft, child: new Text(
            '    Total User $_user', style: TextStyle(
              fontSize: 20.0,fontWeight: FontWeight.bold
          ),)),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Parking').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.hasData){
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index){
                        final DocumentSnapshot documentSnapshot = (snapshot.data!.docs[index]);
                        final parkID = (documentSnapshot['parkID']);
                        // var price = (documentSnapshot['rate']);
                        // var total = price ;
                          return Card(
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              title: Text('Level                : ' +documentSnapshot['level'] + '\nParking Code : ' + documentSnapshot['parking']
                                   + '\nSection            : ' + documentSnapshot['section']),
                              // subtitle: Text(documentSnapshot['parking']),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                      onPressed: () => bottomUsername(context, parkID),

                                  ),
                                  IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () => _deleteProduct(documentSnapshot.id),
                                  ),
                                ],
                              ),
                            ),
                          );
                  });
                }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
              },
            ),
          ),
        ],
      ),
      drawer:  const NavigationDrawer(),
    ));
  void bottomUsername(BuildContext e, parkID){
    final TextEditingController _priceController = TextEditingController();
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
                controller: _priceController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: "Price",
                ),
              ),
              const SizedBox(height: 15,),
              ElevatedButton(onPressed: () {
                userUpdate(_priceController.text, parkID);
                Fluttertoast.showToast(msg:"Successful");
                Navigator.pop(context);
              }, child: const Text('Submit'))
            ],
          ),
        )
    );
  }
}

  class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) => Drawer(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children:  <Widget> [
          buildHeader(context),
          buildMenuItems(context),
        ],
      ),
    ),
  );

  Widget buildHeader (BuildContext context) => Container(
    color: Colors.amber,
    child: InkWell(
      onTap: (){},
      child: Container(
        padding: EdgeInsets.only(
        top: 24 +  MediaQuery.of(context).padding.top,
        bottom: 24,
      ),
        child: Column(
          children: const [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                'https://www.shutterstock.com/image-vector/people-icon-vector-illustration-flat-design-405042562'
              ),
            ),
            SizedBox(height: 12),
            Text('Admin')
          ],
        ),
      ),
    ),
  );

  Widget buildMenuItems (BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    child: Wrap(
      children: [
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('Home'),
          onTap:(){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminHomePage(),));
          }
        ),
        const Divider(color: Colors.black54,),
        ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Add Parking'),
            onTap:(){
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddParking(),));
            }
        ),
        const Divider(color: Colors.black54,),
        ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Report Feedback'),
            onTap:(){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserFeedback(),));
            }
        ),
        const Divider(color: Colors.black54,),
        ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Parking statistic'),
            onTap:() async{
              double totalMon = 0;
              double totalTue = 0;
              double totalWed = 0;
              double totalThurs = 0;
              double totalFri = 0;
              double totalSat = 0;
              double totalSun = 0;
              dynamic data;
              String price = "";
              String day = " ";
              String id = "";

              final ref = FirebaseFirestore.instance.collection('DisplayReceipt');
              QuerySnapshot query = await ref.get();
              final allData = query.docs.map((doc) => doc.id).toList();
              if (allData.isNotEmpty){

                for (int i = 0; i < allData.length; i++) {
                  DocumentReference reference = FirebaseFirestore.instance.collection('DisplayReceipt').doc(allData[i]);
                  await reference.get().then<dynamic>((DocumentSnapshot snapshot) async{
                      data = snapshot.data();
                      price = data['price'];
                      day = data['timestamp'];
                      id = data['id'];

                      // double con = double.parse(price);

                    // double amount = double.parse(con.toStringAsFixed(2));
                    print("${allData[i]}/$id");
                    if(day == "Mon"){
                      totalMon++;
                        totalMon ++;
                    }
                    if(day == "Tue"){
                         totalTue ++;
                    }
                    if(day == "Wed"){
                         totalWed ++;
                    }
                    if(day == "Thu"){
                         totalThurs ++;
                    }
                    if(day == "Fri"){
                         totalFri ++;
                    }
                    if(day == "Sat"){
                         totalSat ++;
                    }
                    if(day == "Sun"){
                       totalSun ++;
                    }
                  });
                }
              }
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ParkingChartPage(
                  totalMon:totalMon,totalTue:totalTue,totalWed:totalWed,
                  totalThurs:totalThurs,totalFri:totalFri,totalSat:totalSat,totalSun:totalSun),));
            }
        ),
        const Divider(color: Colors.black54,),
      ],
    ),
  );
}
//EDIT
Future userUpdate(String price, String userID) async{
  final CollectionReference park = FirebaseFirestore.instance.collection('Parking');
  return await park.doc(userID).update({'rate':double.parse(price)/60}  );
}









