<?php
// Este encabezado indica que la respuesta del servidor será en formato JSON
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit;
}

// Datos de conexión a la base de datos
$host      = "localhost";
$usuario   = "root";
$password  = "";
$baseDatos = "app_inventario";

// Se crea la conexión con MySQL
$conexion = new mysqli($host, $usuario, $password, $baseDatos);

// Se valida si hubo error al conectar
if ($conexion->connect_error) {
    echo json_encode([
        "success" => false,
        "message" => "Error de conexión a la base de datos"
    ]);
    exit;
}

// Se define la codificación para evitar problemas con tildes y caracteres especiales
$conexion->set_charset("utf8");
?>
