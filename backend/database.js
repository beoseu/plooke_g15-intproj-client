// require('dotenv').config();
// const { Pool } = require('pg');

// const requiredEnvVars = ['DB_HOST', 'DB_USER', 'DB_PORT', 'DB_PASSWORD', 'DB_NAME'];
// for (const envVar of requiredEnvVars) {
//   if (!process.env[envVar]) {
//     throw new Error(`Missing required environment variable: ${envVar}`);
//   }
// }

// const pool = new Pool({
//   host: process.env.DB_HOST,
//   user: process.env.DB_USER,
//   port: parseInt(process.env.DB_PORT, 10),
//   password: process.env.DB_PASSWORD,
//   database: process.env.DB_NAME,
//   //for security and performance
//   ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: true } : false,
//   connectionTimeoutMillis: 5000, 
//   idleTimeoutMillis: 30000,
//   max: 20
// });

// pool.on('connect', () => {
//   console.log('New client connected to the database');
// });

// pool.on('error', (err) => {
//   console.error('Unexpected error on idle client', err);
//   process.exit(-1);
// });

// //test connection function
// async function testConnection() {
//   try {
//     const client = await pool.connect();
//     console.log('Successfully connected to PostgreSQL database');
//     client.release();
//   } catch (err) {
//     console.error('Database connection error:', err);
//     process.exit(1);
//   }
// }

// testConnection();

// module.exports = {
//   query: (text, params) => {
//     console.log('Executing query:', text);
//     return pool.query(text, params);
//   },
//   end: () => pool.end(),
//   pool: pool,
//   getClient: async () => {
//     const client = await pool.connect();
//     return client;
//   }
// };






// require('dotenv').config();
// const { Pool } = require('pg');

// if (!process.env.DATABASE_URL) {
//   throw new Error('Missing required environment variable: DATABASE_URL');
// }

// const pool = new Pool({
//   connectionString: process.env.DATABASE_URL,
//   ssl: {
//     rejectUnauthorized: false // สำหรับเชื่อมกับ Supabase
//   },
//   connectionTimeoutMillis: 5000,
//   idleTimeoutMillis: 30000,
//   max: 20,
// });

// pool.on('connect', () => {
//   console.log('New client connected to the database');
// });

// pool.on('error', (err) => {
//   console.error('Unexpected error on idle client', err);
//   process.exit(-1);
// });

// async function testConnection() {
//   try {
//     const client = await pool.connect();
//     console.log('Successfully connected to PostgreSQL database');
//     client.release();
//   } catch (err) {
//     console.error('Database connection error:', err);
//     process.exit(1);
//   }
// }

// testConnection();

// module.exports = {
//   query: (text, params) => {
//     console.log('Executing query:', text);
//     return pool.query(text, params);
//   },
//   end: () => pool.end(),
//   pool: pool,
//   getClient: async () => {
//     return await pool.connect();
//   }
// };









require('dotenv').config();
const { Pool } = require('pg');

if (!process.env.DATABASE_URL) {
  throw new Error('Missing DATABASE_URL in .env');
}

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false
  }
});

pool.on('connect', () => {
  console.log('Connected to Supabase PostgreSQL');
});

pool.on('error', (err) => {
  console.error('Unexpected error on idle client', err);
  process.exit(-1);
});

async function testConnection() {
  try {
    const client = await pool.connect();
    console.log('Successfully connected to PostgreSQL database');
    client.release();
  } catch (err) {
    console.error('Database connection error:', err);
  }
}

testConnection();

module.exports = {
  query: (text, params) => pool.query(text, params),
  pool
};
