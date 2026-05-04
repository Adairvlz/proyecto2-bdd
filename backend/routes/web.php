<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

// CORS GLOBAL
Route::options('/{any}', function () {
    return response('', 200)
        ->header('Access-Control-Allow-Origin', '*')
        ->header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
        ->header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
})->where('any', '.*');

// JOIN #1 - Historial de ventas
Route::get('/reportes/historial-ventas', function () {
    return DB::select("
        SELECT 
            v.id_venta,
            c.nombre || ' ' || c.apellido AS cliente,
            e.nombre || ' ' || e.apellido AS empleado,
            v.fecha_venta,
            v.metodo_pago,
            v.total
        FROM ventas v
        JOIN clientes c ON v.id_cliente = c.id_cliente
        JOIN empleados e ON v.id_empleado = e.id_empleado
        ORDER BY v.fecha_venta DESC
    ");
});

// JOIN #2 - Detalle de ventas
Route::get('/reportes/detalle-ventas', function () {
    return DB::select("
        SELECT 
            v.id_venta,
            p.nombre AS producto,
            dv.cantidad,
            dv.precio_unitario,
            dv.subtotal,
            v.fecha_venta
        FROM detalle_ventas dv
        JOIN ventas v ON dv.id_venta = v.id_venta
        JOIN productos p ON dv.id_producto = p.id_producto
        ORDER BY v.id_venta
    ");
});

// JOIN #3 - Catálogo administrativo
Route::get('/reportes/catalogo', function () {
    return DB::select("
        SELECT 
            p.id_producto,
            p.nombre AS producto,
            c.nombre AS categoria,
            pr.nombre AS proveedor,
            p.precio,
            p.stock,
            p.activo
        FROM productos p
        JOIN categorias c ON p.id_categoria = c.id_categoria
        JOIN proveedores pr ON p.id_proveedor = pr.id_proveedor
        ORDER BY p.nombre
    ");
});

// SUBQUERY #1 - Productos vendidos
Route::get('/reportes/productos-vendidos', function () {
    return DB::select("
        SELECT 
            p.id_producto,
            p.nombre,
            p.precio,
            p.stock
        FROM productos p
        WHERE p.id_producto IN (
            SELECT dv.id_producto
            FROM detalle_ventas dv
        )
    ");
});

// SUBQUERY #2 - Clientes activos
Route::get('/reportes/clientes-activos', function () {
    return DB::select("
        SELECT 
            c.id_cliente,
            c.nombre,
            c.apellido,
            c.email
        FROM clientes c
        WHERE EXISTS (
            SELECT 1
            FROM ventas v
            WHERE v.id_cliente = c.id_cliente
        )
    ");
});

// GROUP BY + HAVING + agregación
Route::get('/reportes/productos-mas-vendidos', function () {
    return DB::select("
        SELECT 
            p.nombre AS producto,
            SUM(dv.cantidad) AS unidades_vendidas,
            SUM(dv.subtotal) AS total_generado
        FROM detalle_ventas dv
        JOIN productos p ON dv.id_producto = p.id_producto
        GROUP BY p.nombre
        HAVING SUM(dv.cantidad) >= 1
        ORDER BY unidades_vendidas DESC
    ");
});

// CTE WITH
Route::get('/reportes/resumen-clientes', function () {
    return DB::select("
        WITH ventas_cliente AS (
            SELECT 
                c.id_cliente,
                c.nombre || ' ' || c.apellido AS cliente,
                COUNT(v.id_venta) AS cantidad_compras,
                SUM(v.total) AS total_gastado
            FROM clientes c
            JOIN ventas v ON c.id_cliente = v.id_cliente
            GROUP BY c.id_cliente, c.nombre, c.apellido
        )
        SELECT *
        FROM ventas_cliente
        WHERE total_gastado > 300
        ORDER BY total_gastado DESC
    ");
});

// VIEW usada por backend
Route::get('/reportes/vista-ventas', function () {
    return DB::select("
        SELECT *
        FROM vista_reporte_ventas
        ORDER BY fecha_venta DESC
    ");
});

// TRANSACCIÓN con ROLLBACK
Route::post('/ventas/registrar', function (Request $request) {
    try {
        DB::beginTransaction();

        $venta = DB::selectOne("
            INSERT INTO ventas 
            (id_cliente, id_empleado, subtotal, impuesto, total, metodo_pago, estado)
            VALUES 
            (?, ?, ?, ?, ?, ?, 'COMPLETADA')
            RETURNING id_venta
        ", [
            $request->id_cliente ?? 1,
            $request->id_empleado ?? 3,
            899.99,
            108.00,
            1007.99,
            $request->metodo_pago ?? 'Tarjeta'
        ]);

        DB::insert("
            INSERT INTO detalle_ventas 
            (id_venta, id_producto, cantidad, precio_unitario, subtotal)
            VALUES (?, ?, ?, ?, ?)
        ", [
            $venta->id_venta,
            1,
            1,
            899.99,
            899.99
        ]);

        $actualizados = DB::update("
            UPDATE productos
            SET stock = stock - 1
            WHERE id_producto = 1
            AND stock >= 1
        ");

        if ($actualizados === 0) {
            throw new Exception('Stock insuficiente');
        }

        DB::insert("
            INSERT INTO inventario_movimientos
            (id_producto, tipo_movimiento, cantidad, motivo)
            VALUES (?, 'SALIDA', ?, ?)
        ", [
            1,
            1,
            'Venta realizada desde la aplicación'
        ]);

        DB::commit();

        return response()->json([
            'mensaje' => 'Venta registrada correctamente',
            'id_venta' => $venta->id_venta
        ]);

    } catch (Exception $e) {
        DB::rollBack();

        return response()->json([
            'error' => 'No se pudo registrar la venta',
            'detalle' => $e->getMessage()
        ], 500);
    }
});

