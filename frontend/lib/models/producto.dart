// Modelo de datos para Producto
class Producto {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;
  final int stock;
  final int usuarioId;

  const Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.stock,
    required this.usuarioId,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id:          json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      nombre:      json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      precio:      json['precio'] is double
                     ? json['precio']
                     : double.parse(json['precio'].toString()),
      stock:       json['stock'] is int ? json['stock'] : int.parse(json['stock'].toString()),
      usuarioId:   json['usuario_id'] is int
                     ? json['usuario_id']
                     : int.parse(json['usuario_id'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':          id,
      'nombre':      nombre,
      'descripcion': descripcion,
      'precio':      precio,
      'stock':       stock,
      'usuario_id':  usuarioId,
    };
  }
}
