const express = require('express');
const cors = require('cors');
const db = require('./database');
const { getLocations, getLocationById } = require('./controllers/locationsControllers');
const { getPlants, getPlantById } = require('./controllers/plantsController');
const { getOrders, getOrderById } = require('./controllers/ordersController');
const register = require('./controllers/auth/registerController');
const login = require('./controllers/auth/loginController');
const logout = require('./controllers/auth/logoutController');
const cookieParser = require('cookie-parser');
const { authenticate, authorize } = require('./middlewares/authMiddleware');


const app = express();
const PORT = 3000;
app.use(cookieParser());
app.use(cors());
app.use(express.json());
app.use(cookieParser());

app.post('/register', register);
app.post('/login', login);
app.post('/logout', logout);

app.get('/', (req, res) => {
  res.send('PostgreSQL + Express API is running');
});

app.get('/locations', getLocations);
app.get('/locations/:id', getLocationById);
app.get('/plants', getPlants);
app.get('/plants/:id', getPlantById);
app.get('/orders', getOrders);
app.get('/orders/:id', getOrderById);


// Error Handling
app.use((req, res) => {
  res.status(404).json({
    status: 'error',
    message: 'Route not found'
  });
});

app.use((err, req, res, next) => {
  console.error('Unhandled error:', err);
  res.status(500).json({ 
    status: 'error',
    message: 'Internal server error' 
  });
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM received. Closing DB connection...');
  db.end()
    .then(() => {
      console.log('DB connection closed');
      process.exit(0);
    })
    .catch(err => {
      console.error('Failed to close DB connection:', err);
      process.exit(1);
    });
});

const server = app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});

process.on('unhandledRejection', (err) => {
  console.error('Unhandled Rejection:', err);
  server.close(() => process.exit(1));
});


