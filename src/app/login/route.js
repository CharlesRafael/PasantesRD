// src/app/api/login/route.js
import { NextResponse } from 'next/server';
import bcrypt from 'bcryptjs';
import pool from '@/lib/db';

// Obligamos a que este endpoint corra en Node.js, no en Edge
export const runtime = 'nodejs';

export async function POST(request) {
  try {
    const body = await request.json();
    const { email, password, role } = body;

    console.log('🟡 /api/login - Body recibido:', { email, role });

    // Validación básica
    if (!email || !password || !role) {
      return NextResponse.json(
        { message: 'Email, contraseña y rol son obligatorios.' },
        { status: 400 }
      );
    }

    // Elegimos tabla según el rol
    let query = '';
    if (role === 'student') {
      query = 'SELECT id, email, password_hash FROM students WHERE email = ? LIMIT 1';
    } else if (role === 'company') {
      query = 'SELECT id, email, password_hash FROM companies WHERE email = ? LIMIT 1';
    } else {
      return NextResponse.json(
        { message: 'Rol inválido. Debe ser "student" o "company".' },
        { status: 400 }
      );
    }

    const connection = await pool.getConnection();
    try {
      const [rows] = await connection.execute(query, [email]);

      console.log('🟡 /api/login - Filas encontradas:', rows?.length);

      if (!rows || rows.length === 0) {
        return NextResponse.json(
          { exists: false, message: 'Usuario no encontrado.' },
          { status: 404 }
        );
      }

      const user = rows[0];

      if (!user.password_hash) {
        return NextResponse.json(
          { exists: false, message: 'El usuario no tiene contraseña configurada.' },
          { status: 500 }
        );
      }

      const passwordOk = await bcrypt.compare(password, user.password_hash);

      if (!passwordOk) {
        return NextResponse.json(
          { exists: false, message: 'Contraseña incorrecta.' },
          { status: 401 }
        );
      }

      // ✅ Login correcto
      return NextResponse.json({
        exists: true,
        role,
        id: user.id,
      });
    } finally {
      connection.release();
    }
  } catch (err) {
    console.error('💥 ERROR EN /api/login:', err);

    return NextResponse.json(
      {
        message: 'Internal server error en /api/login',
        error: String(err?.message || err),
      },
      { status: 500 }
    );
  }
}
