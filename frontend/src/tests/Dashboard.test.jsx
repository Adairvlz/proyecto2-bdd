import { test, expect } from 'vitest';
import { render, screen } from '@testing-library/react';
import Dashboard from '../pages/Dashboard';
import { AuthProvider } from '../context/AuthContext';

test('muestra dashboard', () => {
    render(
        <AuthProvider>
            <Dashboard />
        </AuthProvider>
    );

    expect(screen.getByText(/Dashboard/i)).toBeTruthy();
});