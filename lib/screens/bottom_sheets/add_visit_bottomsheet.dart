import 'package:flutter/material.dart';
import '../../controllers/visit_dao.dart';
import '../../style/styles.dart';

class AddVisitBottomSheet extends StatefulWidget {
  final int clientId;
  final int sellerId;
  final int routeId;

  const AddVisitBottomSheet({
    super.key,
    required this.clientId,
    required this.sellerId,
    required this.routeId,
  });

  @override
  State<AddVisitBottomSheet> createState() => _AddVisitBottomSheetState();
}

class _AddVisitBottomSheetState extends State<AddVisitBottomSheet> {
  final TextEditingController _amountController = TextEditingController();
  final visitDao = VisitDao();
  int _selectedOption = 1;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _confirmVisit() {
    // ✅ Se accede a las variables del widget usando 'widget.'
    visitDao.registrarVisita(
      routeId: widget.routeId,
      clientId: widget.clientId,
      status: _selectedOption, // Usa el status seleccionado
      // Usa el texto del controlador si no está vacío, si no, usa el texto por defecto
      observations: '',
    );

    // ✅ Cierra el bottom sheet después de confirmar
    if(mounted) {
      Navigator.of(context).pop(true); // Notifica la accion de confirmacion
      // Opcional: Muestra un SnackBar de confirmación
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Visita registrada correctamente.'),
          backgroundColor: AppColors.greyLight,
        ),
      );
    }
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
                'Marcar Visita',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Column(
              children: [
                RadioListTile<int>(
                  title: const Text('El cliente no está'),
                  value: 1,
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() => _selectedOption = value!);
                  },
                ),
                RadioListTile<int>(
                  title: const Text('El cliente no abonó'),
                  value: 2,
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() => _selectedOption = value!);
                  },
                ),
              ],
            ),

            Center( child:
              ElevatedButton.icon(
                onPressed: () {
                  // Aquí puedes abrir la cámara o galería
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Agregar Foto'),
                style: AppButtonStyles.iconButton2,
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
                  onPressed: _confirmVisit,
                  child: const Text("Confirmar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
