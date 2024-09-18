import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../QR/qrexit.dart';
import '../model/installparking.dart';

class ParkingPage extends StatefulWidget {
  ParkingPage({Key? key, this.parkID,this.time}) : super(key: key);
  String? parkID;
  String? time;
  @override
  State<ParkingPage> createState() => _ParkingPageState();
}

class _ParkingPageState extends State<ParkingPage> {
  dynamic data;
  dynamic data1;
  double? amt;
  static const countdownDuration = Duration(seconds: 0);
  Duration duration = Duration();
  Timer? timer;
  bool isCountdown = true;
  InstallParking parking = InstallParking();
  @override
  void initState(){
    super.initState();
    FirebaseFirestore.instance.collection('Parking').doc(widget.parkID).get().then((value){
      this.parking = InstallParking.fromMap(value.data());
    });
    startTimer();
    reset();
  }

  void reset(){
    if (isCountdown){
      setState(() => duration = countdownDuration);
    }
    else{
      setState(() => duration = Duration());
    }
  }
  void addTime(){
    final addSeconds = isCountdown? 600 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if(seconds <0) {
        timer?.cancel();
      }
      else{
        duration = Duration(seconds: seconds);
      }
    });
  }
  void startTimer(){
    timer = Timer.periodic(Duration(seconds: 1),(_) => addTime());

  }


  void stopTimer({bool resets = true}){
    if (resets){
      reset();
    }

    setState(() => timer?.cancel());

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
          backgroundColor: const Color(0xFF121212),
          elevation: 0.0,
          title: const Text('Parking Tech',
            style:TextStyle(
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle:true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
            Row(
              mainAxisAlignment: MainAxisAlignment.center ,
              children:const [
                CircleAvatar(
                    backgroundColor: Colors.amber,
                    radius: 100.0,
                    child: Center(
                      child: Text('P',
                        style:TextStyle(
                          fontSize: 80,
                          color: Color(0xFF121212),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text('Parking time : ',
              style:TextStyle(
                fontSize: 20,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTime(),
                buildButtons()
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget buildButtons(){

    final isRunning = timer == null? false : timer!.isActive;

    return isRunning
        ?Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          child: const Text('End parking'),
          onPressed: (){
            data = timer;
            data1 = duration ;
            final Duration dur = data1;
            int d = dur.inMinutes.toInt();
            var b = parking.rate;
            double value = d.toDouble();
            double a = double.parse(b!) * value;
            amt = double.parse(a.toStringAsFixed(2));
            Navigator.push(this.context,MaterialPageRoute(builder: (context) => QRExit(price: amt.toString() , duration:data1, parkID:widget.parkID, time:widget.time)));
          },
        ),
      ],
    )
        :
    TextButton(
        child: const Text('Start Timer'),
        onPressed:(){
          startTimer();
        }
    );

  }
  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2,'0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeCard(time: hours , header: 'Hours'),
        const SizedBox(width: 8),
        buildTimeCard(time: minutes , header: 'Minutes'),
        const SizedBox(width: 8),
        buildTimeCard(time: seconds , header: 'Seconds'),
      ],
    );
  }

  Widget buildTimeCard({required String time, required String header}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black,
            ),
            child:
            Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 60,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(header)
        ],
      );
}
