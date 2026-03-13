# App Gestión de Usuarios y Productos

Aplicación multiplataforma desarrollada con **Flutter** (frontend) y **PHP + MySQL** (backend).

## Demo en vivo

Frontend app web desplegado en Netlify: [https://merry-lokum-f27bd3.netlify.app](https://merry-lokum-f27bd3.netlify.app)

## Estructura del proyecto

```
integrador/
├── frontend/     # Aplicación Flutter (Dart)
├── backend/      # API REST en PHP
├── database/     # Scripts SQL
└── docs/         # Documentación de la API
```

## Tecnologías

| Herramienta     | Uso                          |
|-----------------|------------------------------|
| Flutter / Dart  | Frontend multiplataforma     |
| PHP             | API REST backend             |
| MySQL           | Base de datos                |
| Nginx + PHP-FPM | Servidor web en VPS          |
| Git / GitHub    | Control de versiones         |

## Configuración

### 1. Base de datos
1. Abrir phpMyAdmin.
2. Importar `database/schema.sql`.

### 2. Backend (PHP)

El backend está desplegado en una VPS con Ubuntu 24.04 usando **Nginx + PHP 8.3-FPM + MySQL**.

- API disponible en: `https://api.ordezio.com`
- Archivos servidos desde `/var/www/api/`
- Base de datos: `app_inventario` en MySQL local
- SSL configurado con Let's Encrypt (Certbot)
- phpMyAdmin disponible en: `https://phpmyadmin.ordezio.com`
  - Usuario: `apiuser`
  - Contraseña: `Api@2026#Secure`

Para desarrollo local:
1. Copiar la carpeta `backend/` dentro de `C:/xampp/htdocs/api/`.
2. Ajustar credenciales en `backend/config/conexion.php` si es necesario.

### 3. Frontend (Flutter)
1. Ir a la carpeta `frontend/`.
2. Ejecutar `flutter pub get`.
3. Ejecutar `flutter run -d chrome`.

## Endpoints

Ver documentación completa en [`docs/endpoints.md`](docs/endpoints.md).
