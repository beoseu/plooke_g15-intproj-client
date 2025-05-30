const db = require('../database');

async function getLocations(req, res) {
  try {
    const { rows } = await db.query('SELECT * FROM locations ORDER BY id');
    res.json({
      status: 'success',
      data: rows
    });
  } catch (err) {
    console.error('Error fetching locations:', err);
    res.status(500).json({
      status: 'error',
      message: 'Failed to fetch locations'
    });
  }
}

async function getLocationById(req, res) {
  try {
    const { id } = req.params;
    
    if (isNaN(id)) {
      return res.status(400).json({
        status: 'error',
        message: 'Invalid ID format'
      });
    }

    const { rows } = await db.query('SELECT * FROM locations WHERE id = $1', [id]); //$1 for postgres
    
    if (rows.length === 0) {
      return res.status(404).json({
        status: 'error',
        message: 'Location not found'
      });
    }

    res.json({
      status: 'success',
      data: rows[0]
    });
  } catch (err) {
    console.error('Error fetching location by ID:', err);
    res.status(500).json({
      status: 'error',
      message: 'Failed to fetch location'
    });
  }
}

module.exports = {
  getLocations,
  getLocationById
};