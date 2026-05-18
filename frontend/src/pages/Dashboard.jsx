import { useAuth } from '../context/AuthContext';

function Dashboard() {
    const { usuario, login, logout } = useAuth();

    return (
        <>
            <h2>Dashboard</h2>

            {usuario ? (
                <>
                    <p>Sesión activa: {usuario.nombre}</p>
                    <p>Rol: {usuario.rol}</p>
                    <button onClick={logout}>Cerrar sesión</button>
                </>
            ) : (
                <>
                    <p>No hay sesión activa.</p>
                    <button onClick={login}>Iniciar sesión</button>
                </>
            )}
        </>
    );
}

export default Dashboard;