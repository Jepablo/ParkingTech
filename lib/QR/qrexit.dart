import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:io';
import 'package:parkingtechproject/model/receipt_display.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../Screens/parkingprice.dart';
import '../model/Reservation.dart';
import '../model/parking.dart';
import '../model/receipt.dart';

class QRExit extends StatefulWidget {
  QRExit({Key? key, required this.price, required this.duration, this.parkID,this.time}) : super(key: key);
  String price;
  String? parkID;
  String? time;
  final Duration duration;
  @override
  State<QRExit> createState() => _QRExitState();
}

class _QRExitState extends State<QRExit> {

  int counter =0;
  User? user = FirebaseAuth.instance.currentUser;
  Parking loginuser = Parking();

  // CollectionReference ref = FirebaseFirestore.instance.
  Reservationn test = Reservationn();

  Barcode? result;
  dynamic data;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
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
    format(Duration d) => d.toString().split('.').first.padLeft(8, "0");


    // String test = format(widget.duration);
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(25),
                        child: SizedBox(
                          height: 15,
                          width: 55,
                          child: ElevatedButton(
                            onPressed: ()  async{
                              await controller?.resumeCamera();
                            },
                            child: const Text('Scan', style: TextStyle(fontSize: 10)),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),

    );
  }

  void _onQRViewCreated(QRViewController controller) {
    format(Duration d) => d.toString().split('.').first.padLeft(8, "0");
    String? time = widget.time;

    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        counter++;
        // DateTime date2;
        // date2 = DateFormat('dd-MMM-yyy').format(date)
        result = scanData;
        if(counter == 1) {
          final add = Receipt(
            name: loginuser.name,
            car: loginuser.car,
            number: loginuser.num,
            totalhour: format(widget.duration),
            price: widget.price,
            uid: loginuser.uid,
          );
          final add2 = ReceiptDisplay(
            name: loginuser.name,
            car: loginuser.car,
            number: loginuser.num,
            totalhour: format(widget.duration),
            price: widget.price,
            uid: loginuser.uid,
            timestamp: time,
          );
          CreateReceipt(add, add2);
          FirebaseFirestore.instance.collection("Parking").doc(widget.parkID).set(
              {
                "vacancy" : "available",
              },SetOptions(merge:true));
          if(result != null){
            final totalprice = double.parse(widget.price);
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ParkingPrice(total: totalprice)));
          }
        }
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future CreateReceipt(Receipt add, ReceiptDisplay add2) async {
    final docMenu = FirebaseFirestore.instance.collection('Payment').doc();
    final docMenu2 = FirebaseFirestore.instance.collection('DisplayReceipt').doc();
    add2.id = docMenu2.id;
    final json = add.toJson();
    final json2 = add2.toJson();

    await docMenu.set(json);
    await docMenu2.set(json2);


  }
}



