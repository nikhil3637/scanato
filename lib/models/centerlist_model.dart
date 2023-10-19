class CenterList {
  int id;
  String name;
  City state;
  City city;
  String address;
  int adminId;
  String adminName;
  String code;

  CenterList({
    required this.id,
    required this.name,
    required this.state,
    required this.city,
    required this.address,
    required this.adminId,
    required this.adminName,
    required this.code,
  });

  factory CenterList.fromJson(Map<String, dynamic> json) => CenterList(
    id: json["id"],
    name: json["name"],
    state: City.fromJson(json["state"]),
    city: City.fromJson(json["city"]),
    address: json["address"],
    adminId: json["adminId"],
    adminName: json["adminName"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "state": state.toJson(),
    "city": city.toJson(),
    "address": address,
    "adminId": adminId,
    "adminName": adminName,
    "code": code,
  };
}

class City {
  int? id;
  String? name;
  String? code;
  String? gstCode;

  City({
    required this.id,
    required this.name,
    required this.code,
    required this.gstCode,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    gstCode: json["gstCode"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "gstCode": gstCode,
  };
}
