-- =========================================
-- CREACIÓN DE TABLAS
-- PROYECTO NBA STORE - BOSTON CELTICS
-- ADAIR VELASQUEZ
-- CARNE 24596
-- PostgreSQL
-- =========================================

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

-- =========================================
-- JUSTIFICACIÓN DE ÍNDICES
-- =========================================

/*
idx_productos_nombre:
Permite acelerar búsquedas de productos por nombre
dentro de la tienda.

idx_ventas_fecha:
Optimiza reportes de ventas por rango de fechas,
meses y días.

idx_detalle_producto:
Mejora consultas de productos más vendidos y
estadísticas de ventas.

idx_movimientos_tipo:
Facilita consultas sobre entradas, salidas y ajustes
de inventario.
*/

-- =========================================
-- DATOS DE PRUEBA
-- 25 REGISTROS POR TABLA
-- =========================================

-- USUARIOS

INSERT INTO usuarios (nombre, email, password, rol) VALUES
('Admin 1','admin1@celtics.com','123','ADMIN'),
('Admin 2','admin2@celtics.com','123','ADMIN'),
('Empleado 1','emp1@celtics.com','123','EMPLEADO'),
('Empleado 2','emp2@celtics.com','123','EMPLEADO'),
('Empleado 3','emp3@celtics.com','123','EMPLEADO'),
('Empleado 4','emp4@celtics.com','123','EMPLEADO'),
('Empleado 5','emp5@celtics.com','123','EMPLEADO'),
('Empleado 6','emp6@celtics.com','123','EMPLEADO'),
('Empleado 7','emp7@celtics.com','123','EMPLEADO'),
('Empleado 8','emp8@celtics.com','123','EMPLEADO'),
('Empleado 9','emp9@celtics.com','123','EMPLEADO'),
('Empleado 10','emp10@celtics.com','123','EMPLEADO'),
('Empleado 11','emp11@celtics.com','123','EMPLEADO'),
('Empleado 12','emp12@celtics.com','123','EMPLEADO'),
('Empleado 13','emp13@celtics.com','123','EMPLEADO'),
('Empleado 14','emp14@celtics.com','123','EMPLEADO'),
('Empleado 15','emp15@celtics.com','123','EMPLEADO'),
('Empleado 16','emp16@celtics.com','123','EMPLEADO'),
('Empleado 17','emp17@celtics.com','123','EMPLEADO'),
('Empleado 18','emp18@celtics.com','123','EMPLEADO'),
('Empleado 19','emp19@celtics.com','123','EMPLEADO'),
('Empleado 20','emp20@celtics.com','123','EMPLEADO'),
('Empleado 21','emp21@celtics.com','123','EMPLEADO'),
('Empleado 22','emp22@celtics.com','123','EMPLEADO'),
('Empleado 23','emp23@celtics.com','123','EMPLEADO');

-- EMPLEADOS

INSERT INTO empleados
(id_usuario,nombre,apellido,telefono,puesto,fecha_contratacion)
VALUES
(1,'Juan','Pérez','5551001','Gerente','2025-01-01'),
(2,'Carlos','López','5551002','Supervisor','2025-01-02'),
(3,'Ana','Ramírez','5551003','Cajero','2025-01-03'),
(4,'Luis','Morales','5551004','Vendedor','2025-01-04'),
(5,'Sofía','Castillo','5551005','Vendedor','2025-01-05'),
(6,'Mario','Herrera','5551006','Cajero','2025-01-06'),
(7,'Andrea','Gómez','5551007','Vendedor','2025-01-07'),
(8,'Jorge','Méndez','5551008','Bodega','2025-01-08'),
(9,'Elena','Ruiz','5551009','Vendedor','2025-01-09'),
(10,'Pedro','Silva','5551010','Cajero','2025-01-10'),
(11,'José','Ortiz','5551011','Vendedor','2025-01-11'),
(12,'Diana','Fuentes','5551012','Vendedor','2025-01-12'),
(13,'Pablo','Reyes','5551013','Bodega','2025-01-13'),
(14,'Laura','Vásquez','5551014','Vendedor','2025-01-14'),
(15,'Miguel','León','5551015','Supervisor','2025-01-15'),
(16,'Sara','Navarro','5551016','Cajero','2025-01-16'),
(17,'Ricardo','Aguilar','5551017','Vendedor','2025-01-17'),
(18,'Patricia','Ríos','5551018','Bodega','2025-01-18'),
(19,'Kevin','Estrada','5551019','Vendedor','2025-01-19'),
(20,'Valeria','Cano','5551020','Cajero','2025-01-20'),
(21,'Daniel','Soto','5551021','Vendedor','2025-01-21'),
(22,'Fernanda','Ibarra','5551022','Vendedor','2025-01-22'),
(23,'Oscar','Mejía','5551023','Bodega','2025-01-23'),
(24,'Natalia','Salazar','5551024','Cajero','2025-01-24'),
(25,'Hugo','Martínez','5551025','Vendedor','2025-01-25');

-- CATEGORIAS

INSERT INTO categorias (nombre, descripcion) VALUES
('Jerseys','Uniformes oficiales'),
('Gorras','Gorras oficiales'),
('Sudaderos','Sudaderos NBA'),
('Pelotas','Pelotas oficiales'),
('Pachones','Botellas deportivas'),
('Shorts','Shorts deportivos'),
('Calcetas','Calcetas NBA'),
('Chaquetas','Chaquetas oficiales'),
('Playeras','Playeras casuales'),
('Accesorios','Accesorios varios'),
('Llaveros','Llaveros Celtics'),
('Mochilas','Mochilas deportivas'),
('Banderas','Banderas decorativas'),
('Pulseras','Pulseras deportivas'),
('Posters','Posters oficiales'),
('Tazas','Tazas Celtics'),
('Stickers','Stickers NBA'),
('Bufandas','Bufandas deportivas'),
('Balones mini','Mini balones'),
('Mousepads','Mousepads Celtics'),
('Audífonos','Audífonos temáticos'),
('Pines','Pines coleccionables'),
('Lámparas','Lámparas decorativas'),
('Termos','Termos deportivos'),
('Figuras','Figuras coleccionables');

-- PROVEEDORES

INSERT INTO proveedores
(nombre,contacto,telefono,email,direccion)
VALUES
('Nike','John Smith','5552001','nike@proveedor.com','USA'),
('Adidas','Mary Lee','5552002','adidas@proveedor.com','USA'),
('Wilson','Kevin Hart','5552003','wilson@proveedor.com','USA'),
('Spalding','Luis Diaz','5552004','spalding@proveedor.com','USA'),
('NBA Store','Emma White','5552005','nba@proveedor.com','USA'),
('Fanatics','Mark Stone','5552006','fanatics@proveedor.com','USA'),
('Champion','Ana Torres','5552007','champion@proveedor.com','USA'),
('Puma','Leo Brown','5552008','puma@proveedor.com','USA'),
('Reebok','Laura Kim','5552009','reebok@proveedor.com','USA'),
('Under Armour','Chris Fox','5552010','ua@proveedor.com','USA'),
('Supplier11','A','5552011','a@mail.com','USA'),
('Supplier12','A','5552012','a@mail.com','USA'),
('Supplier13','A','5552013','a@mail.com','USA'),
('Supplier14','A','5552014','a@mail.com','USA'),
('Supplier15','A','5552015','a@mail.com','USA'),
('Supplier16','A','5552016','a@mail.com','USA'),
('Supplier17','A','5552017','a@mail.com','USA'),
('Supplier18','A','5552018','a@mail.com','USA'),
('Supplier19','A','5552019','a@mail.com','USA'),
('Supplier20','A','5552020','a@mail.com','USA'),
('Supplier21','A','5552021','a@mail.com','USA'),
('Supplier22','A','5552022','a@mail.com','USA'),
('Supplier23','A','5552023','a@mail.com','USA'),
('Supplier24','A','5552024','a@mail.com','USA'),
('Supplier25','A','5552025','a@mail.com','USA');

-- PRODUCTOS

INSERT INTO productos
(id_categoria,id_proveedor,nombre,descripcion,talla,color,precio,costo,stock)
VALUES
(1,1,'Jersey Jayson Tatum','Celtics jersey','L','Verde',899.99,500,20),
(1,1,'Jersey Jaylen Brown','Celtics jersey','M','Blanco',899.99,500,18),
(2,2,'Gorra Celtics Classic','Gorra oficial',NULL,'Negro',249.99,120,30),
(3,2,'Sudadero Celtics','Sudadero oficial','XL','Verde',599.99,300,15),
(4,3,'Pelota NBA Celtics','Pelota oficial',NULL,'Naranja',399.99,200,25),
(5,4,'Pachón Celtics','Botella deportiva',NULL,'Verde',149.99,70,40),
(6,5,'Short Celtics','Short deportivo','L','Blanco',349.99,180,22),
(7,6,'Calcetas Celtics','Calcetas NBA','M','Verde',99.99,40,50),
(8,7,'Chaqueta Celtics','Chaqueta premium','XL','Negro',799.99,450,10),
(9,8,'Playera Celtics','Playera casual','M','Gris',199.99,90,35),
(10,9,'Llavero Celtics','Llavero metálico',NULL,'Verde',49.99,20,60),
(11,10,'Mochila Celtics','Mochila oficial',NULL,'Negro',449.99,220,14),
(12,1,'Bandera Celtics','Bandera decorativa',NULL,'Verde',129.99,50,28),
(13,2,'Pulsera Celtics','Pulsera deportiva',NULL,'Verde',39.99,10,80),
(14,3,'Poster Celtics','Poster edición especial',NULL,'Multicolor',79.99,20,45),
(15,4,'Taza Celtics','Taza oficial',NULL,'Blanco',89.99,35,32),
(16,5,'Sticker Celtics','Sticker logo',NULL,'Verde',19.99,5,100),
(17,6,'Bufanda Celtics','Bufanda invierno',NULL,'Verde',159.99,70,17),
(18,7,'Mini balón Celtics','Mini balón NBA',NULL,'Naranja',129.99,60,26),
(19,8,'Mousepad Celtics','Mousepad gamer',NULL,'Negro',79.99,30,44),
(20,9,'Audífonos Celtics','Audífonos inalámbricos',NULL,'Negro',599.99,300,11),
(21,10,'Pin Celtics','Pin coleccionable',NULL,'Verde',29.99,8,95),
(22,1,'Lámpara Celtics','Lámpara LED',NULL,'Verde',299.99,140,13),
(23,2,'Termo Celtics','Termo deportivo',NULL,'Plateado',179.99,85,29),
(24,3,'Figura Tatum','Figura coleccionable',NULL,'Multicolor',499.99,250,8),
(25,4,'Figura Brown','Figura coleccionable',NULL,'Multicolor',499.99,250,8);

-- =========================================
-- CLIENTES
-- =========================================

INSERT INTO clientes (nombre, apellido, email, telefono, direccion) VALUES
('Alejandro','García','alejandro.garcia@mail.com','5553001','Zona 1, Guatemala'),
('María','López','maria.lopez@mail.com','5553002','Zona 2, Guatemala'),
('Carlos','Martínez','carlos.martinez@mail.com','5553003','Zona 3, Guatemala'),
('Sofía','Hernández','sofia.hernandez@mail.com','5553004','Zona 4, Guatemala'),
('Diego','Pérez','diego.perez@mail.com','5553005','Zona 5, Guatemala'),
('Valentina','Rodríguez','valentina.rodriguez@mail.com','5553006','Zona 6, Guatemala'),
('Mateo','Gómez','mateo.gomez@mail.com','5553007','Zona 7, Guatemala'),
('Camila','Díaz','camila.diaz@mail.com','5553008','Zona 8, Guatemala'),
('Sebastián','Morales','sebastian.morales@mail.com','5553009','Zona 9, Guatemala'),
('Isabella','Castillo','isabella.castillo@mail.com','5553010','Zona 10, Guatemala'),
('Daniel','Ramírez','daniel.ramirez@mail.com','5553011','Zona 11, Guatemala'),
('Lucía','Torres','lucia.torres@mail.com','5553012','Zona 12, Guatemala'),
('Andrés','Flores','andres.flores@mail.com','5553013','Zona 13, Guatemala'),
('Fernanda','Rivera','fernanda.rivera@mail.com','5553014','Zona 14, Guatemala'),
('Javier','Ortiz','javier.ortiz@mail.com','5553015','Zona 15, Guatemala'),
('Natalia','Reyes','natalia.reyes@mail.com','5553016','Zona 16, Guatemala'),
('Emilio','Cruz','emilio.cruz@mail.com','5553017','Zona 17, Guatemala'),
('Paula','Mendoza','paula.mendoza@mail.com','5553018','Zona 18, Guatemala'),
('Rodrigo','Vásquez','rodrigo.vasquez@mail.com','5553019','Zona 19, Guatemala'),
('Gabriela','Santos','gabriela.santos@mail.com','5553020','Zona 20, Guatemala'),
('Luis','Aguilar','luis.aguilar@mail.com','5553021','Zona 21, Guatemala'),
('Andrea','Castro','andrea.castro@mail.com','5553022','Zona 22, Guatemala'),
('Pablo','Molina','pablo.molina@mail.com','5553023','Zona 23, Guatemala'),
('Elena','Rojas','elena.rojas@mail.com','5553024','Zona 24, Guatemala'),
('Hugo','Navarro','hugo.navarro@mail.com','5553025','Zona 25, Guatemala');

-- =========================================
-- VENTAS
-- =========================================

INSERT INTO ventas 
(id_cliente, id_empleado, fecha_venta, subtotal, impuesto, total, metodo_pago, estado) VALUES
(1,3,'2026-01-05 10:15:00',1149.98,137.99,1287.97,'Tarjeta','COMPLETADA'),
(2,4,'2026-01-06 11:20:00',399.99,48.00,447.99,'Efectivo','COMPLETADA'),
(3,5,'2026-01-07 12:05:00',749.98,90.00,839.98,'Tarjeta','COMPLETADA'),
(4,6,'2026-01-08 13:30:00',149.99,18.00,167.99,'Efectivo','COMPLETADA'),
(5,7,'2026-01-09 14:45:00',999.98,120.00,1119.98,'Transferencia','COMPLETADA'),
(6,8,'2026-01-10 15:10:00',249.99,30.00,279.99,'Tarjeta','COMPLETADA'),
(7,9,'2026-01-11 16:25:00',599.99,72.00,671.99,'Efectivo','COMPLETADA'),
(8,10,'2026-01-12 17:40:00',199.99,24.00,223.99,'Tarjeta','COMPLETADA'),
(9,11,'2026-01-13 10:00:00',529.98,63.60,593.58,'Transferencia','COMPLETADA'),
(10,12,'2026-01-14 11:35:00',899.99,108.00,1007.99,'Tarjeta','COMPLETADA'),
(11,13,'2026-01-15 12:50:00',179.98,21.60,201.58,'Efectivo','COMPLETADA'),
(12,14,'2026-01-16 13:15:00',349.99,42.00,391.99,'Tarjeta','COMPLETADA'),
(13,15,'2026-01-17 14:20:00',799.99,96.00,895.99,'Transferencia','COMPLETADA'),
(14,16,'2026-01-18 15:35:00',129.99,15.60,145.59,'Efectivo','COMPLETADA'),
(15,17,'2026-01-19 16:50:00',499.99,60.00,559.99,'Tarjeta','COMPLETADA'),
(16,18,'2026-01-20 17:05:00',599.98,72.00,671.98,'Transferencia','COMPLETADA'),
(17,19,'2026-01-21 10:25:00',89.99,10.80,100.79,'Efectivo','COMPLETADA'),
(18,20,'2026-01-22 11:45:00',299.99,36.00,335.99,'Tarjeta','COMPLETADA'),
(19,21,'2026-01-23 12:30:00',249.98,30.00,279.98,'Efectivo','COMPLETADA'),
(20,22,'2026-01-24 13:55:00',499.99,60.00,559.99,'Tarjeta','COMPLETADA'),
(21,23,'2026-01-25 14:10:00',79.99,9.60,89.59,'Efectivo','COMPLETADA'),
(22,24,'2026-01-26 15:25:00',449.99,54.00,503.99,'Transferencia','COMPLETADA'),
(23,25,'2026-01-27 16:40:00',159.99,19.20,179.19,'Tarjeta','COMPLETADA'),
(24,3,'2026-01-28 17:15:00',129.99,15.60,145.59,'Efectivo','COMPLETADA'),
(25,4,'2026-01-29 18:00:00',899.99,108.00,1007.99,'Tarjeta','COMPLETADA');

-- =========================================
-- DETALLE_VENTAS
-- =========================================

INSERT INTO detalle_ventas
(id_venta, id_producto, cantidad, precio_unitario, subtotal) VALUES
(1,1,1,899.99,899.99),
(1,3,1,249.99,249.99),
(2,5,1,399.99,399.99),
(3,4,1,599.99,599.99),
(3,6,1,149.99,149.99),
(4,6,1,149.99,149.99),
(5,2,1,899.99,899.99),
(5,8,1,99.99,99.99),
(6,3,1,249.99,249.99),
(7,4,1,599.99,599.99),
(8,10,1,199.99,199.99),
(9,7,1,349.99,349.99),
(9,17,1,179.99,179.99),
(10,1,1,899.99,899.99),
(11,13,2,39.99,79.98),
(11,16,5,19.99,100.00),
(12,7,1,349.99,349.99),
(13,9,1,799.99,799.99),
(14,18,1,129.99,129.99),
(15,24,1,499.99,499.99),
(16,20,1,599.99,599.99),
(17,15,1,89.99,89.99),
(18,22,1,299.99,299.99),
(19,10,1,199.99,199.99),
(19,11,1,49.99,49.99),
(20,25,1,499.99,499.99),
(21,19,1,79.99,79.99),
(22,12,1,449.99,449.99),
(23,17,1,159.99,159.99),
(24,18,1,129.99,129.99),
(25,2,1,899.99,899.99);

-- =========================================
-- INVENTARIO_MOVIMIENTOS
-- =========================================

INSERT INTO inventario_movimientos
(id_producto, tipo_movimiento, cantidad, motivo, fecha_movimiento) VALUES
(1,'ENTRADA',20,'Compra inicial a proveedor','2026-01-01 08:00:00'),
(2,'ENTRADA',18,'Compra inicial a proveedor','2026-01-01 08:05:00'),
(3,'ENTRADA',30,'Compra inicial a proveedor','2026-01-01 08:10:00'),
(4,'ENTRADA',15,'Compra inicial a proveedor','2026-01-01 08:15:00'),
(5,'ENTRADA',25,'Compra inicial a proveedor','2026-01-01 08:20:00'),
(6,'ENTRADA',40,'Compra inicial a proveedor','2026-01-01 08:25:00'),
(7,'ENTRADA',22,'Compra inicial a proveedor','2026-01-01 08:30:00'),
(8,'ENTRADA',50,'Compra inicial a proveedor','2026-01-01 08:35:00'),
(9,'ENTRADA',10,'Compra inicial a proveedor','2026-01-01 08:40:00'),
(10,'ENTRADA',35,'Compra inicial a proveedor','2026-01-01 08:45:00'),
(11,'ENTRADA',60,'Compra inicial a proveedor','2026-01-01 08:50:00'),
(12,'ENTRADA',14,'Compra inicial a proveedor','2026-01-01 08:55:00'),
(13,'ENTRADA',28,'Compra inicial a proveedor','2026-01-01 09:00:00'),
(14,'ENTRADA',80,'Compra inicial a proveedor','2026-01-01 09:05:00'),
(15,'ENTRADA',45,'Compra inicial a proveedor','2026-01-01 09:10:00'),
(16,'ENTRADA',32,'Compra inicial a proveedor','2026-01-01 09:15:00'),
(17,'ENTRADA',100,'Compra inicial a proveedor','2026-01-01 09:20:00'),
(18,'ENTRADA',17,'Compra inicial a proveedor','2026-01-01 09:25:00'),
(19,'ENTRADA',26,'Compra inicial a proveedor','2026-01-01 09:30:00'),
(20,'ENTRADA',44,'Compra inicial a proveedor','2026-01-01 09:35:00'),
(21,'ENTRADA',11,'Compra inicial a proveedor','2026-01-01 09:40:00'),
(22,'ENTRADA',95,'Compra inicial a proveedor','2026-01-01 09:45:00'),
(23,'ENTRADA',13,'Compra inicial a proveedor','2026-01-01 09:50:00'),
(24,'ENTRADA',29,'Compra inicial a proveedor','2026-01-01 09:55:00'),
(25,'ENTRADA',8,'Compra inicial a proveedor','2026-01-01 10:00:00'),

(1,'SALIDA',1,'Venta realizada','2026-01-05 10:15:00'),
(3,'SALIDA',1,'Venta realizada','2026-01-05 10:15:00'),
(5,'SALIDA',1,'Venta realizada','2026-01-06 11:20:00'),
(4,'SALIDA',1,'Venta realizada','2026-01-07 12:05:00'),
(6,'SALIDA',1,'Venta realizada','2026-01-07 12:05:00'),
(2,'SALIDA',1,'Venta realizada','2026-01-09 14:45:00'),
(8,'SALIDA',1,'Venta realizada','2026-01-09 14:45:00'),
(10,'SALIDA',1,'Venta realizada','2026-01-12 17:40:00'),
(7,'SALIDA',1,'Venta realizada','2026-01-13 10:00:00'),
(17,'SALIDA',1,'Venta realizada','2026-01-13 10:00:00'),

(6,'AJUSTE',-1,'Producto dañado en bodega','2026-01-15 09:00:00'),
(14,'AJUSTE',-2,'Corrección de inventario','2026-01-16 09:00:00'),
(21,'AJUSTE',1,'Reconteo físico positivo','2026-01-17 09:00:00'),
(24,'AJUSTE',-1,'Producto defectuoso','2026-01-18 09:00:00'),
(25,'AJUSTE',-1,'Producto defectuoso','2026-01-19 09:00:00');