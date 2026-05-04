import { useEffect, useState } from 'react';
import './App.css';

function App() {
    const [vista, setVista] = useState('productos');
    const [error, setError] = useState('');
    const [reporte, setReporte] = useState([]);
    const [mensaje, setMensaje] = useState('');

    // PRODUCTOS
    const [productos, setProductos] = useState([]);
    const [nombre, setNombre] = useState('');
    const [precio, setPrecio] = useState('');
    const [stock, setStock] = useState('');
    const [editando, setEditando] = useState(null);

    // CLIENTES
    const [clientes, setClientes] = useState([]);
    const [clienteNombre, setClienteNombre] = useState('');
    const [clienteApellido, setClienteApellido] = useState('');
    const [clienteEmail, setClienteEmail] = useState('');
    const [clienteTelefono, setClienteTelefono] = useState('');
    const [clienteDireccion, setClienteDireccion] = useState('');
    const [editandoCliente, setEditandoCliente] = useState(null);

    const cargarProductos = async () => {
        const res = await fetch('http://localhost:8000/api/productos');
        const data = await res.json();
        setProductos(data);
    };

    const cargarClientes = async () => {
        const res = await fetch('http://localhost:8000/api/clientes');
        const data = await res.json();
        setClientes(data);
    };

    const cargarReporte = async () => {
        const res = await fetch('http://localhost:8000/reportes/productos-mas-vendidos');
        const data = await res.json();
        setReporte(data);
    };

    useEffect(() => {
        if (vista === 'productos') cargarProductos();
        if (vista === 'clientes') cargarClientes();
        if (vista === 'reportes') cargarReporte();
    }, [vista]);

    const guardarProducto = async () => {
        if (!nombre || !precio || !stock) {
            setError('Todos los campos del producto son obligatorios');
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
                body: JSON.stringify({ id_categoria: 1, id_proveedor: 1, nombre, precio, costo: 50, stock })
            });
        }

        limpiarProducto();
        await cargarProductos();
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
        await fetch(`http://localhost:8000/api/productos/${id}`, { method: 'DELETE' });
        await cargarProductos();
    };

    const limpiarProducto = () => {
        setNombre('');
        setPrecio('');
        setStock('');
        setEditando(null);
        setError('');
    };

    const guardarCliente = async () => {
        if (!clienteNombre || !clienteApellido || !clienteEmail) {
            setError('Nombre, apellido y email del cliente son obligatorios');
            return;
        }

        const body = {
            nombre: clienteNombre,
            apellido: clienteApellido,
            email: clienteEmail,
            telefono: clienteTelefono,
            direccion: clienteDireccion
        };

        if (editandoCliente) {
            await fetch(`http://localhost:8000/api/clientes/${editandoCliente}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(body)
            });
        } else {
            await fetch('http://localhost:8000/api/clientes', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(body)
            });
        }

        limpiarCliente();
        await cargarClientes();
    };

    const editarCliente = (c) => {
        setClienteNombre(c.nombre);
        setClienteApellido(c.apellido);
        setClienteEmail(c.email || '');
        setClienteTelefono(c.telefono || '');
        setClienteDireccion(c.direccion || '');
        setEditandoCliente(c.id_cliente);
    };

    const eliminarCliente = async (id) => {
        if (!confirm('¿Eliminar cliente?')) return;
        await fetch(`http://localhost:8000/api/clientes/${id}`, { method: 'DELETE' });
        await cargarClientes();
    };

    const limpiarCliente = () => {
        setClienteNombre('');
        setClienteApellido('');
        setClienteEmail('');
        setClienteTelefono('');
        setClienteDireccion('');
        setEditandoCliente(null);
        setError('');
    };

    return (
        <div className="container">
            <h1>Panel administrativo - <span>Celtics Store</span></h1>
            <div className="header-line"></div>

            <div className="tabs">
                <button onClick={() => setVista('productos')}>Productos</button>
                <button onClick={() => setVista('clientes')}>Clientes</button>
                <button onClick={() => setVista('reportes')}>Reportes</button>
            </div>

            {error && <p className="error">{error}</p>}
            {mensaje && <p className="success">{mensaje}</p>}

            {vista === 'productos' && (
                <>
                    <h2>CRUD de productos</h2>

                    <div className="form">
                        <input placeholder="Nombre" value={nombre} onChange={e => setNombre(e.target.value)} />
                        <input placeholder="Precio" value={precio} onChange={e => setPrecio(e.target.value)} />
                        <input placeholder="Stock" value={stock} onChange={e => setStock(e.target.value)} />

                        <button onClick={guardarProducto}>{editando ? 'Actualizar' : 'Agregar'}</button>
                        {editando && <button onClick={limpiarProducto}>Cancelar</button>}
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
                                        <button onClick={() => editarProducto(p)}>Editar</button>
                                        <button className="delete-btn" onClick={() => eliminarProducto(p.id_producto)}>Eliminar</button>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </>
            )}

            {vista === 'clientes' && (
                <>
                    <h2>CRUD de clientes</h2>

                    <div className="form">
                        <input placeholder="Nombre" value={clienteNombre} onChange={e => setClienteNombre(e.target.value)} />
                        <input placeholder="Apellido" value={clienteApellido} onChange={e => setClienteApellido(e.target.value)} />
                        <input placeholder="Email" value={clienteEmail} onChange={e => setClienteEmail(e.target.value)} />
                        <input placeholder="Teléfono" value={clienteTelefono} onChange={e => setClienteTelefono(e.target.value)} />
                        <input placeholder="Dirección" value={clienteDireccion} onChange={e => setClienteDireccion(e.target.value)} />

                        <button onClick={guardarCliente}>{editandoCliente ? 'Actualizar' : 'Agregar'}</button>
                        {editandoCliente && <button onClick={limpiarCliente}>Cancelar</button>}
                    </div>

                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nombre</th>
                                <th>Apellido</th>
                                <th>Email</th>
                                <th>Teléfono</th>
                                <th>Dirección</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            {clientes.map(c => (
                                <tr key={c.id_cliente}>
                                    <td>{c.id_cliente}</td>
                                    <td>{c.nombre}</td>
                                    <td>{c.apellido}</td>
                                    <td>{c.email}</td>
                                    <td>{c.telefono}</td>
                                    <td>{c.direccion}</td>
                                    <td>
                                        <button onClick={() => editarCliente(c)}>Editar</button>
                                        <button className="delete-btn" onClick={() => eliminarCliente(c.id_cliente)}>Eliminar</button>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </>
            )}

            {vista === 'reportes' && (
                <>
                    <h2>Reporte: Productos más vendidos</h2>

                    <table>
                        <thead>
                            <tr>
                                <th>Producto</th>
                                <th>Unidades vendidas</th>
                                <th>Total generado</th>
                            </tr>
                        </thead>
                        <tbody>
                            {reporte.map((r, index) => (
                                <tr key={index}>
                                    <td>{r.producto}</td>
                                    <td>{r.unidades_vendidas}</td>
                                    <td>Q{r.total_generado}</td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </>
            )}
        </div>
    );
}

export default App;