
class OfferType {
  int id;
  String name;
  String code;

  OfferType({
    required this.id,
    required this.name,
    required this.code,
  });

  factory OfferType.fromJson(Map<String, dynamic> json) => OfferType(
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
