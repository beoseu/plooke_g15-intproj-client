const db = require("../database");

async function getOrders(req, res) {
  const user_id = req.user.id;

  try {
    const { rows } = await db.query("SELECT * FROM orders WHERE user_id = $1 ORDER BY date", [user_id]);
    res.json({
      status: "success",
      data: rows,
    });
  } catch (err) {
    console.error("Error fetching orders:", err);
    res.status(500).json({
      status: "error",
      message: "Failed to fetch orders",
    });
  }
}

async function createOrder(req, res) {
  try {
    const { location_id, plant_id } = req.body;
    const user_id = req.user.id;

    // Validate required fields
    if (!location_id || !plant_id) {
      return res.status(400).json({
        status: "error",
        message: "Location ID and Plant ID are required",
      });
    }

    // Start transaction
    await db.query('BEGIN');

    const { rows: orderRows } = await db.query(
      `INSERT INTO orders 
       (location_id, plant_id, user_id) 
       VALUES ($1, $2, $3) 
       RETURNING *`,
      [location_id, plant_id, user_id]
    );

    // Get full location details
    const { rows: locationRows } = await db.query(
      `SELECT * FROM locations WHERE id = $1`,
      [location_id]
    );

    // Get full plant details
    const { rows: plantRows } = await db.query(
      `SELECT * FROM plants WHERE id = $1`,
      [plant_id]
    );

    // Get user email
    const { rows: userRows } = await db.query(
      `SELECT email FROM users WHERE id = $1`,
      [user_id]
    );

    // Commit transaction
    await db.query('COMMIT');

    // Prepare response data
    const responseData = {
      order: orderRows[0],
      location: locationRows[0],
      plant: plantRows[0],
      user_email: userRows[0]?.email
    };

    res.status(201).json({
      status: "success",
      data: responseData
    });

  } catch (err) {
    // Rollback transaction if error occurs
    await db.query('ROLLBACK');
    
    console.error("Error creating order:", err);
    
    if (err.code === '23503') { // Foreign key violation
      return res.status(400).json({
        status: "error",
        message: "Invalid location_id or plant_id",
        details: err.detail
      });
    }

    res.status(500).json({
      status: "error",
      message: "Failed to create order"
    });
  }
}

module.exports = {
  getOrders,
  createOrder,
};
