<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

Route::options('/{any}', function () {
    return response('', 200)
        ->header('Access-Control-Allow-Origin', '*')
        ->header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
        ->header('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With');
})->where('any', '.*');

Route::get('/productos', function () {
    return DB::select("SELECT * FROM productos ORDER BY id_producto LIMIT 25");
});

Route::post('/productos', function (Request $request) {
    DB::insert("
        INSERT INTO productos 
        (id_categoria, id_proveedor, nombre, precio, costo, stock)
        VALUES (?, ?, ?, ?, ?, ?)
    ", [
        $request->id_categoria ?? 1,
        $request->id_proveedor ?? 1,
        $request->nombre,
        $request->precio,
        50,
        $request->stock
    ]);

    return response()->json(['mensaje' => 'Producto creado']);
});

Route::put('/productos/{id}', function (Request $request, $id) {
    DB::update("
        UPDATE productos
        SET nombre = ?, precio = ?, stock = ?
        WHERE id_producto = ?
    ", [
        $request->nombre,
        $request->precio,
        $request->stock,
        $id
    ]);

    return response()->json(['mensaje' => 'Producto actualizado']);
});

Route::delete('/productos/{id}', function ($id) {
    DB::delete("DELETE FROM productos WHERE id_producto = ?", [$id]);
    return response()->json(['mensaje' => 'Producto eliminado']);
});

// CRUD CLIENTES

Route::get('/clientes', function () {
    return DB::select("SELECT * FROM clientes ORDER BY id_cliente");
});

Route::post('/clientes', function (Request $request) {
    DB::insert("
        INSERT INTO clientes 
        (nombre, apellido, email, telefono, direccion)
        VALUES (?, ?, ?, ?, ?)
    ", [
        $request->nombre,
        $request->apellido,
        $request->email,
        $request->telefono,
        $request->direccion
    ]);

    return response()->json(['mensaje' => 'Cliente creado']);
});

Route::put('/clientes/{id}', function (Request $request, $id) {
    DB::update("
        UPDATE clientes
        SET nombre = ?, apellido = ?, email = ?, telefono = ?, direccion = ?
        WHERE id_cliente = ?
    ", [
        $request->nombre,
        $request->apellido,
        $request->email,
        $request->telefono,
        $request->direccion,
        $id
    ]);

    return response()->json(['mensaje' => 'Cliente actualizado']);
});

Route::delete('/clientes/{id}', function ($id) {
    DB::delete("DELETE FROM clientes WHERE id_cliente = ?", [$id]);

    return response()->json(['mensaje' => 'Cliente eliminado']);
});