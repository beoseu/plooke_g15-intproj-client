require('dotenv').config();
const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

const authenticate = async (req, res, next) => {
  try {
    const accessToken = req.cookies.accessToken;

    if (!accessToken) {
      return res.status(401).json({
        status: 'error',
        message: 'No access token found in cookies',
        solution: 'Please login first'
      });
    }

    // Verify token ผ่าน Supabase Auth
    const { data: { user }, error } = await supabase.auth.getUser(accessToken);

    if (error || !user) {
      return res.status(401).json({
        status: 'error',
        message: 'Invalid or expired access token',
        solution: 'Please login again'
      });
    }

    // กรณีอยากดึงข้อมูล user เพิ่มเติมจาก DB คุณ (ถ้ามี)
    // const { rows } = await db.query('SELECT * FROM users WHERE supabase_uid = $1', [user.id]);
    // const localUser = rows.length > 0 ? rows[0] : null;

    req.user = {
      supabase_uid: user.id,
      email: user.email,
      // role: localUser?.role || user.user_metadata?.role, // ถ้าเก็บ role ใน DB หรือ metadata
      // province: localUser?.province || user.user_metadata?.province,
      // ... หรือจะเพิ่มข้อมูลอื่น ๆ ตามต้องการ
    };

    next();

  } catch (error) {
    console.error('Authentication middleware error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Internal authentication error'
    });
  }
};

// Authorization middleware เดิมยังใช้ได้เหมือนเดิม
const authorize = (roles = []) => {
  if (typeof roles === 'string') roles = [roles];

  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({
        status: 'error',
        message: 'User not authenticated'
      });
    }

    if (roles.length > 0 && !roles.includes(req.user.role)) {
      return res.status(403).json({
        status: 'error',
        message: 'Insufficient permissions'
      });
    }

    next();
  };
};

module.exports = { authenticate, authorize };

