import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/producto_service.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

// Pantalla para editar un producto existente
class EditarProductoScreen extends StatefulWidget {
  final Producto producto;

  const EditarProductoScreen({super.key, required this.producto});

  @override
  State<EditarProductoScreen> createState() => _EditarProductoScreenState();
}

class _EditarProductoScreenState extends State<EditarProductoScreen> {
  final _formKey               = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _precioController;
  late TextEditingController _stockController;
  final ProductoService _productoService = ProductoService();
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    // Prellenar los campos con los datos actuales del producto
    _nombreController      = TextEditingController(text: widget.producto.nombre);
    _descripcionController = TextEditingController(text: widget.producto.descripcion);
    _precioController      = TextEditingController(text: widget.producto.precio.toString());
    _stockController       = TextEditingController(text: widget.producto.stock.toString());
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _actualizarProducto() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);

    final productoActualizado = Producto(
      id:          widget.producto.id,
      nombre:      _nombreController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      precio:      double.parse(_precioController.text),
      stock:       int.parse(_stockController.text),
      usuarioId:   widget.producto.usuarioId,
    );

    final resultado = await _productoService.actualizarProducto(productoActualizado);

    if (!mounted) return;
    setState(() => _cargando = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(resultado['message'] ?? '')),
    );

    if (resultado['success'] == true) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        title: const Text('Editar Producto'),
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  etiqueta: 'Nombre del producto',
                  controlador: _nombreController,
                  validador: (v) => (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  etiqueta: 'Descripción (opcional)',
                  controlador: _descripcionController,
                  maxLineas: 3,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  etiqueta: 'Precio',
                  controlador: _precioController,
                  tipoTeclado: const TextInputType.numberWithOptions(decimal: true),
                  validador: (v) {
                    if (v == null || v.isEmpty) return 'Campo obligatorio';
                    if (double.tryParse(v) == null || double.parse(v) <= 0) return 'Ingresa un precio válido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  etiqueta: 'Stock',
                  controlador: _stockController,
                  tipoTeclado: TextInputType.number,
                  validador: (v) {
                    if (v == null || v.isEmpty) return 'Campo obligatorio';
                    if (int.tryParse(v) == null) return 'Ingresa un número entero';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomButton(
                  texto: 'Actualizar Producto',
                  onPressed: _actualizarProducto,
                  cargando: _cargando,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
