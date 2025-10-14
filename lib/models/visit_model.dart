class VisitModel {
  final int visitId;
  final String visitDate;
  final int status;
  //final String seller;
  final String observations;

  VisitModel({
    required this.visitId,
    required this.visitDate,
    required this.status,
    //required this.seller,
    required this.observations,
  });

  factory VisitModel.fromMap(Map<String, dynamic> map) {
    return VisitModel(
      visitId: map['visit_id'] ?? 0,
      visitDate: map['visit_date'] ?? '',
      status: map['status'] ?? 0,
      //seller: map['seller'] ?? '',
      observations: map['observations'] ?? '',
    );
  }
}
