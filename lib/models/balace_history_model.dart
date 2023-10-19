class BalanceHis {
  final double cr;
  final double dr;
  final String txNo;
  final DateTime txDate;
  final TxBy txBy;

  BalanceHis({
    required this.cr,
    required this.dr,
    required this.txNo,
    required this.txDate,
    required this.txBy,
  });

  factory BalanceHis.fromJson(Map<String, dynamic> json) {
    return BalanceHis(
      cr: json['cr'] as double,
      dr: json['dr'] as double,
      txNo: json['txNo'] as String,
      txDate: DateTime.parse(json['txDate'] as String),
      txBy: TxBy.fromJson(json['txBy'] as Map<String, dynamic>),
    );
  }
}

class TxBy {
  final bool isSuccess;
  final Role role;
  final int id;
  final String name;
  final String email;
  final String mobile;

  TxBy({
    required this.isSuccess,
    required this.role,
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
  });

  factory TxBy.fromJson(Map<String, dynamic> json) {
    return TxBy(
      isSuccess: json['isSuccess'] as bool,
      role: Role.fromJson(json['role'] as Map<String, dynamic>),
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      mobile: json['mobile'] as String,
    );
  }
}

class Role {
  final int id;
  final String name;

  Role({
    required this.id,
    required this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
