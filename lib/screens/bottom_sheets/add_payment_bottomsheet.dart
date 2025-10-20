import 'package:flutter/material.dart';
import '../../controllers/payment_dao.dart';
import '../../models/payment_model.dart';
import '../../style/styles.dart';
import 'package:intl/intl.dart'; //Formato de fecha

class AddPaymentBottomSheet extends StatefulWidget {
  final int clientId; // ID del cliente para registrar el abono
  final int routeId;
  final String clientName; // nombre del cliente
  final double clientCredits; // saldo del cliente

  const AddPaymentBottomSheet({
    super.key,
    required this.clientId,
    required this.routeId,
    required this.clientName,
    required this.clientCredits,
  });

  @override
  State<AddPaymentBottomSheet> createState() => _AddPaymentBottomSheetState();
}

class _AddPaymentBottomSheetState extends State<AddPaymentBottomSheet> {
  final PaymentDao _paymentDao = PaymentDao();
  // Añade una clave para el formulario
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _observationController = TextEditingController();
  int _selectedOption = 1; // opción por defecto

  @override
  void dispose() {
    _amountController.dispose();
    _observationController.dispose();
    super.dispose();
  }
  // CONFIRMAR ABONO
  void _confirmPayment() {
    // Valida el formulario antes de continuar
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // Dialogo de confirmación
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar abono'),
        content: Text(
          '¿Deseas registrar un abono de \$${_amountController.text} '
              'a ${widget.clientName}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {

              await _savePayment();

              if (context.mounted) {
                Navigator.of(context).pop(); // cerrar diálogo
                Navigator.of(context).pop(true);
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  // Funcion para guardar el abono
  Future<void> _savePayment() async {

    // Formatea la fecha y hora actual
    final String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());


    final double amount = double.parse(_amountController.text);
    final String observation = _observationController.text;
    final int paymentMethod = _selectedOption;
    final int clientId = widget.clientId;
    final int routeId = widget.routeId;
    final double clientCredits = widget.clientCredits;

    // Crea el objeto PaymentModel
    final newPayment = PaymentModel(
      paymentId: null,
      creditId: null,
      saleId: null,
      sellerId: null,
      remaining: clientCredits,
      amount: amount,
      observation: observation,
      methodId: paymentMethod,
      receipt: null, // De momento no tienes la foto, se deja en null
      paymentDate: formattedDate, // Guarda la fecha y hora actual
    );

    // Usa el DAO para insertar en la base de datos
    await _paymentDao.insertPayment(
        payment: newPayment,
        clientId: clientId,
        routeId: routeId
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos los paddings de la pantalla
    final EdgeInsets viewInsets = MediaQuery.of(context).viewInsets;
    final EdgeInsets viewPadding = MediaQuery.of(context).viewPadding;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: viewInsets.bottom + viewPadding.bottom +16,
      ),
      child: SingleChildScrollView(
        //COLUMNA DENTRO DE UN FORM
        child: Form(
          key: _formKey,

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.background,//Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Registrar abono',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Campo de monto
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Valor a pagar',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingrese un valor";
                  }
                  final amount = double.tryParse(value);
                  if (amount == null) {
                    return "Por favor, ingrese un valor válido";
                  }
                  if (amount < 100) {
                    return "El monto debe ser mayor";
                  }
                  if (amount > widget.clientCredits) {
                    return 'El monto no puede superar el saldo: \$${widget.clientCredits.toStringAsFixed(2)}';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Opciones de medio de pago
              const Text(
                'Medio de pago:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Column(
                children: [
                  RadioListTile<int>(
                    title: const Text('Efectivo'),
                    value: 1,
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() => _selectedOption = value!);
                    },
                  ),
                  RadioListTile<int>(
                    title: const Text('Transferencia'),
                    value: 2,
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() => _selectedOption = value!);
                    },
                  ),
                  RadioListTile<int>(
                    title: const Text('Efectivo y transferencia'),
                    value: 3,
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() => _selectedOption = value!);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Botones adicionales
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Aquí puedes abrir la cámara o galería
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Comprobante'),
                    style: AppButtonStyles.iconButton2,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Mostrar QR (por ejemplo, con showDialog o Image.asset)
                    },
                    icon: const Icon(Icons.qr_code),
                    label: const Text('Ver QR'),
                    style: AppButtonStyles.iconButton1,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                'Observaciones:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Campo de Observaciones
              TextField(
                controller: _observationController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Agregar observaciones',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Botones principales
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: AppButtonStyles.secondaryButton,
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancelar"),
                  ),
                  ElevatedButton(
                    style: AppButtonStyles.primaryButton,
                    onPressed: _confirmPayment,
                    child: const Text("Confirmar"),
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
