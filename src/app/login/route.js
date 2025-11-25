// src/app/api/login/route.js
import { NextResponse } from 'next/server';
import bcrypt from 'bcrypt';
import pool from '@/lib/db.js';

// Forzamos Node.js runtime (bcrypt no funciona en edge)
export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

export async function POST(request) {
  try {
    const body = await request.json();
    const { email, password, role } = body;

    console.log('🔐 LOGIN REQUEST:', { email, role });

    if (!email || !password || !role) {
      return NextResponse.json(
        { message: 'Email, contraseña y rol son requeridos.' },
        { status: 400 }
      );
    }

    // Determinar tabla según el rol
    let tableName;

    if (role === 'student') {
      tableName = 'students';
    } else if (role === 'company') {
      tableName = 'companies';
    } else {
      return NextResponse.json(
        { message: 'Rol inválido.' },
        { status: 400 }
      );
    }

    // Buscar usuario por email
    const [rows] = await pool.execute(
      `SELECT id, email, password_hash FROM ${tableName} WHERE email = ? LIMIT 1`,
      [email]
    );

    console.log('📥 DB RESULT:', rows);

    if (!rows || rows.length === 0) {
      // Mantenemos exists:false para que el frontend muestre el mensaje
      return NextResponse.json(
        { exists: false, message: 'Usuario no encontrado.' },
        { status: 200 }
      );
    }

    const user = rows[0];

    // Comparar contraseña
    const passwordOk = await bcrypt.compare(password, user.password_hash || '');

    if (!passwordOk) {
      return NextResponse.json(
        { exists: false, message: 'Contraseña incorrecta.' },
        { status: 200 }
      );
    }

    // Login correcto
    return NextResponse.json(
      {
        exists: true,
        role,        // 'student' o 'company'
        id: user.id, // ID en la tabla
      },
      { status: 200 }
    );
  } catch (error) {
    console.error('💥 LOGIN API ERROR:', error);
    // Te paso el mensaje para que lo veas en la pantalla de login
    return NextResponse.json(
      {
        message: 'Internal Server Error: ' + (error?.message || 'Error desconocido'),
      },
      { status: 500 }
    );
  }
}
