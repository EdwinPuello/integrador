# Documentación de la API

Base URL: `http://localhost/appInventario/backend`

> En emulador Android usar `10.0.2.2` en lugar de `localhost`.

Todos los endpoints reciben datos como **form-data** (`application/x-www-form-urlencoded`).

---

## Autenticación

### POST /auth/registro.php
Registra un nuevo usuario.

**Body (form-data):**
| Campo    | Tipo   | Requerido |
|----------|--------|-----------|
| nombre   | string | Sí        |
| correo   | string | Sí        |
| password | string | Sí        |

**Respuesta exitosa:**
```json
{ "success": true, "message": "Usuario registrado correctamente" }
```

---

### POST /auth/login.php
Inicia sesión con correo y contraseña.

**Body (form-data):**
| Campo    | Tipo   | Requerido |
|----------|--------|-----------|
| correo   | string | Sí        |
| password | string | Sí        |

**Respuesta exitosa:**
```json
{
  "success": true,
  "message": "Inicio de sesión correcto",
  "usuario": { "id": 1, "nombre": "Juan Pérez", "correo": "juan@correo.com" }
}
```

---

## Productos

### GET /productos/listar.php
Retorna todos los productos.

**Respuesta exitosa:**
```json
{
  "success": true,
  "productos": [
    { "id": 1, "nombre": "Producto A", "descripcion": "...", "precio": "9.99", "stock": "10", "usuario_id": "1" }
  ]
}
```

---

### POST /productos/crear.php
Crea un nuevo producto.

**Body (form-data):**
| Campo       | Tipo   | Requerido |
|-------------|--------|-----------|
| nombre      | string | Sí        |
| descripcion | string | No        |
| precio      | number | Sí        |
| stock       | int    | Sí        |
| usuario_id  | int    | Sí        |

---

### POST /productos/actualizar.php
Actualiza un producto existente.

**Body (form-data):**
| Campo       | Tipo   | Requerido |
|-------------|--------|-----------|
| id          | int    | Sí        |
| nombre      | string | Sí        |
| descripcion | string | No        |
| precio      | number | Sí        |
| stock       | int    | Sí        |

---

### POST /productos/eliminar.php
Elimina un producto por ID.

**Body (form-data):**
| Campo | Tipo | Requerido |
|-------|------|-----------|
| id    | int  | Sí        |

---

## Respuesta de error (todos los endpoints)
```json
{ "success": false, "message": "Descripción del error" }
```
