const bcrypt = require('bcryptjs');
const db = require('../../database');
const { v4: uuidv4 } = require('uuid');

async function register(req, res) {
  try {
    const { email, password, role } = req.body;
    
    const existingUser = await db.query('SELECT * FROM users WHERE email = $1', [email]);
    if (existingUser.rows.length > 0) {
      return res.status(400).json({
        status: 'error',
        message: 'Email already exists'
      });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const id = uuidv4();

    const { rows } = await db.query(
      'INSERT INTO users (id, email, password, role) VALUES ($1, $2, $3, $4) RETURNING id, email, role',
      [id, email, hashedPassword, role || 'user']
    );

    res.status(201).json({
      status: 'success',
      data: rows[0]
    });
  } catch (err) {
    console.error('Registration error:', err);
    res.status(500).json({
      status: 'error',
      message: 'Failed to register user'
    });
  }
}

module.exports = register;