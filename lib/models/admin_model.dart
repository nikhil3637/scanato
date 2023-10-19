
class Welcome {
  bool isSuccess;
  Role role;
  int id;
  String name;
  String email;
  String mobile;

  Welcome({
    required this.isSuccess,
    required this.role,
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    isSuccess: json["isSuccess"],
    role: Role.fromJson(json["role"]),
    id: json["id"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "role": role.toJson(),
    "id": id,
    "name": name,
    "email": email,
    "mobile": mobile,
  };
}

class Role {
  int id;
  String name;

  Role({
    required this.id,
    required this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
