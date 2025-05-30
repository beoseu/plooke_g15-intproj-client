const db = require('../../database');

async function logout(req, res) {
  try {
    const refreshToken = req.cookies.refreshToken;

    if (!refreshToken) {
      return res.status(200).json({
        status: 'success',
        message: 'Already logged out'
      });
    }

    await db.query(
      'UPDATE users SET refresh_token = NULL WHERE refresh_token = $1',
      [refreshToken]
    );

    // Clear the HTTP-only cookie
    res.clearCookie('refreshToken', {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'strict'
    });

    res.status(200).json({
      status: 'success',
      message: 'Logged out successfully'
    });

  } catch (err) {
    console.error('Logout error:', err);
    
    // Ensure cookie is cleared even if other operations fail
    res.clearCookie('refreshToken', {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'strict'
    });
    
    res.status(500).json({
      status: 'error',
      message: 'Failed to logout'
    });
  }
}

module.exports = logout;