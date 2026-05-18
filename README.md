# Proyecto 2 - Base de Datos | Celtics Store

Este proyecto es una aplicación web full stack enfocada en la gestión de una tienda temática de los Boston Celtics. El sistema permite administrar productos, clientes, ventas e inventario mediante una arquitectura moderna utilizando:

- **Frontend:** React + Vite
- **Backend:** Laravel (PHP)
- **Base de Datos:** PostgreSQL
- **Contenedores:** Docker + Docker Compose
- **Deploy Frontend:** GitHub Pages
- **Deploy Backend:** Railway

---

# 🌐 Enlaces del Proyecto

## Frontend desplegado
https://adairvlz.github.io/proyecto2-bdd/

## Backend desplegado
https://proyecto2-bdd-production.up.railway.app/api/productos

---

# 🚀 Funcionalidades Implementadas

## CRUD de Productos
- Crear productos
- Editar productos
- Eliminar productos
- Listar productos

## CRUD de Clientes
- Crear clientes
- Editar clientes
- Eliminar clientes
- Listar clientes

## Sistema de Carrito
- Agregar productos al carrito
- Contador dinámico de productos

## Reportes
- Productos más vendidos
- Consultas SQL avanzadas

## Backend API REST
- Endpoints desarrollados con Laravel
- Integración con PostgreSQL
- Respuestas JSON

## Testing
- Pruebas básicas con Vitest y React Testing Library

## Validaciones
- Manejo de errores visibles para el usuario
- Validaciones en formularios

---

# 🛠️ Requisitos Previos

Asegúrate de tener instalado:

- Docker
- Docker Compose
- Git
- Node.js (Opcional)
- Composer (Opcional)

---

# 📦 Instalación Local

## 1. Clonar el repositorio

```bash
git clone https://github.com/Adairvlz/proyecto2-bdd
cd proyecto2-bdd
```

---

## 2. Configurar variables de entorno

Entrar a la carpeta backend:

```bash
cd backend
```

Copiar `.env.example` como `.env`

Linux/Mac:
```bash
cp .env.example .env
```

Windows:
Copiar manualmente el archivo `.env.example` y renombrarlo a `.env`.

---

## 3. Configuración del backend Laravel

Dentro del `.env`:

```env
APP_NAME=CelticsStore
APP_ENV=local
APP_KEY=PaCaDhqfSwysDmaXB2ot+mQP38KJIux0KyK8+DhDud0=
APP_DEBUG=true

DB_CONNECTION=pgsql
DB_HOST=db
DB_PORT=5432
DB_DATABASE=celtics_store
DB_USERNAME=proy2
DB_PASSWORD=secret
```

---

## 4. Levantar contenedores

Desde la raíz del proyecto:

```bash
docker compose up -d
```

---

## 5. Instalar dependencias Laravel

```bash
docker compose exec backend composer install
```

---

## 6. Generar APP_KEY

```bash
docker compose exec backend php artisan key:generate
```

---

# 🌐 Acceso Local

## Frontend
```text
http://localhost:5173
```

## Backend Laravel
```text
http://localhost:8000
```

## PostgreSQL
```text
Host: localhost
Puerto: 5433
Usuario: proy2
Contraseña: secret
Base de datos: celtics_store
```

---

# 🗂️ Estructura del Proyecto

```text
/backend
    API Laravel

/frontend
    Aplicación React + Vite

/database
    schema.sql
    seed.sql

/docker-compose.yml
    Configuración de contenedores
```

---

# 🧪 Ejecutar Tests

Entrar a frontend:

```bash
cd frontend
```

Ejecutar tests:

```bash
npm run test
```

---

# 🚀 Deploy

## Frontend - GitHub Pages

Entrar a frontend:

```bash
cd frontend
```

Deploy:

```bash
npm run deploy
```

---

## Backend - Railway

El backend utiliza:

- Laravel
- PostgreSQL
- Dockerfile personalizado

Variables importantes:

```env
DB_CONNECTION=pgsql
DB_HOST=${{Postgres.PGHOST}}
DB_PORT=${{Postgres.PGPORT}}
DB_DATABASE=${{Postgres.PGDATABASE}}

DB_USERNAME=proy2
DB_PASSWORD=secret
```

---

# 📊 Base de Datos

El sistema incluye:

- Productos
- Categorías
- Proveedores
- Clientes
- Usuarios
- Empleados
- Ventas
- Detalle de ventas
- Inventario

Además se implementaron:

- JOINs
- Subconsultas
