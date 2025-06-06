require('dotenv').config();
const jwt = require('jsonwebtoken');
const { JWT_SECRET } = process.env;

const authenticate = (req, res, next) => {
  try {
    const authHeader = req.headers['authorization'];
    const accessToken = authHeader && authHeader.split(' ')[1];

    if (!accessToken) {
      return res.status(401).json({
        status: 'error',
        message: 'No access token found in cookies',
        solution: 'Please login first'
      });
    }

    jwt.verify(accessToken, JWT_SECRET, (err, decoded) => {
      if (err) {
        console.error('Token verification error:', {
          error: err.name,
          message: err.message,
          timestamp: new Date().toISOString()
        });

        const errorResponse = {
          status: 'error',
          timestamp: new Date().toISOString()
        };

        if (err.name === 'TokenExpiredError') {
          errorResponse.message = 'Access token expired';
          errorResponse.solution = 'Refresh your token or login again';
          res.clearCookie('accessToken');
          return res.status(401).json(errorResponse);
        }

        errorResponse.message = 'Invalid token';
        errorResponse.solution = 'Please login again';
        return res.status(403).json(errorResponse);
      }

      // ✅ Use uuid instead of id
      if (!decoded.uuid) {
        return res.status(403).json({
          status: 'error',
          message: 'Token missing required user data',
          solution: 'Please login again'
        });
      }

      req.user = {
        uuid: decoded.uuid,
        email: decoded.email,
        role: decoded.role,
        ...(decoded.province && { province: decoded.province })
      };

      next();
    });
  } catch (error) {
    console.error('Authentication middleware error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Internal authentication error'
    });
  }
};

// Authorization middleware stays the same
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
