
class MachineList {
  String name;
  int id;
  String machineCode;
  CenterMachineType make;
  Model model;
  CenterMachineType machineType;
  int capacity;

  MachineList({
    required this.name,
    required this.id,
    required this.machineCode,
    required this.make,
    required this.model,
    required this.machineType,
    required this.capacity,
  });

  factory MachineList.fromJson(Map<String, dynamic> json) => MachineList(
    name: json["name"],
    id: json["id"],
    machineCode: json["machineCode"],
    make: CenterMachineType.fromJson(json["make"]),
    model: Model.fromJson(json["model"]),
    machineType: CenterMachineType.fromJson(json["machineType"]),
    capacity: json["capacity"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "machineCode": machineCode,
    "make": make.toJson(),
    "model": model.toJson(),
    "machineType": machineType.toJson(),
    "capacity": capacity,
  };
}

class CenterMachineType {
  int? id;
  String? name;
  String? code;

  CenterMachineType({
    required this.id,
    required this.name,
    required this.code,
  });

  factory CenterMachineType.fromJson(Map<String, dynamic> json) => CenterMachineType(
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

class Model {
  int? id;
  String? name;

  Model({
    required this.id,
    required this.name,
  });

  factory Model.fromJson(Map<String, dynamic> json) => Model(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}