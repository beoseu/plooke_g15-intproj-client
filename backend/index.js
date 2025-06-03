require('dotenv').config();
const express = require('express');
const cors = require('cors');
const db = require('./database');
const { getLocations, getLocationById } = require('./controllers/locationsControllers');
const { getPlants, getPlantById } = require('./controllers/plantsController');
const { getOrders, createOrder, deleteOrder } = require('./controllers/ordersController');
const register = require('./controllers/auth/registerController');
const login = require('./controllers/auth/loginController');
const logout = require('./controllers/auth/logoutController');
const cookieParser = require('cookie-parser');
const { authenticate } = require('./middlewares/authMiddleware');

const app = express();
const PORT = 3000;

app.use(cookieParser());

const corsOptions = {
  origin: true, 
  credentials: true, 
  exposedHeaders: ['set-cookie'] 
};
app.use(cors(corsOptions));

app.use(express.json());
app.use(cookieParser());

app.post('/register', register);
app.post('/login', login);
app.post('/logout', logout);

app.get('/', (req, res) => {
  res.send('PostgreSQL + Express API is running');
});

app.get('/locations', authenticate, getLocations);
app.get('/locations/:id', authenticate, getLocationById);
app.get('/plants', authenticate, getPlants);
app.get('/plants/:id', authenticate, getPlantById);
app.get('/orders', authenticate, getOrders);
app.post('/createOrder', authenticate, createOrder);
app.delete('/orders/:id', authenticate, deleteOrder);

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


