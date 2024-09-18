class Parking {
  String? uid;
  String? car;
  String? name;
  String? num;
  String? userName;
  String? email;
  String? geo;
  Parking({ this.car, this.name, this.num , this.uid , this.email, this.userName, this.geo});

  factory Parking.fromMap(map){
    return Parking(

      car: map['car'],
      name: map['name'],
      num: map['phone'],
      uid: map['uid'],
      email: map['email'],
        userName: map['userName'],
        geo:map['geo']

    );
  }
// sending data to server
  Map<String,dynamic> toMap(){
    return{
      'car': car,
      'name': name,
      'phone': num,
      'uid' : uid,
      'email' : email,
      'userName' : userName,
      'geo':geo,

    };
  }
}

