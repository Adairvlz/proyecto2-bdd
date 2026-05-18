import { test, expect, vi } from 'vitest';
import { render, screen } from '@testing-library/react';
import Productos from '../pages/Productos';
import { CartProvider } from '../context/CartContext';

test('muestra CRUD productos', () => {
    global.fetch = vi.fn(() =>
        Promise.resolve({
            json: () => Promise.resolve([])
        })
    );

    render(
        <CartProvider>
            <Productos />
        </CartProvider>
    );

    expect(screen.getByText(/CRUD de productos/i)).toBeTruthy();
});