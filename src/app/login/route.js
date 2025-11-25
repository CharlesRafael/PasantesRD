// src/app/api/login/route.js
import { NextResponse } from 'next/server';

// Usuario de prueba HARDCODEADO
const TEST_USER = {
  email: 'test@mail',
  password: '1234',
  role: 'student', // también podría ser 'company' si quieres probar la vista de empresa
  id: 999,        // ID ficticio
};

export async function POST(request) {
  try {
    const body = await request.json();
    const { email, password, role } = body || {};

    console.log('🟢 PETICIÓN /api/login', { email, role });

    // ✅ Login de prueba SIN base de datos
    if (email === TEST_USER.email && password === TEST_USER.password) {
      // Si el usuario no envía role, usamos el del TEST_USER
      const finalRole = role || TEST_USER.role;

      return NextResponse.json({
        exists: true,
        role: finalRole,
        id: TEST_USER.id,
        message: 'Login de prueba sin base de datos',
        source: 'hardcoded',
      });
    }

    // ❌ Cualquier otra combinación: credenciales inválidas
    return NextResponse.json(
      {
        exists: false,
        message: 'Credenciales inválidas para el usuario de prueba',
      },
      { status: 401 }
    );
  } catch (error) {
    console.error('💥 ERROR EN /api/login (hardcoded):', error);
    return NextResponse.json(
      {
        error: 'Internal Server Error',
        message: error?.message || 'Unknown error',
      },
      { status: 500 }
    );
  }
}
