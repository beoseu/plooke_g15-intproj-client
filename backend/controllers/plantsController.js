const db = require('../database');

async function getPlants(req, res) {
  try {
    const { rows } = await db.query('SELECT * FROM plants ORDER BY name');
    res.json({
      status: 'success',
      data: rows
    });
  } catch (err) {
    console.error('Error fetching plants:', err);
    res.status(500).json({
      status: 'error',
      message: 'Failed to fetch plants'
    });
  }
}

async function getPlantById(req, res) {
  try {
    const { id } = req.params;
    
    if (isNaN(id)) {
      return res.status(400).json({
        status: 'error',
        message: 'Invalid ID format'
      });
    }

    const { rows } = await db.query('SELECT * FROM plants WHERE id = $1', [id]); //$1 for postgres
    
    if (rows.length === 0) {
      return res.status(404).json({
        status: 'error',
        message: 'Plant not found'
      });
    }

    res.json({
      status: 'success',
      data: rows[0]
    });
  } catch (err) {
    console.error('Error fetching plant by ID:', err);
    res.status(500).json({
      status: 'error',
      message: 'Failed to fetch plant'
    });
  }
}

module.exports = {
  getPlants,
  getPlantById
};