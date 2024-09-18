
class Reservationn{
  String? name;
  String? phone;
  String? plate;
  String? uid;
  String? parkID;
  String? ResId;
  String? timestamp;
  Reservationn({this.name,this.phone,this.plate,this.uid,this.parkID,this.ResId, this.timestamp});

  //receive data from server
  factory Reservationn.fromMap(map){
    return Reservationn(
      name: map['name'],
      phone: map['phone'],
      plate: map['plate'],
      uid: map['uid'],
      parkID: map['parkID'],
      ResId: map['ResId'],
      timestamp: map['timestamp']



    );
  }
  //sending data to server
  Map<String,dynamic> toMap(){
    return {
      'name': name ,
      'phone': phone,
      'plate': plate,
      'uid': uid,
      'parkID': parkID,
      'ResId':ResId,
      'timestamp' : timestamp

    };
  }
  //receive data from server
  static Reservationn fromJson(Map<String, dynamic> json) => Reservationn(
      name: json['name'],
      phone: json['phone'],
      plate: json['plate'],
      uid: json['uid'],
      parkID: json['parkID'],
      ResId:json['ResId'],
      timestamp:json['timestamp']

  );

  //sending data to server
  Map<String,dynamic> toJson() =>{
    'name': name,
    'phone': phone,
    'plate': plate,
    'uid': uid,
    'parkID': parkID,
    'ResId':ResId,
    'timestamp' : timestamp
};
}