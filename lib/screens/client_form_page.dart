import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto_uno/models/client_model.dart';
import '../style/styles.dart';

class ClientFormPage extends StatefulWidget {
  final ClientModel? client; // Si no es null, es edición
  const ClientFormPage({super.key, this.client});

  @override
  State<ClientFormPage> createState() => _ClientFormPageState();
}

class _ClientFormPageState extends State<ClientFormPage> {
  final _formKey = GlobalKey<FormState>();

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

  // Simulamos rutas disponibles (en una app real vendrían de la BD)
  final List<Map<String, dynamic>> _routes = [
    {'id': 1, 'name': 'Ruta Norte'},
    {'id': 2, 'name': 'Ruta Sur'},
    {'id': 3, 'name': 'Ruta Centro'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.client != null) {
      _loadClientData(widget.client!);
    }
  }

  void _loadClientData(ClientModel client) {
    _firstNameController.text = client.firstName;
    _lastNameController.text = client.lastName;
    _documentType = 'client.documentType';
    _documentNumberController.text = client.lastName;
    _phoneController.text = client.phone;
    _addressController.text = client.address;
    _selectedRouteId = client.routeId;
    _referenceDescriptionController.text = client.referenceDescription;
    _homePhotoUrl = client.lastName;
    _isActive = client.status as bool;
  }

  Future<void> _takePhoto() async {
    // Aquí iría la lógica para abrir la cámara (ej. usando image_picker)
    setState(() {
      _homePhotoUrl = "ruta/de/imagen.jpg"; // Simulado
    });
  }

  void _saveClient() {
    if (_formKey.currentState!.validate()) {
      final newClient = {
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'document_type': _documentType,
        'document_number': _documentNumberController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'route_id': _selectedRouteId,
        'reference_description': _referenceDescriptionController.text.trim(),
        'home_photo_url': _homePhotoUrl,
        'status': _isActive ? 1 : 0,
      };

      Navigator.pop(context, newClient); // Retornar datos al cerrar
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
              DropdownButtonFormField<int>(
                value: _selectedRouteId,
                decoration: const InputDecoration(labelText: "Ruta"),
                items: _routes.map((route) {
                  return DropdownMenuItem<int>(
                    value: route['id'], // El valor que se guarda
                    child: Text(route['name'] as String), // Lo que ve el usuario
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedRouteId = value),
                validator: (value) =>
                value == null ? "Seleccione una ruta" : null,
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
                    onPressed: _saveClient,
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
