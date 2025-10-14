import 'package:flutter/material.dart';
import 'package:proyecto_uno/controllers/client_dao.dart';
import 'package:proyecto_uno/models/client_detail_model.dart';

import '../style/styles.dart';


class ClientDetailPage extends StatefulWidget {
  final int clientId;
  const ClientDetailPage({super.key, required this.clientId});
  //const ClientDetailPage({Key? key, required this.clientId}) : super(key: key);

  @override
  State<ClientDetailPage> createState() => _ClientDetailPageState();
}

class _ClientDetailPageState extends State<ClientDetailPage> {
  final ClientDao _clientDao = ClientDao();
  late Future<ClientDetailModel> _clientFuture;

  @override
  void initState() {
    super.initState();
    _clientFuture = _clientDao.getClientDetail(widget.clientId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle Cliente"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: FutureBuilder<ClientDetailModel>(
        future: _clientFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No se encontró información del cliente."));
          }

          final client = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPersonalInfoCard(client),
                const SizedBox(height: 16),
                _buildLocationCard(client),
                const SizedBox(height: 16),
                _buildHistoryCard(client),
              ],
            ),
          );
        },
      ),
    );
  }

  // 🧍 Información personal
  Widget _buildPersonalInfoCard(ClientDetailModel client) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Información Personal",
                style: AppTextStyles.title.copyWith(fontSize: 18)),
            const SizedBox(height: 8),
            _infoRow("Nombre:", "${client.firstName} ${client.lastName}"),
            _infoRow("Tipo ID:", client.documentType),
            _infoRow("Número:", client.documentNumber),
            _infoRow("Teléfono:", client.phone),
          ],
        ),
      ),
    );
  }

  // 📍 Ubicación
  Widget _buildLocationCard(ClientDetailModel client) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ubicación", style: AppTextStyles.title.copyWith(fontSize: 18)),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),

                  child: client.photo.isNotEmpty
                  // Si client.photo tiene una ruta (ej: 'lib/static/img/foto_cliente.png'), intenta cargarla
                      ? Image.asset(
                    client.photo,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    // Un errorBuilder es una buena práctica por si la foto del cliente no existe
                    errorBuilder: (context, error, stackTrace) {
                      // Si falla al cargar la foto del cliente, muestra la imagen por defecto
                      return Image.asset(
                        'lib/static/img/img01.png', // Tu imagen local por defecto
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                  // Si client.photo está vacío, muestra la imagen por defecto directamente
                      : Image.asset(
                    'lib/static/img/img01.png', // Tu imagen local por defecto
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),


                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(client.address,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(client.reference,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54)),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          // TODO: abrir en Google Maps
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.map_outlined,
                                size: 16, color: Colors.blueAccent),
                            SizedBox(width: 6),
                            Text(
                              "Abrir en Google Maps",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.blueAccent,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // TODO: Editar ubicación
                  },
                  icon: const Icon(Icons.edit_outlined, color: Colors.black54),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 📜 Historial
  Widget _buildHistoryCard(ClientDetailModel client) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("HISTORIAL",
                    style: AppTextStyles.title.copyWith(fontSize: 18)),
                TextButton(
                  onPressed: () {
                    // TODO: Ver historial completo
                  },
                  child: const Text(
                    "Ver detalles",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildPaymentsList(client),
            const Divider(height: 24, thickness: 1),
            _buildVisitsList(client),
          ],
        ),
      ),
    );
  }

  // 💰 Lista de abonos
  Widget _buildPaymentsList(ClientDetailModel client) {
    final payments = client.payments.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Abonos Realizados",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 6),
        for (var p in payments)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(p.paymentDate),
                Text("\$${p.amount.toStringAsFixed(0)}"),
              ],
            ),
          ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            "Total abonos realizados  \$${client.payments.fold(0.0, (sum, p) => sum + p.amount).toStringAsFixed(0)}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // 👣 Lista de visitas
  Widget _buildVisitsList(ClientDetailModel client) {
    final visits = client.visits.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Visitas Recientes",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 6),
        for (var v in visits)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(v.visitDate),
                Text(v.observations),
              ],
            ),
          ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
