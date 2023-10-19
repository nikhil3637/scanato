

class Makeid {
  int id;
  String name;
  String code;

  Makeid({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Makeid.fromJson(Map<String, dynamic> json) => Makeid(
    id: json["id"],
    name: json["name"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
  };
}
