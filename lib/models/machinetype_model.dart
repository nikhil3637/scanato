
class MachineType {
  int id;
  String name;
  String code;

  MachineType({
    required this.id,
    required this.name,
    required this.code,
  });

  factory MachineType.fromJson(Map<String, dynamic> json) => MachineType(
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
