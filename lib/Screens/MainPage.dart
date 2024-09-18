import 'package:flutter/material.dart';
import 'package:parkingtechproject/admin/adminlogin.dart';
import 'package:parkingtechproject/authenticate/sign_in.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          // Image.asset(
          //     'assets/images/wallpaper.png',width: 300
          // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 600,
                width: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/Parkingtech.png'
                      ),
                      fit: BoxFit.fitWidth,
                    )
                ),
              ),
              Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminLogin()));
                    },child: Text('Admin')),
                    SizedBox(width : 12),
                    ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    },child: Text('User')),
                  ]
              ),
            ],
          ),
        ],
      ),
    );  }
}
