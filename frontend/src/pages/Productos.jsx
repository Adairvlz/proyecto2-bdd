import { useEffect, useMemo, useState } from 'react';
import { useCart } from '../context/CartContext';

function Productos() {

    const [productos, setProductos] = useState([]);
    const [nombre, setNombre] = useState('');
    const [precio, setPrecio] = useState('');
    const [stock, setStock] = useState('');
    const [editando, setEditando] = useState(null);
    const [error, setError] = useState('');
    const [mensaje, setMensaje] = useState('');
    const { carrito, dispatch } = useCart();

    const totalCarrito = useMemo(() => {
        return carrito.reduce((total, producto) => {
            return total + Number(producto.precio);
        }, 0);
    }, [carrito]);


    const cargarProductos = async () => {
        const res = await fetch('http://localhost:8000/api/productos');
        const data = await res.json();
        setProductos(data);
    };

    useEffect(() => {
        cargarProductos();
    }, []);

    const guardarProducto = async () => {

        if (!nombre || !precio || !stock) {
            setError('Todos los campos son obligatorios');
            return;
        }

        if (editando) {

            await fetch(`http://localhost:8000/api/productos/${editando}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ nombre, precio, stock })
            });

        } else {

            await fetch('http://localhost:8000/api/productos', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    id_categoria: 1,
                    id_proveedor: 1,
                    nombre,
                    precio,
                    costo: 50,
                    stock
                })
            });

        }

        limpiarFormulario();
        cargarProductos();
        setMensaje('Producto guardado correctamente');
    };

    const editarProducto = (p) => {
        setNombre(p.nombre);
        setPrecio(p.precio);
        setStock(p.stock);
        setEditando(p.id_producto);
    };

    const eliminarProducto = async (id) => {

        if (!confirm('¿Eliminar producto?')) return;

        await fetch(`http://localhost:8000/api/productos/${id}`, {
            method: 'DELETE'
        });

        cargarProductos();
    };

    const limpiarFormulario = () => {
        setNombre('');
        setPrecio('');
        setStock('');
        setEditando(null);
        setError('');
    };

    return (
        <>
            <h2>CRUD de productos</h2>

            {error && <p className="error">{error}</p>}
            {mensaje && <p className="success">{mensaje}</p>}

            <div className="form">

                <input
                    placeholder="Nombre"
                    value={nombre}
                    onChange={e => setNombre(e.target.value)}
                />

                <input
                    placeholder="Precio"
                    value={precio}
                    onChange={e => setPrecio(e.target.value)}
                />

                <input
                    placeholder="Stock"
                    value={stock}
                    onChange={e => setStock(e.target.value)}
                />

                <button onClick={guardarProducto}>
                    {editando ? 'Actualizar' : 'Agregar'}
                </button>

                {editando && (
                    <button onClick={limpiarFormulario}>
                        Cancelar
                    </button>
                )}

            </div>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Producto</th>
                        <th>Precio</th>
                        <th>Stock</th>
                        <th>Acciones</th>
                    </tr>
                </thead>

                <tbody>

                    {productos.map(p => (

                        <tr key={p.id_producto}>

                            <td>{p.id_producto}</td>
                            <td>{p.nombre}</td>
                            <td>Q{p.precio}</td>
                            <td>{p.stock}</td>

                            <td>
                                <button onClick={() => editarProducto(p)}>
                                    Editar
                                </button>

                                <button
                                    className="delete-btn"
                                    onClick={() => eliminarProducto(p.id_producto)}
                                >
                                    Eliminar
                                </button>
                            </td>

                            <td>

                                <button onClick={() => editarProducto(p)}>
                                    Editar
                                </button>

                                <button
                                    className="delete-btn"
                                    onClick={() => eliminarProducto(p.id_producto)}
                                >
                                    Eliminar
                                </button>

                                <button
                                    onClick={() =>
                                        dispatch({
                                            type: 'AGREGAR',
                                            payload: p
                                        })
                                    }
                                >
                                    Carrito
                                </button>

                            </td>

                        </tr>

                    ))}

                </tbody>
            </table>

            <h3>Carrito ({carrito.length})</h3>

            <p>Total del carrito: Q{totalCarrito.toFixed(2)}</p>

            <ul>
                {carrito.map((p, index) => (
                    <li key={index}>
                        {p.nombre} - Q{p.precio}
                    </li>
                ))}
            </ul>
        </>
    );
}

export default Productos;