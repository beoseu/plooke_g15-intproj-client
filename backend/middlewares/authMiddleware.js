// require('dotenv').config();
// const jwt = require('jsonwebtoken');
// const { JWT_SECRET } = process.env;

// // Enhanced authentication middleware
// const authenticate = (req, res, next) => {
//   try {
//     // Get token from Authorization header
//     const authHeader = req.headers['authorization'];
    
//     if (!authHeader) {
//       return res.status(401).json({
//         status: 'error',
//         message: 'Authorization header is missing',
//         solution: 'Include: Authorization: Bearer <accessToken> in headers'
//       });
//     }

//     // Extract token
//     const tokenParts = authHeader.split(' ');
//     if (tokenParts.length !== 2 || tokenParts[0] !== 'Bearer') {
//       return res.status(401).json({
//         status: 'error',
//         message: 'Invalid authorization header format',
//         solution: 'Use format: Bearer <accessToken>'
//       });
//     }

//     const accessToken = tokenParts[1];

//     // Verify token
//     jwt.verify(accessToken, JWT_SECRET, (err, decoded) => {
//       if (err) {
//         console.error('Token verification error:', {
//           error: err.name,
//           message: err.message,
//           token: accessToken,
//           timestamp: new Date().toISOString()
//         });

//         const errorResponse = {
//           status: 'error',
//           timestamp: new Date().toISOString()
//         };

//         if (err.name === 'TokenExpiredError') {
//           errorResponse.message = 'Access token expired';
//           errorResponse.solution = 'Refresh your token or login again';
//           return res.status(401).json(errorResponse);
//         }

//         if (err.name === 'JsonWebTokenError') {
//           errorResponse.message = 'Invalid token';
//           errorResponse.solution = 'Verify your token or login again';
//           return res.status(403).json(errorResponse);
//         }

//         errorResponse.message = 'Authentication failed';
//         errorResponse.solution = 'Try logging in again';
//         return res.status(403).json(errorResponse);
//       }

//       // Token is valid
//       console.log('Authenticated user:', {
//         userId: decoded.id,
//         email: decoded.email,
//         role: decoded.role,
//         timestamp: new Date().toISOString()
//       });

//       // Attach user to request
//       req.user = {
//         id: decoded.id,
//         email: decoded.email,
//         role: decoded.role
//       };

//       next();
//     });
//   } catch (error) {
//     console.error('Authentication middleware error:', {
//       error: error.message,
//       stack: error.stack,
//       timestamp: new Date().toISOString()
//     });

//     res.status(500).json({
//       status: 'error',
//       message: 'Internal authentication error',
//       timestamp: new Date().toISOString()
//     });
//   }
// };

// // Enhanced authorization middleware
// const authorize = (roles = []) => {
//   // Convert single role to array for flexibility
//   if (typeof roles === 'string') {
//     roles = [roles];
//   }

//   return (req, res, next) => {
//     try {
//       // Check if user exists (should be attached by authenticate middleware)
//       if (!req.user) {
//         return res.status(401).json({
//           status: 'error',
//           message: 'User not authenticated',
//           timestamp: new Date().toISOString()
//         });
//       }

//       // Check if user has required role
//       if (roles.length > 0 && !roles.includes(req.user.role)) {
//         console.warn('Unauthorized access attempt:', {
//           userId: req.user.id,
//           requiredRoles: roles,
//           userRole: req.user.role,
//           endpoint: req.originalUrl,
//           timestamp: new Date().toISOString()
//         });

//         return res.status(403).json({
//           status: 'error',
//           message: 'Insufficient permissions',
//           requiredRoles: roles,
//           yourRole: req.user.role,
//           timestamp: new Date().toISOString()
//         });
//       }

//       next();
//     } catch (error) {
//       console.error('Authorization middleware error:', {
//         error: error.message,
//         stack: error.stack,
//         timestamp: new Date().toISOString()
//       });

//       res.status(500).json({
//         status: 'error',
//         message: 'Internal authorization error',
//         timestamp: new Date().toISOString()
//       });
//     }
//   };
// };

// module.exports = {
//   authenticate,
//   authorize
// };





require('dotenv').config();
const jwt = require('jsonwebtoken');
const { JWT_SECRET } = process.env;

const authenticate = (req, res, next) => {
  try {
    // Get token from cookie instead of header
    const accessToken = req.cookies.accessToken;
    
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
          // Clear expired cookie
          res.clearCookie('accessToken');
          return res.status(401).json(errorResponse);
        }

        errorResponse.message = 'Invalid token';
        errorResponse.solution = 'Please login again';
        return res.status(403).json(errorResponse);
      }

      req.user = {
        id: decoded.id,
        email: decoded.email,
        role: decoded.role
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

// Authorization middleware remains the same
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