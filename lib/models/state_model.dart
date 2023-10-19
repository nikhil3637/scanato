
class StateModel {
  int id;
  String name;
  String code;
  String gstCode;

  StateModel({
    required this.id,
    required this.name,
    required this.code,
    required this.gstCode,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
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
