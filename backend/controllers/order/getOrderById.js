const db = require("../../database");

async function getOrderById(req, res) {
  const order_id = req.params.id;

  try {
    const { rows: orderRows } = await db.query(
      `SELECT * FROM orders WHERE id = $1`,
      [order_id]
    );

    if (orderRows.length === 0) {
      return res.status(404).json({
        status: "error",
        message: "Order not found"
      });
    }

    const order = orderRows[0];

    const [locationResult, plantResult, userResult, planterResult] = await Promise.all([
      db.query(`SELECT id, name, province FROM locations WHERE id = $1`, [order.location_id]),
      db.query(`SELECT * FROM plants WHERE id = $1`, [order.plant_id]),
      db.query(`SELECT id, email FROM users WHERE id = $1`, [order.user_id]),
      db.query(`SELECT id, email FROM users WHERE id = $1`, [order.planter_id])
    ]);

    res.json({
      status: "success",
      data: {
        order: {
          id: order.id,
          date: order.date,
          status: order.status,
          receipt_img: order.receipt_img,
          planted_img: order.planted_img,
          location: locationResult.rows[0] || null,
          plant: plantResult.rows[0] || null,
          user: userResult.rows[0] || null,
          planter: planterResult.rows[0] || null
        }
      }
    });

  } catch (err) {
    console.error("Error fetching order by ID:", err);
    res.status(500).json({
      status: "error",
      message: "Failed to fetch order"
    });
  }
}

module.exports = getOrderById;