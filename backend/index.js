require('dotenv').config();
const express = require('express');
const cors = require('cors');
const db = require('./database');
const { getLocations, getLocationById } = require('./controllers/locationsControllers');
const { getPlants, getPlantById } = require('./controllers/plantsController');
const register = require('./controllers/auth/registerController');
const login = require('./controllers/auth/loginController');
const logout = require('./controllers/auth/logoutController');
const cookieParser = require('cookie-parser');
const { authenticate, authorize } = require('./middlewares/authMiddleware');
const getOrderById = require('./controllers/order/getOrderById');
const createOrder = require('./controllers/order/createOrder');
const updateOrder = require('./controllers/order/updateOrder');
const confirmOrder = require('./controllers/order/confirmOrder');
const deleteOrder = require('./controllers/order/deleteOrder');
const getOrders = require('./controllers/order/getOrders');

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

// Locations
app.get('/locations', authenticate, getLocations);
app.get('/locations/:id', authenticate, getLocationById);

// Plants
app.get('/plants', authenticate, getPlants);
app.get('/plants/:id', authenticate, getPlantById);

// Orders
app.get('/orders', authenticate, getOrders);
app.get('/orders/:id', authenticate, getOrderById);
app.post('/orders/create', authenticate, authorize('user'), createOrder);
app.post('/orders/update', authenticate, authorize('user'), updateOrder); // change status to 'inprogress'
app.post('/orders/confirm', authenticate, authorize('planter'), confirmOrder); // change status to 'completed'
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


