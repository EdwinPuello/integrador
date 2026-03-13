import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/producto.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class ProductoFormScreen extends StatefulWidget {
  final Usuario usuario;
  final Producto? producto;

  const ProductoFormScreen({
    super.key,
    required this.usuario,
    this.producto,
  });

  @override
  State<ProductoFormScreen> createState() => _ProductoFormScreenState();
}

class _ProductoFormScreenState extends State<ProductoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final nombreController      = TextEditingController();
  final descripcionController = TextEditingController();
  final precioController      = TextEditingController();
  final stockController       = TextEditingController();
  bool cargando = false;

  bool get esEdicion => widget.producto != null;

  @override
  void initState() {
    super.initState();
    if (esEdicion) {
      nombreController.text      = widget.producto!.nombre;
      descripcionController.text = widget.producto!.descripcion;
      precioController.text      = widget.producto!.precio.toString();
      stockController.text       = widget.producto!.stock.toString();
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    descripcionController.dispose();
    precioController.dispose();
    stockController.dispose();
    super.dispose();
  }

  Future<void> guardarProducto() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => cargando = true);

    Map<String, dynamic> respuesta;
    if (!esEdicion) {
      respuesta = await ApiService.crearProducto(
        nombre:      nombreController.text,
        descripcion: descripcionController.text,
        precio:      precioController.text,
        stock:       stockController.text,
        usuarioId:   widget.usuario.id,
      );
    } else {
      respuesta = await ApiService.actualizarProducto(
        id:          widget.producto!.id,
        nombre:      nombreController.text,
        descripcion: descripcionController.text,
        precio:      precioController.text,
        stock:       stockController.text,
      );
    }

    setState(() => cargando = false);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(respuesta['message'] ?? '')),
    );
    if (respuesta['success'] == true) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        title: Text(esEdicion ? 'Editar producto' : 'Nuevo producto'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.inventory_2_outlined,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        esEdicion
                            ? 'Modificá los datos del producto'
                            : 'Completá los datos del nuevo producto',
                        style: GoogleFonts.poppins(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                _fieldLabel('Nombre *'),
                const SizedBox(height: 8),
                CustomTextField(
                  etiqueta: 'Nombre del producto',
                  controlador: nombreController,
                  validador: (v) =>
                      (v == null || v.isEmpty) ? 'Requerido' : null,
                ),
                const SizedBox(height: 20),

                _fieldLabel('Descripción'),
                const SizedBox(height: 8),
                CustomTextField(
                  etiqueta: 'Descripción (opcional)',
                  controlador: descripcionController,
                  maxLineas: 3,
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _fieldLabel('Precio *'),
                          const SizedBox(height: 8),
                          CustomTextField(
                            etiqueta: 'Ej: 25.00',
                            controlador: precioController,
                            tipoTeclado: const TextInputType.numberWithOptions(decimal: true),
                            validador: (v) {
                              if (v == null || v.isEmpty) return 'Requerido';
                              if (double.tryParse(v) == null) return 'Inválido';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _fieldLabel('Stock *'),
                          const SizedBox(height: 8),
                          CustomTextField(
                            etiqueta: 'Ej: 10',
                            controlador: stockController,
                            tipoTeclado: TextInputType.number,
                            validador: (v) {
                              if (v == null || v.isEmpty) return 'Requerido';
                              if (int.tryParse(v) == null) return 'Inválido';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36),

                CustomButton(
                  texto: esEdicion ? 'Actualizar producto' : 'Guardar producto',
                  onPressed: guardarProducto,
                  cargando: cargando,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) => Text(
        text,
        style: GoogleFonts.poppins(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      );
}
