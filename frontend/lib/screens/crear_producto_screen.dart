import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/auth_service.dart';
import '../services/producto_service.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

// Pantalla para crear un nuevo producto
class CrearProductoScreen extends StatefulWidget {
  const CrearProductoScreen({super.key});

  @override
  State<CrearProductoScreen> createState() => _CrearProductoScreenState();
}

class _CrearProductoScreenState extends State<CrearProductoScreen> {
  final _formKey           = GlobalKey<FormState>();
  final _nombreController      = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController      = TextEditingController();
  final _stockController       = TextEditingController();
  final ProductoService _productoService = ProductoService();
  final AuthService _authService         = AuthService();
  bool _cargando = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _guardarProducto() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);

    final usuarioId = await _authService.obtenerUsuarioId();
    final nuevoProducto = Producto(
      id:          0,
      nombre:      _nombreController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      precio:      double.parse(_precioController.text),
      stock:       int.parse(_stockController.text),
      usuarioId:   usuarioId,
    );

    final resultado = await _productoService.crearProducto(nuevoProducto);

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
        title: const Text('Nuevo Producto'),
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
                  texto: 'Guardar Producto',
                  onPressed: _guardarProducto,
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
