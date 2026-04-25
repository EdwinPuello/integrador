import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Servicio encargado de manejar la autenticación de usuarios
class AuthService {
  static const String _baseUrl = 'http://localhost/api';

  // Registra un nuevo usuario en el backend
  Future<Map<String, dynamic>> registrarUsuario({
    required String nombre,
    required String correo,
    required String password,
  }) async {
    try {
      final respuesta = await http.post(
        Uri.parse('$_baseUrl/auth/registro.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nombre': nombre, 'correo': correo, 'password': password}),
      );
      return jsonDecode(respuesta.body);
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión con el servidor'};
    }
  }

  // Inicia sesión y guarda los datos del usuario en almacenamiento local
  Future<Map<String, dynamic>> iniciarSesion({
    required String correo,
    required String password,
  }) async {
    try {
      final respuesta = await http.post(
        Uri.parse('$_baseUrl/auth/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'correo': correo, 'password': password}),
      );
      final datos = jsonDecode(respuesta.body);

      if (datos['success'] == true) {
        await guardarSesion(datos['usuario']);
      }

      return datos;
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión con el servidor'};
    }
  }

  // Guarda los datos de sesión en SharedPreferences
  Future<void> guardarSesion(Map<String, dynamic> usuario) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('usuario_id', usuario['id'] is int
        ? usuario['id']
        : int.parse(usuario['id'].toString()));
    await prefs.setString('usuario_nombre', usuario['nombre'] ?? '');
    await prefs.setString('usuario_correo', usuario['correo'] ?? '');
  }

  // Elimina la sesión guardada
  Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Verifica si hay una sesión activa
  Future<bool> haySesionActiva() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('usuario_id');
  }

  // Obtiene el ID del usuario en sesión
  Future<int> obtenerUsuarioId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('usuario_id') ?? 0;
  }

  // Obtiene el nombre del usuario en sesión
  Future<String> obtenerUsuarioNombre() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('usuario_nombre') ?? '';
  }
}
