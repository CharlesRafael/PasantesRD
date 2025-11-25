import pool from './db';

export const getCompanyProfileById = async (companyId) => {
  const query = `
    SELECT 
      id, company_name, industry, company_size, description, website, 
      contact_name, contact_position, email, phone, company_logo,
      founded_year, verified, premium_partner,
      created_at, updated_at
    FROM companies 
    WHERE id = ?
  `;
  const [rows] = await pool.execute(query, [companyId]);
  return rows[0] || null;
};

// Update company profile - PRODUCTION READY
export const updateCompanyProfile = async (companyId, updateData) => {
  const fieldMappings = {
    company_name: 'company_name',
    industry: 'industry',
    company_size: 'company_size',
    description: 'description',
    website: 'website',
    contact_name: 'contact_name',
    contact_position: 'contact_position',
    email: 'email',
    phone: 'phone',
    company_logo: 'company_logo',
    founded_year: 'founded_year'
  };

  // Filter out undefined/null values and build dynamic query
  const updates = [];
  const values = [];

  Object.entries(fieldMappings).forEach(([key, column]) => {
    if (updateData[key] !== undefined && updateData[key] !== null) {
      updates.push(`${column} = ?`);
      values.push(updateData[key]);
    }
  });

  // If no valid fields to update, return early
  if (updates.length === 0) {
    return false;
  }

  // Add updated_at and WHERE clause
  updates.push('updated_at = CURRENT_TIMESTAMP');
  values.push(companyId);

  const query = `
    UPDATE companies 
    SET ${updates.join(', ')}
    WHERE id = ?
  `;

  const [result] = await pool.execute(query, values);
  return result.affectedRows > 0;
};

// Company Locations Functions
export const getCompanyLocations = async (companyId) => {
  const query = `
    SELECT id, location_name, address, is_remote, is_primary
    FROM company_locations 
    WHERE company_id = ?
    ORDER BY is_primary DESC, id ASC
  `;
  const [rows] = await pool.execute(query, [companyId]);
  return rows;
};

export const updateCompanyLocations = async (companyId, locations) => {
  const connection = await pool.getConnection();
  
  try {
    await connection.beginTransaction();

    // Delete existing locations
    await connection.execute('DELETE FROM company_locations WHERE company_id = ?', [companyId]);

    // Insert new locations
    for (const location of locations) {
      if (location.name && location.address) { // Basic validation
        await connection.execute(
          `INSERT INTO company_locations (company_id, location_name, address, is_remote, is_primary) 
           VALUES (?, ?, ?, ?, ?)`,
          [
            companyId, 
            location.name, 
            location.address, 
            location.is_remote ? 1 : 0, 
            location.is_primary ? 1 : 0
          ]
        );
      }
    }

    await connection.commit();
    return true;
  } catch (error) {
    await connection.rollback();
    throw error;
  } finally {
    connection.release();
  }
};

// Company Benefits Functions
export const getCompanyBenefits = async (companyId) => {
  const query = `
    SELECT benefit 
    FROM company_benefits 
    WHERE company_id = ?
    ORDER BY id ASC
  `;
  const [rows] = await pool.execute(query, [companyId]);
  return rows.map(row => row.benefit);
};

export const updateCompanyBenefits = async (companyId, benefits) => {
  const connection = await pool.getConnection();
  
  try {
    await connection.beginTransaction();

    // Delete existing benefits
    await connection.execute('DELETE FROM company_benefits WHERE company_id = ?', [companyId]);

    // Insert new benefits
    for (const benefit of benefits) {
      if (benefit && benefit.trim() !== '') { // Basic validation
        await connection.execute(
          'INSERT INTO company_benefits (company_id, benefit) VALUES (?, ?)',
          [companyId, benefit.trim()]
        );
      }
    }

    await connection.commit();
    return true;
  } catch (error) {
    await connection.rollback();
    throw error;
  } finally {
    connection.release();
  }
};

// Company Statistics Functions
export const getCompanyStatistics = async (companyId) => {
  const query = `
    SELECT 
      active_internships,
      conversion_rate,
      rating,
      past_internships
    FROM company_statistics 
    WHERE company_id = ?
  `;
  
  const [rows] = await pool.execute(query, [companyId]);
  
  if (rows.length > 0) {
    return rows[0];
  }
  
  // Return default statistics if none found
  return {
    active_internships: 0,
    conversion_rate: 0,
    rating: 0,
    past_internships: 0
  };
};

// Check if a company email already exists
export const checkCompanyEmailExists = async (email) => {
  const query = 'SELECT id FROM companies WHERE email = ?';
  const [rows] = await pool.execute(query, [email]);
  return rows.length > 0;
};

// Register a new company
export const registerCompany = async (data) => {
  const [
    companyName,
    industry,
    companySize,
    description,
    website,
    contactName,
    contactPosition,
    email,
    phone,
    passwordHash,
    companyLogo
  ] = data;

  const query = `
    INSERT INTO companies (
      company_name,
      industry,
      company_size,
      description,
      website,
      contact_name,
      contact_position,
      email,
      phone,
      password_hash,
      company_logo
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `;

  const [result] = await pool.execute(query, [
    companyName,
    industry,
    companySize,
    description,
    website,
    contactName,
    contactPosition,
    email,
    phone,
    passwordHash,
    companyLogo
  ]);

  return {
    id: result.insertId,
    createdAt: new Date().toISOString()
  };
};

// Get company profile by email (used in benefits & locations APIs)
export const getCompanyProfileByEmail = async (email) => {
  const query = `
    SELECT 
      id, company_name, industry, company_size, description, website, 
      contact_name, contact_position, email, phone, company_logo,
      founded_year, verified, premium_partner,
      created_at, updated_at
    FROM companies 
    WHERE email = ?
  `;
  const [rows] = await pool.execute(query, [email]);
  return rows[0] || null;
};
