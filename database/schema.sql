CREATE TABLE usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rol VARCHAR(30) NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE empleados (
    id_empleado SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    puesto VARCHAR(50) NOT NULL,
    fecha_contratacion DATE NOT NULL,

    FOREIGN KEY (id_usuario)
    REFERENCES usuarios(id_usuario)
);

CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(20),
    direccion VARCHAR(200),
    fecha_registro DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE proveedores (
    id_proveedor SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    contacto VARCHAR(100),
    telefono VARCHAR(20),
    email VARCHAR(100),
    direccion VARCHAR(200)
);

CREATE TABLE categorias (
    id_categoria SERIAL PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL UNIQUE,
    descripcion TEXT
);

CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,
    id_categoria INT NOT NULL,
    id_proveedor INT NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    descripcion TEXT,
    talla VARCHAR(20),
    color VARCHAR(50),
    precio NUMERIC(10,2) NOT NULL,
    costo NUMERIC(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    activo BOOLEAN NOT NULL DEFAULT TRUE,

    FOREIGN KEY (id_categoria)
    REFERENCES categorias(id_categoria),

    FOREIGN KEY (id_proveedor)
    REFERENCES proveedores(id_proveedor)
);

CREATE TABLE ventas (
    id_venta SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_empleado INT NOT NULL,
    fecha_venta TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    subtotal NUMERIC(10,2) NOT NULL,
    impuesto NUMERIC(10,2) NOT NULL,
    total NUMERIC(10,2) NOT NULL,
    metodo_pago VARCHAR(40) NOT NULL,
    estado VARCHAR(30) NOT NULL DEFAULT 'COMPLETADA',

    FOREIGN KEY (id_cliente)
    REFERENCES clientes(id_cliente),

    FOREIGN KEY (id_empleado)
    REFERENCES empleados(id_empleado)
);

CREATE TABLE detalle_ventas (
    id_detalle SERIAL PRIMARY KEY,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario NUMERIC(10,2) NOT NULL,
    subtotal NUMERIC(10,2) NOT NULL,

    FOREIGN KEY (id_venta)
    REFERENCES ventas(id_venta),

    FOREIGN KEY (id_producto)
    REFERENCES productos(id_producto)
);

CREATE TABLE inventario_movimientos (
    id_movimiento SERIAL PRIMARY KEY,
    id_producto INT NOT NULL,

    tipo_movimiento VARCHAR(20) NOT NULL
    CHECK (tipo_movimiento IN ('ENTRADA', 'SALIDA', 'AJUSTE')),

    cantidad INT NOT NULL,
    motivo VARCHAR(150) NOT NULL,
    fecha_movimiento TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_producto)
    REFERENCES productos(id_producto)
);

-- =========================================
-- ÍNDICES
-- =========================================

CREATE INDEX idx_productos_nombre
ON productos(nombre);

CREATE INDEX idx_ventas_fecha
ON ventas(fecha_venta);

CREATE INDEX idx_detalle_producto
ON detalle_ventas(id_producto);

CREATE INDEX idx_movimientos_tipo
ON inventario_movimientos(tipo_movimiento);

CREATE VIEW vista_reporte_ventas AS
SELECT 
    v.id_venta,
    c.nombre || ' ' || c.apellido AS cliente,
    e.nombre || ' ' || e.apellido AS empleado,
    v.fecha_venta,
    v.metodo_pago,
    v.total
FROM ventas v
JOIN clientes c ON v.id_cliente = c.id_cliente
JOIN empleados e ON v.id_empleado = e.id_empleado;