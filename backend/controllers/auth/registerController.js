const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const db = require('../../database');
const { v4: uuidv4 } = require('uuid');
const { 
  JWT_SECRET, 
  ACCESS_TOKEN_EXPIRES_IN = '15m',
  REFRESH_TOKEN_EXPIRES_IN = '7d'
} = process.env;

async function register(req, res) {
  try {
    const { email, password, role } = req.body;
    let { province, qrcode } = req.body;
    
    // Validate basic input
    if (!email || !password || !role) {
      return res.status(400).json({
        status: 'error',
        message: 'Email, password and role are required'
      });
    }

    // Validate role-specific fields
    if (role === 'planter') {
      if (!province) {  //(!province || !qrcode)
        return res.status(400).json({
          status: 'error',
          message: 'Province and qrcode are required for planter role'
        });
      }
    } else {
      // Clear planter-specific fields for non-planter roles
      province = null;
      qrcode = null;
    }

    // Check if user exists
    const { rows: existingUsers } = await db.query(
      'SELECT id FROM users WHERE email = $1', 
      [email]
    );
    
    if (existingUsers.length > 0) {
      return res.status(409).json({
        status: 'error',
        message: 'Email already registered'
      });
    }

    // Hash password and generate ID
    const hashedPassword = await bcrypt.hash(password, 12);
    const id = uuidv4();

    // Generate tokens
    const accessToken = jwt.sign(
      { id, email, role, province },
      JWT_SECRET,
      { expiresIn: ACCESS_TOKEN_EXPIRES_IN }
    );

    const refreshToken = jwt.sign(
      { id, email, role, province },
      JWT_SECRET,
      { expiresIn: REFRESH_TOKEN_EXPIRES_IN }
    );

    // Create user in database
    const { rows: [newUser] } = await db.query(
      `INSERT INTO users 
       (id, email, password, role, province, qrcode, refresh_token) 
       VALUES ($1, $2, $3, $4, $5, $6, $7) 
       RETURNING id, email, role, province, qrcode, planter_id, created_at`,
      [id, email, hashedPassword, role, province, qrcode, refreshToken]
    );

    // Set secure cookies
    const cookieOptions = {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'strict'
    };

    res.cookie('accessToken', accessToken, {
      ...cookieOptions,
      maxAge: 15 * 60 * 1000 // 15 minutes
    });

    res.cookie('refreshToken', refreshToken, {
      ...cookieOptions,
      maxAge: 7 * 24 * 60 * 60 * 1000 // 7 days
    });

    // Prepare response data
    const responseData = {
      status: 'success',
      data: {
        user: {
          id: newUser.id,
          email: newUser.email,
          role: newUser.role,
          created_at: newUser.created_at
        },
        tokens: {
          access_token: accessToken,
          expires_in: ACCESS_TOKEN_EXPIRES_IN
        }
      }
    };

    // Add planter-specific fields if role is planter
    if (role === 'planter') {
      responseData.data.user.province = newUser.province;
      responseData.data.user.qrcode = newUser.qrcode;
      responseData.data.user.planter_id = newUser.planter_id;
    }

    res.status(201).json(responseData);

  } catch (err) {
    console.error('Registration error:', err);
    
    // Handle specific errors
    if (err.code === '23505') { // Unique violation
      return res.status(409).json({
        status: 'error',
        message: 'Email already registered'
      });
    }

    res.status(500).json({
      status: 'error',
      message: 'Internal server error during registration'
    });
  }
}

module.exports = register;