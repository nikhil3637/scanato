
class AnalyticsReport {
  int rechargeCollection;
  int totalNoOfCenter;
  int totalNoOfMachine;
  int totalNoOfUsers;
  dynamic adminColection;

  AnalyticsReport({
    required this.rechargeCollection,
    required this.totalNoOfCenter,
    required this.totalNoOfMachine,
    required this.totalNoOfUsers,
    required this.adminColection,
  });

  factory AnalyticsReport.fromJson(Map<String, dynamic> json) => AnalyticsReport(
    rechargeCollection: json["rechargeCollection"],
    totalNoOfCenter: json["totalNoOfCenter"],
    totalNoOfMachine: json["totalNoOfMachine"],
    totalNoOfUsers: json["totalNoOfUsers"],
    adminColection: json["adminColection"],
  );

  Map<String, dynamic> toJson() => {
    "rechargeCollection": rechargeCollection,
    "totalNoOfCenter": totalNoOfCenter,
    "totalNoOfMachine": totalNoOfMachine,
    "totalNoOfUsers": totalNoOfUsers,
    "adminColection": adminColection,
  };
}