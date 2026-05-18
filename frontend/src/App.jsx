import { Routes, Route, Link } from 'react-router-dom';

import Productos from './pages/Productos';
import Clientes from './pages/Clientes';
import Reportes from './pages/Reportes';
import Dashboard from './pages/Dashboard';

import './App.css';

function App() {
    return (
        <div className="container">

            <h1>
                Panel administrativo - <span>Celtics Store</span>
            </h1>

            <div className="header-line"></div>

            <nav className="tabs">

                <Link to="/">Dashboard</Link>

                <Link to="/productos">
                    Productos
                </Link>

                <Link to="/clientes">
                    Clientes
                </Link>

                <Link to="/reportes">
                    Reportes
                </Link>

            </nav>

            <Routes>

                <Route
                    path="/"
                    element={<Dashboard />}
                />

                <Route
                    path="/productos"
                    element={<Productos />}
                />

                <Route
                    path="/clientes"
                    element={<Clientes />}
                />

                <Route
                    path="/reportes"
                    element={<Reportes />}
                />

            </Routes>

        </div>
    );
}

export default App;