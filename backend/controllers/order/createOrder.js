const db = require("../../database");

async function createOrder(req, res) {
  const { location_id, plant_id } = req.body;
  const user_uuid = req.user.uuid;

  if (!location_id || !plant_id) {
    return res.status(400).json({
      status: "error",
      message: "Location ID and Plant ID are required",
    });
  }

  try {
    await db.query("BEGIN");

    const { rows: userRows } = await db.query(
      `SELECT id, email FROM users WHERE uuid = $1`,
      [user_uuid]
    );

    const { rows: locationRows } = await db.query(
      `SELECT * FROM locations WHERE id = $1`,
      [location_id]
    );

    if (locationRows.length === 0) {
      await db.query("ROLLBACK");
      return res.status(404).json({
        status: "error",
        message: "Location not found",
      });
    }

    const province = locationRows[0].province;

    const { rows: planterRows } = await db.query(
      `SELECT id, email FROM users 
       WHERE role = 'planter' 
       AND province = $1 
       ORDER BY RANDOM() 
       LIMIT 1`,
      [province]
    );

    if (planterRows.length === 0) {
      await db.query("ROLLBACK");
      return res.status(404).json({
        status: "error",
        message: "No available planter found in this province",
      });
    }

    const planter_id = planterRows[0].id;

    const { rows: orderRows } = await db.query(
      `INSERT INTO orders (location_id, plant_id, user_id, planter_id) 
       VALUES ($1, $2, $3, $4) 
       RETURNING *`,
      [location_id, plant_id, userRows[0].id, planter_id]
    );

    const { rows: plantRows } = await db.query(
      `SELECT * FROM plants WHERE id = $1`,
      [plant_id]
    );

    await db.query("COMMIT");

    res.status(201).json({
      status: "success",
      data: {
        order: orderRows[0],
        location: locationRows[0],
        plant: plantRows[0],
        user_uuid: userRows[0]?.id,
        user_email: userRows[0]?.email,
        planter_id: planterRows[0]?.id,
        planter_email: planterRows[0]?.email,
      },
    });
  } catch (err) {
    await db.query("ROLLBACK");

    console.error("Error creating order:", err);

    if (err.code === "23503") {
      return res.status(400).json({
        status: "error",
        message: "Invalid location_id or plant_id",
        details: err.detail,
      });
    }

    res.status(500).json({
      status: "error",
      message: "Failed to create order",
    });
  }
}

module.exports = createOrder;