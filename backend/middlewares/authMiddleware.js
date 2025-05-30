const jwt = require('jsonwebtoken');
const { JWT_SECRET } = process.env;

//check authentication  //but cannot use, something wrong with token****
const authenticate = (req, res, next) => {
//   const authHeader = req.headers['authorization'];
//   const token = authHeader && authHeader.split(' ')[1];

//   if (!token) {
//     return res.status(401).json({
//       status: 'error',
//       message: 'No token provided'
//     });
//   }

//   jwt.verify(token, JWT_SECRET, (err, decoded) => {
//     if (err) {
//       return res.status(403).json({
//         status: 'error',
//         message: 'Invalid or expired token'
//       });
//     }

//     req.user = decoded;
//     next();
//   });
};

//check roles
const authorize = (roles = []) => {
  return (req, res, next) => {
    if (!roles.includes(req.user.role)) {
      return res.status(403).json({
        status: 'error',
        message: 'Unauthorized access'
      });
    }
    next();
  };
};

module.exports = { authenticate, authorize };