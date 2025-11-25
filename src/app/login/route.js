// src/app/api/login/route.js

import { NextResponse } from 'next/server';
import bcrypt from 'bcryptjs';
import pool from '../../lib/db';

export const runtime = 'nodejs'; // asegura que corre en Node, no en Edge

export async function POST(req) {
  try {
    const body = await req.json();
    const { email, password, role } = body;

    console.log('📩 /api/login body:', body);

    if (!email || !password || !role) {
      return NextResponse.json(
        { message: 'Faltan datos: email, password o role.', exists: false },
        { status: 400 }
      );
    }

    // role viene desde el front como 'student' o 'company'
    const isStudent = role === 'student';

    const table = isStudent ? 'students' : 'companies';

    // OJO: aquí usamos la columna correcta: password_hash
    const query = `
      SELECT id, email, password_hash
      FROM ${table}
      WHERE email = ?
      LIMIT 1
    `;
    
    console.log('🔍 Ejecutando query login en tabla:', table, 'email:', email);

    const [rows] = await pool.execute(query, [email]);

    if (!rows || rows.length === 0) {
      console.log('❌ Usuario no encontrado en', table, 'con email', email);
      // Importante: el front espera exists=false para mostrar mensaje
      return NextResponse.json(
        { exists: false, message: 'Usuario no encontrado.' },
        { status: 200 }
      );
    }

    const user = rows[0];

    console.log('✅ Usuario encontrado, comparando contraseña...');

    const isPasswordValid = await bcrypt.compare(password, user.password_hash);

    if (!isPasswordValid) {
      console.log('❌ Contraseña incorrecta para usuario', email);
      return NextResponse.json(
        { exists: false, message: 'Contraseña incorrecta.' },
        { status: 200 }
      );
    }

    console.log('✅ Login correcto. ID:', user.id, 'role:', isStudent ? 'student' : 'company');

    // Lo que tu front espera:
    // const { exists, role, id } = response.data;
    return NextResponse.json(
      {
        exists: true,
        role: isStudent ? 'student' : 'company',
        id: user.id,
      },
      { status: 200 }
    );
  } catch (error) {
    console.error('💥 Error en /api/login:', error);
    return NextResponse.json(
      {
        message: 'Error interno en el servidor.',
        error: error.message,
        exists: false,
      },
      { status: 500 }
    );
  }
}
