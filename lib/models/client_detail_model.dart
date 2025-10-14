import 'package:proyecto_uno/models/payment_model.dart';
import 'package:proyecto_uno/models/visit_model.dart';

class ClientDetailModel {
  final int clientId;
  final String firstName;
  final String lastName;
  final String documentType;
  final String documentNumber;
  final String address;
  final String phone;
  final String reference;
  final String photo;
  final List<PaymentModel> payments;
  final List<VisitModel> visits;

  ClientDetailModel({
    required this.clientId,
    required this.firstName,
    required this.lastName,
    required this.documentType,
    required this.documentNumber,
    required this.address,
    required this.phone,
    required this.reference,
    required this.photo,
    required this.payments,
    required this.visits,
  });

  factory ClientDetailModel.fromMap(Map<String, dynamic> map) {
    return ClientDetailModel(
      clientId: map['client_id'] ?? 0,
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      documentType: map['document_type'] ?? '',
      documentNumber: map['document_number'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      reference: map['reference_description'] ?? '',
      photo: map['home_photo_url'] ?? '',
      payments: [],
      visits: [],
    );
  }

  // Permite copiar el cliente agregando sus listas de pagos y visitas
  ClientDetailModel copyWith({
    List<PaymentModel>? payments,
    List<VisitModel>? visits,
  }) {
    return ClientDetailModel(
      clientId: clientId,
      firstName: firstName,
      lastName: lastName,
      documentType: lastName,
      documentNumber: lastName,
      address: address,
      phone: phone,
      reference: phone,
      photo: phone,
      payments: payments ?? this.payments,
      visits: visits ?? this.visits,
    );
  }
}
