import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import '../model/parking.dart';

class ParkingPrice extends StatefulWidget {
  ParkingPrice({Key? key, required this.total}) : super(key: key);
  final double total;
  @override
  State<ParkingPrice> createState() => _ParkingPriceState();
}

class _ParkingPriceState extends State<ParkingPrice> {
  // CollectionReference ref = FirebaseFirestore.instance.collection('Payment');
  User? user = FirebaseAuth.instance.currentUser;
  Parking loginuser = Parking();

  //DELETE
  Future<void> _deleteProduct() async {
    var collection = FirebaseFirestore.instance.collection('Payment');
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

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
  Widget build(BuildContext context) {

    Future<void> initPaymentSheet(context, {required String email, required double
    amount}) async {
      // try {
      //   final response = await http.post(
      //       Uri.parse(
      //           ' ://us-central1-parkingtech-f1449.cloudfunctions.net/stripePaymentIntentRequest'),
      //       body: {
      //         'email': email,
      //         'amount': amount.toString()
      //       });
      //   final jsonResponse = jsonDecode(response.body);
      //   log(jsonResponse.toString());

      //   await stripe.Stripe.instance.initPaymentSheet(
      //     paymentSheetParameters: stripe.SetupPaymentSheetParameters(
      //       paymentIntentClientSecret: jsonResponse['paymentIntent'],
      //       merchantDisplayName: 'Parking Testing',
      //       customerId: jsonResponse['customer'],
      //       customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
      //       style: ThemeMode.light,
      //       testEnv: true,
      //       merchantCountryCode: 'SG',
      //     ),
      //   );
      //   await stripe.Stripe.instance.presentPaymentSheet();
      //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment completed'),));
      //   // Navigator.push(context,MaterialPageRoute(builder: (context) => Home()));
      //   Navigator.of(context).pushReplacement(
      //       MaterialPageRoute(builder: (context) => PagesNavigate()));
      // } catch (e) {
      //   if (e is stripe.StripeException){
      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error from Stripe : ${e.error.localizedMessage}'),));
      //   }
      //   else{
      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e '),));
      //   }

      // }
    }


    // final CollectionReference ref = FirebaseFirestore.instance.collection('Payment').doc('price') as CollectionReference<Object?>;
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Payment'),
          ),
          body: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Payment').where('uid' , isEqualTo: loginuser.uid).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(snapshot.hasData){
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext ctx, index){
                      final DocumentSnapshot documentSnapshot = (snapshot.data!.docs[index]);
                      return Card(
                        child: SizedBox(
                            child: ListBody(
                              children: [
                                const SizedBox(height: 25),
                                const Text("Name " ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                Text("\n""${loginuser.name}\n", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),

                                const SizedBox(height: 25),
                                const Text("Phone Number" ,style:  TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                Text("\n""${loginuser.num}\n", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),

                                const SizedBox(height: 25),
                                const Text("Car Plate" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                Text("\n""${loginuser.car}" "\n", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),

                                const SizedBox(height: 15),
                                const Text("Parking Duration\n" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                Text(documentSnapshot['totalhour']+"\n", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),

                                const SizedBox(height: 15),
                                const Text("Total Price" ,style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                Text("RM : "+ widget.total.toStringAsFixed(2) +"\n\n\n\n\n\n\n\n", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),

                                Center(child:
                                ElevatedButton(
                                    onPressed: () async{
                                      await initPaymentSheet(context, email: loginuser.email.toString(), amount: widget.total * 100);
                                      _deleteProduct();
                                    },
                                    child: const Text('Pay')),

                                )
                              ],
                            )
                        ),
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
          )
      ),
    );
  }
}
