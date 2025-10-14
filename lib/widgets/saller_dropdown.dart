import 'package:flutter/material.dart';
import '../style/styles.dart'; // importar estilos

class CustomDropdown extends StatefulWidget {
  final List<String> items;        // Lista de opciones
  final String hintText;           // Texto inicial
  final ValueChanged<String?> onChanged; // Acción al seleccionar

  const CustomDropdown({
    super.key,
    required this.items,
    required this.hintText,
    required this.onChanged,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: _selectedValue, //Se cambio value por initialValue
      decoration: AppInputStyles.base.copyWith(
        hintText: widget.hintText,
      ),
      items: widget.items
          .map((item) => DropdownMenuItem(
        value: item,
        child: Text(item, style: AppTextStyles.subtitle),
      ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedValue = value;
        });
        widget.onChanged(value);
      },
    );
  }
}
