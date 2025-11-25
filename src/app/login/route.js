// src/app/api/login/route.js
import { NextResponse } from 'next/server';

// Obligamos a usar runtime Node (no edge)
export const runtime = 'nodejs';

export async function POST(request) {
  try {
    const body = await request.json();
    const { email, password, role } = body || {};

    console.log('[LOGIN TEST] body recibido:', body);

    if (!email || !password || !role) {
      return NextResponse.json(
        {
          exists: false,
          message: 'Email, contraseña y rol son obligatorios',
        },
        { status: 400 }
      );
    }

    // ✅ Usuario de PRUEBA, sin base de datos
    if (email === 'test@mail' && password === '1234') {
      // Si entra como estudiante o compañía, devolvemos el rol que venga del frontend
      const id = role === 'company' ? 1001 : 1000;

      return NextResponse.json({
        exists: true,
        role,
        id,
        message: 'Login de prueba (sin base de datos)',
      });
    }

    // Por ahora, cualquier otro usuario lo rechazamos para que esté claro
    return NextResponse.json(
      {
        exists: false,
        message: 'Solo se permite el usuario de prueba test@mail / 1234 en este entorno',
      },
      { status: 401 }
    );
  } catch (error) {
    console.error('[LOGIN TEST] Error en /api/login:', error);
    return NextResponse.json(
      {
        message: 'Error interno en el servidor',
        details: String(error?.message || error),
      },
      { status: 500 }
    );
  }
}
