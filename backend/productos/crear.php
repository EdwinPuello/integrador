<?php
require_once("../config/conexion.php");

// Se valida que la petición sea POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode([
        "success" => false,
        "message" => "Método no permitido"
    ]);
    exit;
}

// Se reciben los datos enviados
$nombre      = trim($_POST['nombre']      ?? '');
$descripcion = trim($_POST['descripcion'] ?? '');
$precio      = trim($_POST['precio']      ?? '');
$stock       = trim($_POST['stock']       ?? '');
$usuarioId   = trim($_POST['usuario_id']  ?? '');

// Se validan los campos requeridos
if ($nombre === '' || $precio === '' || $stock === '' || $usuarioId === '') {
    echo json_encode([
        "success" => false,
        "message" => "Faltan datos obligatorios"
    ]);
    exit;
}

// Se inserta el producto en la base de datos
$sql  = "INSERT INTO productos (nombre, descripcion, precio, stock, usuario_id) VALUES (?, ?, ?, ?, ?)";
$stmt = $conexion->prepare($sql);
$stmt->bind_param("ssdii", $nombre, $descripcion, $precio, $stock, $usuarioId);

if ($stmt->execute()) {
    echo json_encode([
        "success" => true,
        "message" => "Producto creado correctamente"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "No se pudo crear el producto"
    ]);
}
?>
