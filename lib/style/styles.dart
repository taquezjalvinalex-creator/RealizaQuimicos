import 'package:flutter/material.dart';

/// 🎨 Colores globales
class AppColors {
  static const primary = Color(0xFF0A2540);   // Azul oscuro corporativo
  static const secondary = Color(0xFFF8FAFC);      //No se esta utilizando
  static const background = Color(0xFFF8FAFC);     // Fondo principal
  static const greyLight = Color(0xFF6B7280); // Gris claro para inputs

  static const dangerColor = Color(0xFFB91C1C);
  static const infoColor = Color(0xFFC1A24A);
  static const successColor = Color(0xFF15803D);
}

/// 📝 Estilos de texto globales
class AppTextStyles {
  static const title = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
    color: AppColors.primary,
  );

  static const subtitle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const cursive = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.bold, //negrita
    color: AppColors.primary,
  );

  static const boldSuccess = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.bold, //negrita
    color: AppColors.successColor,
  );

  static const boldInfo = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.bold, //negrita
    color: AppColors.infoColor,
  );

  static const textGrey = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    color: AppColors.greyLight,
  );

  static const myText = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    color: AppColors.primary,
  );

  static const textButton = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold, //negrita
    color: Colors.white,
  );

}

/// 📝 Estilos de botones globales
class AppButtonStyles {
  // Botones
  static const button1 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
  static const button2 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  static const buttonSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    textStyle: button1,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static ButtonStyle secondaryButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: AppColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static ButtonStyle iconButton1 = ElevatedButton.styleFrom(
    backgroundColor: AppColors.greyLight,
    foregroundColor: Colors.white,
    textStyle: button1,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static ButtonStyle iconButton2 = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: AppColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static ButtonStyle outlinedButton = OutlinedButton.styleFrom(
    foregroundColor: AppColors.secondary,
    side: const BorderSide(color: AppColors.secondary, width: 1.5),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

}

/// 📝 Estilos de inputs globales
class AppInputStyles {
  // Input
  static InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  static final InputDecoration base = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      filled: true,
      fillColor: Colors.white,
  );
}
