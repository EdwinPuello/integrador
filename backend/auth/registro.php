<?php
require_once("../config/conexion.php");

// Se valida que la petición llegue por método POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode([
        "success" => false,
        "message" => "Método no permitido"
    ]);
    exit;
}

// Se reciben los datos enviados desde Flutter o Postman
$nombre   = trim($_POST['nombre']   ?? '');
$correo   = trim($_POST['correo']   ?? '');
$password = trim($_POST['password'] ?? '');

// Se valida que los campos obligatorios no estén vacíos
if ($nombre === '' || $correo === '' || $password === '') {
    echo json_encode([
        "success" => false,
        "message" => "Todos los campos son obligatorios"
    ]);
    exit;
}

// Se verifica si el correo ya existe
$sqlVerificar = "SELECT id FROM usuarios WHERE correo = ?";
$stmtVerificar = $conexion->prepare($sqlVerificar);
$stmtVerificar->bind_param("s", $correo);
$stmtVerificar->execute();
$resultadoVerificar = $stmtVerificar->get_result();

if ($resultadoVerificar->num_rows > 0) {
    echo json_encode([
        "success" => false,
        "message" => "El correo ya está registrado"
    ]);
    exit;
}

// Se encripta la contraseña antes de guardarla
$passwordEncriptado = password_hash($password, PASSWORD_DEFAULT);

// Se inserta el nuevo usuario
$sqlInsertar = "INSERT INTO usuarios (nombre, correo, password) VALUES (?, ?, ?)";
$stmtInsertar = $conexion->prepare($sqlInsertar);
$stmtInsertar->bind_param("sss", $nombre, $correo, $passwordEncriptado);

if ($stmtInsertar->execute()) {
    echo json_encode([
        "success" => true,
        "message" => "Usuario registrado correctamente"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "No se pudo registrar el usuario"
    ]);
}
?>
