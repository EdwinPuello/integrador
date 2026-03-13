<?php
require_once("../config/conexion.php");

// Consulta todos los productos con sus datos principales
$sql       = "SELECT id, nombre, descripcion, precio, stock, usuario_id FROM productos ORDER BY id DESC";
$resultado = $conexion->query($sql);

$productos = [];

// Se recorren los resultados y se agregan a un arreglo
while ($fila = $resultado->fetch_assoc()) {
    $productos[] = $fila;
}

// Se devuelve la lista en formato JSON
echo json_encode([
    "success"   => true,
    "productos" => $productos
]);
?>
