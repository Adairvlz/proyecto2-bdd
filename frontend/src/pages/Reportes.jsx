import { useEffect, useState } from 'react';

function Reportes() {
    const [reporte, setReporte] = useState([]);

    const cargarReporte = async () => {
        const res = await fetch('https://proyecto2-bdd-production.up.railway.app/reportes/productos-mas-vendidos');
        const data = await res.json();
        setReporte(data);
    };

    useEffect(() => {
        cargarReporte();
    }, []);

    return (
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
    );
}

export default Reportes;