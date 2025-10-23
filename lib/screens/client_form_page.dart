import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto_uno/models/client_model.dart';
import '../controllers/client_dao.dart';
import '../controllers/route_dao.dart';
import '../routes/app_routes.dart';
import '../style/styles.dart';

class ClientFormPage extends StatefulWidget {
  //final ClientModel? client; // Si no es null, es edición
  final int? routeId;

  const ClientFormPage({
    super.key,
    //this.client,
    this.routeId
  });

  @override
  State<ClientFormPage> createState() => _ClientFormPageState();
}

class _ClientFormPageState extends State<ClientFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _clientDao = ClientDao();
  final _routeDao = RouteDao();


  // Controladores
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _documentNumberController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _referenceDescriptionController = TextEditingController();

  // Variables
  String _documentType = 'CC';
  int? _selectedRouteId;
  bool _isActive = true;
  String? _homePhotoUrl;

  late Future<List<Map<String, dynamic>>> _routes;

  @override
  void initState() {
    super.initState();
    _selectedRouteId = widget.routeId;
    _routes = _routeDao.getRoutes();
    /*
    if (widget.client != null) {
      _loadClientData(widget.client!);
    }*/
  }
/*
  void _loadClientData(ClientModel client) {
    _firstNameController.text = client.firstName;
    _lastNameController.text = client.lastName ?? '';
    _documentType = client.documentType ?? '';
    _documentNumberController.text = client.lastName ?? '';
    _phoneController.text = client.phone;
    _addressController.text = client.address;
    _selectedRouteId = client.routeId;
    _referenceDescriptionController.text = client.referenceDescription ?? '';
    _homePhotoUrl = client.lastName;
    _isActive = client.status as bool;
  }*/

  Future<void> _takePhoto() async {
    // Aquí iría la lógica para abrir la cámara (ej. usando image_picker)
    setState(() {
      _homePhotoUrl = "ruta/de/imagen.jpg"; // Simulado
    });
  }

  // Confirma el pago
  void _confirmForm() {
    if (_formKey.currentState!.validate()) {
    // Dialogo de confirmación
      showDialog(
        context: context,
        builder: (dialogContext) =>
            AlertDialog(
              title: const Text('Guardar cliente'),
              content: Text(
                '¿Deseas registrar a ${_firstNameController.text.trim()}',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (dialogContext.mounted) {
                      await _saveClient();
                    }
                    if (mounted) {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.clients,
                        arguments: widget.routeId,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Datos guardados.'),
                          backgroundColor: Colors
                              .green, // Un color más apropiado para éxito
                        ),
                      );
                    }
                  },
                  child: const Text('Confirmar'),
                ),
              ],
            ),
      );
    }
  }

  Future<void> _saveClient() async{

    if (_formKey.currentState!.validate()) {

      final clientModel = ClientModel(
        clientId: null,
        routeId: _selectedRouteId!,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        documentType: _documentType,
        documentNumber: _documentNumberController.text.trim(),
        address: _addressController.text.trim(),
        phone: _phoneController.text.trim(),
        homePhoto: null, //_homePhotoUrl!,
        referenceDescription: _referenceDescriptionController.text.trim(),
        lastVisits: '',
        status: _isActive ? 1 : 0,
        credits: 0.0,
        payments: 0.0,
        latitude: 0.0,
        longitude: 0.0,
      );

      _clientDao.insertClient(clientModel);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Cliente'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Información personal",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              // Nombres
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: "Nombres",
                  hintText: "Ej: Juan Fernando",
                ),
                validator: (value) =>
                value == null || value.isEmpty ? "Campo obligatorio" : null,
              ),

              const SizedBox(height: 10),
              // Apellidos
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: "Apellidos",
                  hintText: "Ej: Pérez Peláez",
                ),
              ),

              const SizedBox(height: 10),
              // Tipo de documento
              DropdownButtonFormField<String>(
                value: _documentType,
                decoration: const InputDecoration(labelText: "Tipo de documento"),
                items: const [
                  DropdownMenuItem(value: "TI", child: Text("TI")),
                  DropdownMenuItem(value: "CC", child: Text("CC")),
                  DropdownMenuItem(value: "NIT", child: Text("NIT")),
                  DropdownMenuItem(value: "CE", child: Text("CE")),
                ],
                onChanged: (value) => setState(() => _documentType = value!),
              ),

              const SizedBox(height: 10),
              // Número de documento
              TextFormField(
                controller: _documentNumberController,
                decoration: const InputDecoration(
                  labelText: "Número de documento",
                  hintText: "Ej: 1234567890",
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),

              const SizedBox(height: 10),
              // Teléfono
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Teléfono",
                  hintText: "Ej: 3201548789",
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(12),
                ],
                validator: (value) =>
                value == null || value.isEmpty ? "Campo obligatorio" : null,
              ),

              const SizedBox(height: 20),
              const Text("Ubicación",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              // Dirección
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: "Dirección",
                  hintText: "Ej: Calle 10 #25-30",
                ),
                validator: (value) =>
                value == null || value.isEmpty ? "Campo obligatorio" : null,
              ),

              const SizedBox(height: 10),
              // Ruta
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _routes, // El Future que contiene la lista de rutas
            builder: (context, snapshot) {
              // Muestra un indicador de carga mientras los datos no estén listos
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // Muestra un mensaje si hubo un error al cargar las rutas
              if (snapshot.hasError) {
                return Text('Error al cargar rutas: ${snapshot.error}');
              }

              // Si no hay datos, muestra un mensaje (caso poco probable si siempre hay rutas)
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No hay rutas disponibles.');
              }

              // Cuando los datos están listos, construye el DropdownButtonFormField
              final routesList = snapshot.data!;
              return DropdownButtonFormField<int>(
                value: _selectedRouteId,
                decoration: const InputDecoration(labelText: "Ruta"),
                items: routesList.map((route) {
                  return DropdownMenuItem<int>(
                    // ✅ Corrige el acceso a los datos del mapa
                    value: route['route_id'] as int, // El valor que se guarda
                    child: Text(route['name'] as String), // Lo que ve el usuario
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedRouteId = value),
                validator: (value) =>
                value == null ? "Seleccione una ruta" : null,
              );
            },
          ),
              const SizedBox(height: 20),
              const Text("Detalles adicionales",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              Row(
                children: [
                  IconButton(
                    onPressed: _takePhoto,
                    icon: const Icon(Icons.camera_alt),
                    iconSize: 40,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _referenceDescriptionController,
                      decoration: const InputDecoration(
                        labelText: "Descripción",
                        hintText: "Ej: Cómo llegar a la ubicación del cliente",
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              // Estado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Estado",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Switch(
                    value: _isActive,
                    onChanged: (v) => setState(() => _isActive = v),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              // Botones principales
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancelar"),
                  ),
                  ElevatedButton(
                    onPressed: _confirmForm,
                    child: const Text("Guardar cliente"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
