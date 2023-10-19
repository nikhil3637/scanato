
class CityModel {
  int id;
  String stateName;
  String name;
  String code;

  CityModel({
    required this.id,
    required this.stateName,
    required this.name,
    required this.code,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
    id: json["id"],
    stateName: json["stateName"],
    name: json["name"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "stateName": stateName,
    "name": name,
    "code": code,
  };
}
