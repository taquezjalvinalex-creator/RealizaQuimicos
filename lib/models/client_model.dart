class ClientModel {
  final int clientId;
  final int routeId;
  final String firstName;
  final String lastName;
  final String documentType;
  final String documentNumber;
  final String address;
  final String phone;
  final String homePhoto;
  final String referenceDescription;
  final String visits;
  final int status;
  final double credits;
  final double payments;

  ClientModel({
    required this.clientId,
    required this.routeId,
    required this.firstName,
    required this.lastName,
    required this.documentType,
    required this.documentNumber,
    required this.address,
    required this.phone,
    required this.homePhoto,
    required this.referenceDescription,
    required this.visits,
    required this.status,
    required this.credits, //Suma de balance
    required this.payments,
  });

  // Convertir desde Map (resultado de SQLite) a ClientModel
  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      clientId: map['client_id'] ?? 0,
      routeId: map['route_id'] ?? 0,
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      documentType: map['document_type'] ?? '',
      documentNumber: map['document_number,'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      homePhoto: map['home_photo_url'] ?? '',
      referenceDescription: map['reference_description'] ?? '',
      status: map['status'] ?? 0,
      visits: (map['last_visit'] ?? ''),
      credits: (map['credits'] ?? 0).toDouble(),
      payments: (map['payments'] ?? 0).toDouble(),
    );
  }
}
