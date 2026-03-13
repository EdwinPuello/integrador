import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto.dart';

// Servicio encargado de las operaciones CRUD de productos
class ProductoService {
  static const String _baseUrl = 'http://localhost/api';

  // Obtiene la lista de productos de un usuario
  Future<List<Producto>> listarProductos(int usuarioId) async {
    final respuesta = await http.get(
      Uri.parse('$_baseUrl/productos/listar.php?usuario_id=$usuarioId'),
    );
    final datos = jsonDecode(respuesta.body);

    if (datos['success'] == true) {
      return (datos['data'] as List)
          .map((item) => Producto.fromJson(item))
          .toList();
    }
    return [];
  }

  // Crea un nuevo producto
  Future<Map<String, dynamic>> crearProducto(Producto producto) async {
    try {
      final respuesta = await http.post(
        Uri.parse('$_baseUrl/productos/crear.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(producto.toJson()),
      );
      return jsonDecode(respuesta.body);
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión con el servidor'};
    }
  }

  // Actualiza los datos de un producto existente
  Future<Map<String, dynamic>> actualizarProducto(Producto producto) async {
    try {
      final respuesta = await http.put(
        Uri.parse('$_baseUrl/productos/actualizar.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(producto.toJson()),
      );
      return jsonDecode(respuesta.body);
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión con el servidor'};
    }
  }

  // Elimina un producto por su ID
  Future<Map<String, dynamic>> eliminarProducto(int id) async {
    try {
      final respuesta = await http.delete(
        Uri.parse('$_baseUrl/productos/eliminar.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id}),
      );
      return jsonDecode(respuesta.body);
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión con el servidor'};
    }
  }
}
