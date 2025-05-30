const db = require('../../database');

async function logout(req, res) {
  try {
    const refreshToken = req.cookies.refreshToken;

    if (refreshToken) {
      await db.query(
        'UPDATE users SET refresh_token = NULL WHERE refresh_token = $1',
        [refreshToken]
      );
    }

    // Clear both cookies
    res.clearCookie('accessToken');
    res.clearCookie('refreshToken');

    res.status(200).json({
      status: 'success',
      message: 'Logged out successfully'
    });

  } catch (err) {
    console.error('Logout error:', err);
    res.clearCookie('accessToken');
    res.clearCookie('refreshToken');
    res.status(500).json({
      status: 'error',
      message: 'Failed to logout'
    });
  }
}

module.exports = logout;