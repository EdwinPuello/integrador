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

// Se recibe el id del producto
$id = trim($_POST['id'] ?? '');

// Se valida que venga el id
if ($id === '') {
    echo json_encode([
        "success" => false,
        "message" => "El id del producto es obligatorio"
    ]);
    exit;
}

// Se elimina el producto indicado
$sql  = "DELETE FROM productos WHERE id = ?";
$stmt = $conexion->prepare($sql);
$stmt->bind_param("i", $id);

if ($stmt->execute()) {
    echo json_encode([
        "success" => true,
        "message" => "Producto eliminado correctamente"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "No se pudo eliminar el producto"
    ]);
}
?>
