
class ReceiptDisplay{
  String? totalhour;
  String? price;
  String? name;
  String? car;
  String? number;
  String? uid;
  String? timestamp;
  String? id;

  // DateTime? datetime;
  ReceiptDisplay({this.totalhour,this.price,this.name,this.car,this.number,this.uid, this.timestamp, this.id});


  //sending data to server
  Map<String,dynamic> toMap(){
    return{
      'totalhour': totalhour ,
      'price': price,
      'name': name,
      'car': car,
      'number': number,
      'uid':uid,
      'timestamp': timestamp,
      'id' : id
      // 'datetime' : datetime,
    };
  }
  //receive data from server
  static ReceiptDisplay fromJson(Map<String, dynamic> json) => ReceiptDisplay(
    totalhour: json['totalhour'],
      price: json['price'],
      name: json['name'],
      car: json['car'],
      number: json['number'],
      uid: json['uid'],
      timestamp: json['timestamp'],
      id: json['id']
      // datetime: json['datetime']
  );
  @override
  String toString() => "Record<$price:$name:$car$number:$uid:$timestamp>";

  //sending data to server
  Map<String,dynamic> toJson() =>{
    'totalhour': totalhour,
    'price': price,
    'name': name,
    'car': car,
    'number': number,
    'uid' : uid,
    'timestamp' : timestamp,
    'id' : id

    // 'datetime' : datetime
  };
}