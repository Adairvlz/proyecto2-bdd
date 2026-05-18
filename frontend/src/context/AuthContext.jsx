import { createContext, useContext, useState } from 'react';

const AuthContext = createContext();

export function AuthProvider({ children }) {
    const [usuario, setUsuario] = useState({
        nombre: 'Administrador Celtics',
        rol: 'admin'
    });

    const logout = () => {
        setUsuario(null);
    };

    const login = () => {
        setUsuario({
            nombre: 'Administrador Celtics',
            rol: 'admin'
        });
    };

    return (
        <AuthContext.Provider value={{ usuario, login, logout }}>
            {children}
        </AuthContext.Provider>
    );
}

export function useAuth() {
    return useContext(AuthContext);
}