import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto.dart';
import '../models/usuario.dart';

// Clase encargada de centralizar todas las peticiones HTTP al backend
class ApiService {
  // Cambia esta URL según tu entorno local o servidor
  // En emulador Android usar: http://10.0.2.2/appInventario/backend
  static const String baseUrl = 'https://api.ordezio.com';

  // Método para registrar un usuario
  static Future<Map<String, dynamic>> registrarUsuario({
    required String nombre,
    required String correo,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/registro.php'),
      body: {
        'nombre':   nombre,
        'correo':   correo,
        'password': password,
      },
    );
    return jsonDecode(response.body);
  }

  // Método para iniciar sesión
  static Future<Map<String, dynamic>> login({
    required String correo,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login.php'),
      body: {
        'correo':   correo,
        'password': password,
      },
    );
    return jsonDecode(response.body);
  }

  // Método para listar productos
  static Future<List<Producto>> obtenerProductos() async {
    final response = await http.get(
      Uri.parse('$baseUrl/productos/listar.php'),
    );
    final data = jsonDecode(response.body);
    if (data['success'] == true) {
      return (data['productos'] as List)
          .map((item) => Producto.fromJson(item))
          .toList();
    }
    return [];
  }

  // Método para crear producto
  static Future<Map<String, dynamic>> crearProducto({
    required String nombre,
    required String descripcion,
    required String precio,
    required String stock,
    required int usuarioId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/productos/crear.php'),
      body: {
        'nombre':      nombre,
        'descripcion': descripcion,
        'precio':      precio,
        'stock':       stock,
        'usuario_id':  usuarioId.toString(),
      },
    );
    return jsonDecode(response.body);
  }

  // Método para actualizar producto
  static Future<Map<String, dynamic>> actualizarProducto({
    required int id,
    required String nombre,
    required String descripcion,
    required String precio,
    required String stock,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/productos/actualizar.php'),
      body: {
        'id':          id.toString(),
        'nombre':      nombre,
        'descripcion': descripcion,
        'precio':      precio,
        'stock':       stock,
      },
    );
    return jsonDecode(response.body);
  }

  // Método para eliminar producto
  static Future<Map<String, dynamic>> eliminarProducto(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/productos/eliminar.php'),
      body: {'id': id.toString()},
    );
    return jsonDecode(response.body);
  }

  // Convierte el JSON de usuario del login en un objeto Usuario
  static Usuario convertirUsuario(Map<String, dynamic> json) {
    return Usuario.fromJson(json);
  }
}
