
class InstallParking{

  String? level;
  String? parkID;
  String? parking;
  String? rate;
  String? section;
  String? vacancy;


  InstallParking({this.level,this.parkID,this.parking,this.rate,this.section,this.vacancy});

  //receive data from server
  factory InstallParking.fromMap(map){
    return InstallParking(
      level: map['level'],
      parkID: map['parkID'],
      parking: map['parking'],
      rate: map['rate'],
      section: map['section'],
      vacancy: map['vacancy'],


    );
  }

  //sending data to server
  Map<String,dynamic> toMap(){
    return{
      'level': level,
      'parkID': parkID,
      'parking': parking,
      'rate': rate,
      'section': section,
      'vacancy': vacancy,

    };
  }


  //receive data from server
  static InstallParking fromJson(Map<String, dynamic> json) => InstallParking(
    level: json['level'],
    parkID: json['parkID'],
    parking: json['parking'],
    rate: json['rate'],
    section: json['section'],
    vacancy: json['vacancy'],
  );

  //sending data to server
  Map<String,dynamic> toJson() =>{
    'level': level,
    'parkID': parkID,
    'parking': parking,
    'rate': rate,
    'section': section,
    'vacancy' : vacancy,

  };
}


