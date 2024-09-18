class Receipt{
  String? totalhour;
  String? price;
  String? name;
  String? car;
  String? number;
  String? uid;
  Receipt({this.totalhour,this.price,this.name,this.car,this.number,this.uid});


  //sending data to server
  Map<String,dynamic> toMap(){
    return{
      'totalhour': totalhour ,
      'price': price,
      'name': name,
      'car': car,
      'number': number,
      'uid':uid
    };
  }
  //receive data from server
  static Receipt fromJson(Map<String, dynamic> json) => Receipt(
      totalhour: json['totalhour'],
      price: json['price'],
      name: json['name'],
      car: json['car'],
      number: json['number'],
      uid: json['uid']
  );

  //sending data to server
  Map<String,dynamic> toJson() =>{
    'totalhour': totalhour,
    'price': price,
    'name': name,
    'car': car,
    'number': number,
    'uid' : uid,
  };
}