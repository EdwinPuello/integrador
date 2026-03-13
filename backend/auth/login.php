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

// Se capturan los datos enviados por el cliente
$correo   = trim($_POST['correo']   ?? '');
$password = trim($_POST['password'] ?? '');

// Se valida que ambos campos estén presentes
if ($correo === '' || $password === '') {
    echo json_encode([
        "success" => false,
        "message" => "Correo y contraseña son obligatorios"
    ]);
    exit;
}

// Se consulta el usuario por correo
$sql  = "SELECT id, nombre, correo, password FROM usuarios WHERE correo = ?";
$stmt = $conexion->prepare($sql);
$stmt->bind_param("s", $correo);
$stmt->execute();
$resultado = $stmt->get_result();

// Se valida si el usuario existe
if ($resultado->num_rows === 0) {
    echo json_encode([
        "success" => false,
        "message" => "Usuario no encontrado"
    ]);
    exit;
}

$usuario = $resultado->fetch_assoc();

// Se compara la contraseña enviada con la contraseña encriptada guardada
if (password_verify($password, $usuario['password'])) {
    echo json_encode([
        "success" => true,
        "message" => "Inicio de sesión correcto",
        "usuario" => [
            "id"     => $usuario['id'],
            "nombre" => $usuario['nombre'],
            "correo" => $usuario['correo']
        ]
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Contraseña incorrecta"
    ]);
}
?>
