import { NextResponse } from 'next/server';

export async function POST(req) {
  try {
    const { email, password, role } = await req.json();

    // Validación básica
    if (!email || !password || !role) {
      return NextResponse.json(
        {
          exists: false,
          message: 'Faltan campos: email, contraseña o rol.',
        },
        { status: 400 }
      );
    }

    // 🔹 IDs fijos para pruebas
    // En tu base de datos:
    // - students.id = 13  -> Test Student (test@mail)
    // - companies.id = 1  -> EDAB Software Developer
    let id;

    if (role === 'student') {
      id = 13; // Estudiante de prueba
    } else if (role === 'company') {
      id = 1;  // Empresa de prueba
    } else {
      return NextResponse.json(
        { exists: false, message: 'Rol inválido. Usa "student" o "company".' },
        { status: 400 }
      );
    }

    // ✅ Siempre considera que el usuario existe y la contraseña es correcta
    return NextResponse.json(
      {
        exists: true,
        role,
        id,
      },
      { status: 200 }
    );
  } catch (error) {
    console.error('Error en /api/login:', error);
    return NextResponse.json(
      {
        exists: false,
        message: 'Error interno en el servidor.',
      },
      { status: 500 }
    );
  }
}
