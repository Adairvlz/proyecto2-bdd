import { useEffect, useState } from 'react';

function Clientes() {
    const [clientes, setClientes] = useState([]);
    const [nombre, setNombre] = useState('');
    const [apellido, setApellido] = useState('');
    const [email, setEmail] = useState('');
    const [telefono, setTelefono] = useState('');
    const [direccion, setDireccion] = useState('');
    const [editando, setEditando] = useState(null);
    const [error, setError] = useState('');
    const [mensaje, setMensaje] = useState('');

    const cargarClientes = async () => {
        const res = await fetch('https://proyecto2-bdd-production.up.railway.app/api/clientes');
        const data = await res.json();
        setClientes(data);
    };

    useEffect(() => {
        cargarClientes();
    }, []);

    const guardarCliente = async () => {
        if (!nombre || !apellido || !email) {
            setError('Nombre, apellido y email son obligatorios');
            return;
        }

        const body = { nombre, apellido, email, telefono, direccion };

        if (editando) {
            await fetch(`http://localhost:8000/api/clientes/${editando}`, {
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

        limpiarFormulario();
        await cargarClientes();
        setMensaje('Cliente guardado correctamente');
    };

    const editarCliente = (c) => {
        setNombre(c.nombre);
        setApellido(c.apellido);
        setEmail(c.email || '');
        setTelefono(c.telefono || '');
        setDireccion(c.direccion || '');
        setEditando(c.id_cliente);
    };

    const eliminarCliente = async (id) => {
        if (!confirm('¿Eliminar cliente?')) return;

        await fetch(`http://localhost:8000/api/clientes/${id}`, {
            method: 'DELETE'
        });

        await cargarClientes();
    };

    const limpiarFormulario = () => {
        setNombre('');
        setApellido('');
        setEmail('');
        setTelefono('');
        setDireccion('');
        setEditando(null);
        setError('');
    };

    return (
        <>
            <h2>CRUD de clientes</h2>

            {error && <p className="error">{error}</p>}
            {mensaje && <p className="success">{mensaje}</p>}

            <div className="form">
                <input placeholder="Nombre" value={nombre} onChange={e => setNombre(e.target.value)} />
                <input placeholder="Apellido" value={apellido} onChange={e => setApellido(e.target.value)} />
                <input placeholder="Email" value={email} onChange={e => setEmail(e.target.value)} />
                <input placeholder="Teléfono" value={telefono} onChange={e => setTelefono(e.target.value)} />
                <input placeholder="Dirección" value={direccion} onChange={e => setDireccion(e.target.value)} />

                <button onClick={guardarCliente}>
                    {editando ? 'Actualizar' : 'Agregar'}
                </button>

                {editando && <button onClick={limpiarFormulario}>Cancelar</button>}
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
                                <button className="delete-btn" onClick={() => eliminarCliente(c.id_cliente)}>
                                    Eliminar
                                </button>
                            </td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </>
    );
}

export default Clientes;