import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:parkingtechproject/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:parkingtechproject/model/user.dart';
import 'Screens/MainPage.dart';


Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey = "pk_test_51LHIjvJ5bt4B4CmJkmYt4E1GvHRCerqFhEmLlN2gjfWYC8mjMqZxvuDiZN7ipcWrxcxdN6oZBxKZKOfVAIwQvKzN00OQiwid7A";
  // Stripe.instance.applySettings();
  await Firebase.initializeApp(
      options: FirebaseOptions(apiKey: "AIzaSyD59Nz0y4Z8S-rVpeu5E5lslsW_8WYrEiE",
          appId: "XXX", messagingSenderId: "XXX",
          projectId: "parkingtech-f1449",
          storageBucket: "gs://parkingtech-f1449.appspot.com",
      ),


  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return StreamProvider<Client?>.value(
        initialData: null,
        value: AuthService().user,
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MainPage(),
        )
    );
  }
}

