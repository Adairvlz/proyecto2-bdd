import { test, expect, vi } from 'vitest';
import { render, screen } from '@testing-library/react';
import Clientes from '../pages/Clientes';

test('muestra CRUD clientes', () => {
    global.fetch = vi.fn(() =>
        Promise.resolve({
            json: () => Promise.resolve([])
        })
    );

    render(<Clientes />);

    expect(screen.getByText(/CRUD de clientes/i)).toBeTruthy();
});