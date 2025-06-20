const { createClient } = require('@supabase/supabase-js');
const db = require('../../database');  // ปรับ path ตามโปรเจกต์

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

async function register(req, res) {
  const { email, password, role, province, qrcode } = req.body;

  if (!email || !password || !role) {
    return res.status(400).json({ status: 'error', message: 'Missing fields' });
  }

  // สร้าง user ใน Supabase Auth และข้ามการยืนยันอีเมล
  const { data, error } = await supabase.auth.admin.createUser({
    email,
    password,
    email_confirm: true, // ข้ามการยืนยันอีเมล
    user_metadata: {
      role,
      province,
      qrcode
    }
  });

  if (error) {
    console.error('Supabase registration error:', error);
    return res.status(500).json({ status: 'error', message: error.message });
  }

  try {
    // นำ supabase_uid, email, role, province, qrcode ไปเก็บในตาราง users
    const supabaseUid = data.user.id;  // Supabase UID

    const queryText = `
      INSERT INTO users (supabase_uid, email, role, province, qrcode)
      VALUES ($1, $2, $3, $4, $5)
      RETURNING *;
    `;
    const values = [supabaseUid, email, role, province || null, qrcode || null];
    const { rows } = await db.query(queryText, values);

    res.status(201).json({ status: 'success', data: rows[0] });
  } catch (dbError) {
    console.error('DB insert error:', dbError);
    return res.status(500).json({ status: 'error', message: 'Failed to save user data in DB' });
  }
}

module.exports = register;
