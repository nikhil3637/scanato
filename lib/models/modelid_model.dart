

class ModelId {
  int id;
  String name;

  ModelId({
    required this.id,
    required this.name,
  });

  factory ModelId.fromJson(Map<String, dynamic> json) => ModelId(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
