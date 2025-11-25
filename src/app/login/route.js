// src/app/api/login/route.js
import { NextResponse } from 'next/server';
import bcrypt from 'bcrypt';
import pool from '@/lib/db.js';

// Forzamos Node.js runtime (bcrypt no funciona en edge)
export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

const TEST_EMAIL = 'test@mail';
const TEST_PASSWORD = '1234';

// Ajusta estos IDs si cambian en tu base
const TEST_STUDENT_ID = 13; // ID de Test Student en `students`
const TEST_COMPANY_ID = 1;  // ID de alguna empresa demo en `companies`

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

    // 🧪 BYPASS DE DEMO: usuario hardcodeado en código
    if (email === TEST_EMAIL && password === TEST_PASSWORD) {
      console.log('✅ DEMO LOGIN BYPASS ACTIVADO');

      const demoId = role === 'student' ? TEST_STUDENT_ID : TEST_COMPANY_ID;

      return NextResponse.json(
        {
          exists: true,
          role,     // 'student' o 'company'
          id: demoId,
          demoUser: true,
        },
        { status: 200 }
      );
    }

    // 👉 Si no es el usuario de demo, usamos base de datos normal

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
      return NextResponse.json(
        { exists: false, message: 'Usuario no encontrado.' },
        { status: 200 }
      );
    }

    const user = rows[0];

    // Comparar contraseña contra el hash guardado
    const passwordOk = await bcrypt.compare(password, user.password_hash || '');

    if (!passwordOk) {
      return NextResponse.json(
        { exists: false, message: 'Contraseña incorrecta.' },
        { status: 200 }
      );
    }

    // Login correcto con base de datos
    return NextResponse.json(
      {
        exists: true,
        role,
        id: user.id,
      },
      { status: 200 }
    );
  } catch (error) {
    console.error('💥 LOGIN API ERROR:', error);
    return NextResponse.json(
      {
        message:
          'Internal Server Error: ' + (error?.message || 'Error desconocido'),
      },
      { status: 500 }
    );
  }
}
