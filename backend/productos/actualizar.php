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

// Se reciben los datos necesarios
$id          = trim($_POST['id']          ?? '');
$nombre      = trim($_POST['nombre']      ?? '');
$descripcion = trim($_POST['descripcion'] ?? '');
$precio      = trim($_POST['precio']      ?? '');
$stock       = trim($_POST['stock']       ?? '');

// Se valida que no falten datos esenciales
if ($id === '' || $nombre === '' || $precio === '' || $stock === '') {
    echo json_encode([
        "success" => false,
        "message" => "Faltan datos obligatorios para actualizar"
    ]);
    exit;
}

// Se actualiza el producto
$sql  = "UPDATE productos SET nombre = ?, descripcion = ?, precio = ?, stock = ? WHERE id = ?";
$stmt = $conexion->prepare($sql);
$stmt->bind_param("ssdii", $nombre, $descripcion, $precio, $stock, $id);

if ($stmt->execute()) {
    echo json_encode([
        "success" => true,
        "message" => "Producto actualizado correctamente"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "No se pudo actualizar el producto"
    ]);
}
?>
