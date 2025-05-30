const db = require('../database');

async function getOrders(req, res) {
  try {
    const { rows } = await db.query('SELECT * FROM orders ORDER BY date');
    res.json({
      status: 'success',
      data: rows
    });
  } catch (err) {
    console.error('Error fetching orders:', err);
    res.status(500).json({
      status: 'error',
      message: 'Failed to fetch orders'
    });
  }
}

async function getOrderById(req, res) {
  try {
    const { id } = req.params;
    
    if (isNaN(id)) {
      return res.status(400).json({
        status: 'error',
        message: 'Invalid ID format'
      });
    }

    const { rows } = await db.query('SELECT * FROM orders WHERE id = $1', [id]); //$1 for postgres
    
    if (rows.length === 0) {
      return res.status(404).json({
        status: 'error',
        message: 'Order not found'
      });
    }

    res.json({
      status: 'success',
      data: rows[0]
    });
  } catch (err) {
    console.error('Error fetching order by ID:', err);
    res.status(500).json({
      status: 'error',
      message: 'Failed to fetch order'
    });
  }
}

module.exports = {
  getOrders,
  getOrderById
};