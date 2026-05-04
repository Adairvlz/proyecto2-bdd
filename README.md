# Proyecto 2 - Base de Datos

Este proyecto es una aplicación web que consta de un backend desarrollado en **Laravel (PHP)**, un frontend construido con **React (Vite)** y una base de datos en **PostgreSQL**. Todo el entorno está preparado y orquestado para ejecutarse fácilmente utilizando **Docker Compose**.

## 🚀 Requisitos Previos

Asegúrate de tener instalado lo siguiente en tu máquina:
- [Docker](https://www.docker.com/products/docker-desktop)
- [Docker Compose](https://docs.docker.com/compose/install/)

*(Nota: Para el desarrollo local también es recomendable tener Node.js y Composer (PHP) si deseas ejecutar comandos fuera de Docker, pero no son estrictamente necesarios para levantar el proyecto).*

## 🛠️ Instalación y Ejecución

Sigue estos pasos para configurar y levantar el entorno de desarrollo:

### 1. Clonar el repositorio
Si aún no lo has hecho, clona el repositorio o entra al directorio del proyecto:
```bash
cd proyecto2-bdd
```

### 2. Configurar las variables de entorno del Backend
Asegúrate de tener un archivo `.env` configurado para el backend (Laravel).
Entra en la carpeta `backend` y haz una copia de `.env.example` llamándolo `.env` si aún no existe.
```bash
cd backend
cp .env.example .env
cd ..
```
*Si estás en Windows (sin Bash), simplemente copia y pega el archivo `.env.example` en la misma carpeta `backend` y renómbralo a `.env`.*

Verifica que tu archivo `.env` del backend tenga la configuración de conexión a la base de datos de PostgreSQL apuntando al contenedor de Docker:
```env
DB_CONNECTION=pgsql
DB_HOST=db
DB_PORT=5432
DB_DATABASE=celtics_store
DB_USERNAME=proy2
DB_PASSWORD=secret
```

### 3. Levantar los contenedores con Docker Compose
Desde la **raíz del proyecto** (donde se encuentra el archivo `docker-compose.yml`), ejecuta el siguiente comando:

```bash
docker compose up -d
```
Este comando descargará las imágenes, configurará la base de datos (ejecutando automáticamente los scripts de la carpeta `database/`) e iniciará los servicios de backend y frontend.

*(Nota: Si quieres ver los logs en la terminal, puedes correr `docker compose up` sin el `-d`).*

### 4. Instalar dependencias del Backend (Si es necesario)
Si es la primera vez que levantas el proyecto y no tienes la carpeta `vendor` dentro de `backend`, instala las dependencias mediante Composer ejecutando este comando dentro del contenedor:

```bash
docker exec -it celtics_backend composer install
```

### 5. Generar la clave de la aplicación Laravel
Si copiaste el archivo `.env.example` por primera vez, necesitarás generar una clave para tu aplicación Laravel:

```bash
docker exec -it celtics_backend php artisan key:generate
```

---

## 🌐 Acceso a la Aplicación

Una vez que los contenedores estén funcionando, puedes acceder a los servicios a través de las siguientes URLs:

- **Frontend (React)**: [http://localhost:5173](http://localhost:5173)
- **Backend (API Laravel)**: [http://localhost:8000](http://localhost:8000)
- **Base de Datos (PostgreSQL)**: Está mapeada al puerto `5433` de tu host, por si deseas conectarte usando herramientas como DBeaver o pgAdmin.
  - **Host**: `localhost`
  - **Puerto**: `5433`
  - **Usuario**: `proy2`
  - **Contraseña**: `secret`
  - **Base de datos**: `celtics_store`

---

## 📦 Estructura del Proyecto

- `/backend`: API REST construida en Laravel.
- `/frontend`: Interfaz de usuario construida con React y Vite.
- `/database`: Scripts de SQL (`schema.sql` y `seed.sql`) que inicializan y pueblan la base de datos de forma automática al levantar el contenedor de PostgreSQL.
- `docker-compose.yml`: Archivo de configuración que orquesta los contenedores (Frontend, Backend y Base de Datos).

## 🛑 Detener la Aplicación
Para detener la ejecución de todos los contenedores sin borrar la información de tu base de datos, ejecuta desde la raíz del proyecto:
```bash
docker compose down
```

Si deseas reiniciar todo desde cero y **eliminar los volúmenes** (esto **borrará toda la base de datos** para que se vuelva a crear la próxima vez que levantes el entorno):
```bash
docker compose down -v
```
