class RouteModel {
  final int rutaId;
  final int vendedorId;
  final String ruta;
  final int numeroClientes;
  final int clientesVisitados;
  final double ventasTotales;
  final double abonosTotales;

  RouteModel({
    required this.rutaId,
    required this.vendedorId,
    required this.ruta,
    required this.numeroClientes,
    required this.clientesVisitados,
    required this.ventasTotales,
    required this.abonosTotales,
  });

  // Convertir desde Map (resultado de SQLite) a RouteModel
  factory RouteModel.fromMap(Map<String, dynamic> map) {
    return RouteModel(
      rutaId: map['route_id'] ?? 0,
      vendedorId: map['seller_id'] ?? 0,
      ruta: map['route_name'] ?? '',
      numeroClientes: map['clients'] ?? 0,
      clientesVisitados: map['number_visits'] ?? 0,
      ventasTotales: (map['sales'] ?? 0).toDouble(),
      abonosTotales: (map['payments'] ?? 0).toDouble(),
    );
  }
}
