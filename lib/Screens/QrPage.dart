import 'package:flutter/material.dart';
import '../QR/qrenter.dart';

class QrPage extends StatefulWidget {
  String? parkID;
  String? time;
  QrPage({Key? key, this.parkID, this.time}) : super(key: key);

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  @override
  Widget build(BuildContext context) {
    String? parkID = widget.parkID;
    String? time = widget.time;
    return Scaffold(
      backgroundColor: Colors.black38,
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
      ),
      body: Center(
        child:TextButton(
          onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context) => QR(parkID: parkID,time:time)));
          },
          child: const Text('Scan to Start Parking'),
        )
      ),
    );
  }
}
