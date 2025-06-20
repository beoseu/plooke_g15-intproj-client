const { createClient } = require('@supabase/supabase-js');
const db = require('../../database');

const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY);

async function login(req, res) {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        status: "error",
        message: "Email and password are required"
      });
    }

    // Login with Supabase Auth
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password
    });

    if (error) {
      return res.status(401).json({
        status: 'error',
        message: 'Invalid email or password',
        detail: error.message
      });
    }

    const { user, session } = data;

    // Query local DB by supabase_uid
    const { rows } = await db.query('SELECT * FROM users WHERE supabase_uid = $1', [user.id]);

    if (rows.length === 0) {
      return res.status(404).json({
        status: 'error',
        message: 'User not found in local DB'
      });
    }

    const localUser = rows[0];

    // Set cookies
    const cookieOptions = {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'strict'
    };

    res.cookie('accessToken', session.access_token, {
      ...cookieOptions,
      maxAge: 15 * 60 * 1000
    });

    res.cookie('refreshToken', session.refresh_token, {
      ...cookieOptions,
      maxAge: 7 * 24 * 60 * 60 * 1000
    });

    // Response
    res.json({
      status: 'success',
      data: {
        user: {
          supabase_uid: user.id,
          id: localUser.id,
          email: user.email,
          role: localUser.role,
          province: localUser.province,
          qrcode: localUser.qrcode
        },
        tokens: {
          access_token: session.access_token,
          refresh_token: session.refresh_token,
          expires_in: session.expires_in
        }
      }
    });

  } catch (err) {
    console.error("Login error:", err);
    res.status(500).json({
      status: "error",
      message: "Internal server error during login"
    });
  }
}

module.exports = login;
