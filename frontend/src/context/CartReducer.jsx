export const initialState = {
    carrito: []
};

export function cartReducer(state, action) {

    switch (action.type) {

        case 'AGREGAR':

            return {
                ...state,
                carrito: [...state.carrito, action.payload]
            };

        case 'ELIMINAR':

            return {
                ...state,
                carrito: state.carrito.filter(
                    p => p.id_producto !== action.payload
                )
            };

        case 'LIMPIAR':

            return {
                ...state,
                carrito: []
            };

        default:
            return state;
    }
}