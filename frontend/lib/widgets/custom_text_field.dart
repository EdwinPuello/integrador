import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final String etiqueta;
  final TextEditingController controlador;
  final bool esPassword;
  final TextInputType tipoTeclado;
  final String? Function(String?)? validador;
  final int maxLineas;

  const CustomTextField({
    super.key,
    required this.etiqueta,
    required this.controlador,
    this.esPassword = false,
    this.tipoTeclado = TextInputType.text,
    this.validador,
    this.maxLineas = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      obscureText: esPassword,
      keyboardType: tipoTeclado,
      maxLines: esPassword ? 1 : maxLineas,
      validator: validador,
      style: GoogleFonts.poppins(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: etiqueta,
        labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 14),
        filled: true,
        fillColor: AppColors.card.withOpacity(0.5),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
