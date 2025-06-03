const db = require("../database");

// async function getUserOrders(req, res) {
//   const user_uuid = req.user.uuid;

//   try {
//     const { rows: userRows } = await db.query(
//       `SELECT id FROM users WHERE uuid = $1`,
//       [user_uuid]
//     );

//     if (userRows.length === 0) {
//       return res.status(404).json({
//         status: "error",
//         message: "User not found"
//       });
//     }

//     const userId = userRows[0].id;

//     const { rows: orders } = await db.query(
//       `SELECT 
//         o.id, 
//         o.date, 
//         o.status, 
//         o.receipt_img, 
//         o.planted_img,
//         o.location_id,
//         o.plant_id,
//         o.planter_id
//        FROM orders o 
//        WHERE user_id = $1 
//        ORDER BY o.date DESC`,
//       [userId]
//     );

//     if (orders.length === 0) {
//       return res.json({
//         status: "success",
//         message: "No orders found for this user",
//       });
//     }

//     const [planters, locations, plants] = await Promise.all([
//       db.query(
//         `SELECT u.id, u.email 
//          FROM users u 
//          WHERE u.id = ANY($1::int[])`,
//         [orders.map(o => o.planter_id).filter(Boolean)]
//       ),
//       db.query(
//         `SELECT id, name, province 
//          FROM locations 
//          WHERE id = ANY($1::int[])`,
//         [orders.map(o => o.location_id)]
//       ),
//       db.query(
//         `SELECT * FROM plants WHERE id = ANY($1::int[])`,
//         [orders.map(o => o.plant_id)]
//       )
//     ]);

//     const planterMap = new Map(planters.rows.map(p => [p.id, p]));
//     const locationMap = new Map(locations.rows.map(l => [l.id, l]));
//     const plantMap = new Map(plants.rows.map(p => [p.id, p]));

//     const responseData = orders.map(order => ({
//       id: order.id,
//       date: order.date,
//       status: order.status,
//       receipt_img: order.receipt_img,
//       planted_img: order.planted_img,
//       planter: order.planter_id ? planterMap.get(order.planter_id) : null,
//       location: locationMap.get(order.location_id),
//       plant: plantMap.get(order.plant_id)
//     }));

//     res.json({
//       status: "success",
//       data: {
//         orders: responseData
//       }
//     });

//   } catch (err) {
//     console.error("Error fetching orders:", err);
//     res.status(500).json({
//       status: "error",
//       message: "Failed to fetch orders"
//     });
//   }
// }

async function getOrders(req, res) {
  const { uuid, role } = req.user;

  try {
    // First get the user/planter ID from UUID
    const { rows: userRows } = await db.query(
      `SELECT id FROM users WHERE uuid = $1`,
      [uuid]
    );

    if (userRows.length === 0) {
      return res.status(404).json({
        status: "error",
        message: "User not found"
      });
    }

    const userId = userRows[0].id;
    let ordersQuery;
    let queryParams;

    if (role === 'planter') {
      // For planters, get all orders assigned to them
      ordersQuery = `
        SELECT 
          o.id, 
          o.date, 
          o.status, 
          o.receipt_img, 
          o.planted_img,
          o.location_id,
          o.plant_id,
          o.user_id
        FROM orders o 
        WHERE o.planter_id = $1 
        ORDER BY o.date DESC
      `;
      queryParams = [userId];
    } else {
      // For regular users, get their own orders
      ordersQuery = `
        SELECT 
          o.id, 
          o.date, 
          o.status, 
          o.receipt_img, 
          o.planted_img,
          o.location_id,
          o.plant_id,
          o.planter_id
        FROM orders o 
        WHERE o.user_id = $1 
        ORDER BY o.date DESC
      `;
      queryParams = [userId];
    }

    const { rows: orders } = await db.query(ordersQuery, queryParams);

    if (orders.length === 0) {
      return res.json({
        status: "success",
        message: "No orders found",
        data: { orders: [] }
      });
    }

    // Determine which related data we need to fetch based on role
    let relatedDataQueries;
    if (role === 'planter') {
      // For planters, we need user info (who created the order)
      relatedDataQueries = [
        db.query(
          `SELECT id, email FROM users WHERE id = ANY($1::int[])`,
          [orders.map(o => o.user_id).filter(Boolean)]
        ),
        db.query(
          `SELECT id, name, province FROM locations WHERE id = ANY($1::int[])`,
          [orders.map(o => o.location_id)]
        ),
        db.query(
          `SELECT * FROM plants WHERE id = ANY($1::int[])`,
          [orders.map(o => o.plant_id)]
        )
      ];
    } else {
      // For regular users, we need planter info
      relatedDataQueries = [
        db.query(
          `SELECT id, email FROM users WHERE id = ANY($1::int[])`,
          [orders.map(o => o.planter_id).filter(Boolean)]
        ),
        db.query(
          `SELECT id, name, province FROM locations WHERE id = ANY($1::int[])`,
          [orders.map(o => o.location_id)]
        ),
        db.query(
          `SELECT * FROM plants WHERE id = ANY($1::int[])`,
          [orders.map(o => o.plant_id)]
        )
      ];
    }

    const [relatedUsers, locations, plants] = await Promise.all(relatedDataQueries);

    // Create lookup maps
    const userMap = new Map(relatedUsers.rows.map(u => [u.id, u]));
    const locationMap = new Map(locations.rows.map(l => [l.id, l]));
    const plantMap = new Map(plants.rows.map(p => [p.id, p]));

    // Construct response data based on role
    const responseData = orders.map(order => {
      const baseData = {
        id: order.id,
        date: order.date,
        status: order.status,
        receipt_img: order.receipt_img,
        planted_img: order.planted_img,
        location: locationMap.get(order.location_id),
        plant: plantMap.get(order.plant_id)
      };

      if (role === 'planter') {
        return {
          ...baseData,
          user: order.user_id ? userMap.get(order.user_id) : null
        };
      } else {
        return {
          ...baseData,
          planter: order.planter_id ? userMap.get(order.planter_id) : null
        };
      }
    });

    res.json({
      status: "success",
      data: {
        orders: responseData
      }
    });

  } catch (err) {
    console.error("Error fetching orders:", err);
    res.status(500).json({
      status: "error",
      message: "Failed to fetch orders"
    });
  }
}

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


async function deleteOrder(req, res) {
  const user_uuid = req.user.uuid;
  const order_id = req.params.id;

  try {
    const { rows: userRows } = await db.query(
      `SELECT id FROM users WHERE uuid = $1`,
      [user_uuid]
    );

    if (userRows.length === 0) {
      return res.status(404).json({
        status: "error",
        message: "User not found",
      });
    }

    const user_id = userRows[0].id;

    const { rows: orderRows } = await db.query(
      `SELECT * FROM orders WHERE id = $1 AND user_id = $2`,
      [order_id, user_id]
    );

    if (orderRows.length === 0) {
      return res.status(403).json({
        status: "error",
        message: "Order not found or you do not have permission to delete it",
      });
    }

    // Delete the order
    await db.query(
      `DELETE FROM orders WHERE id = $1 AND user_id = $2`,
      [order_id, user_id]
    );

    res.json({
      status: "success",
      message: "Order deleted successfully",
    });

  } catch (err) {
    console.error("Error deleting order:", err);
    res.status(500).json({
      status: "error",
      message: "Failed to delete order",
    });
  }
}

module.exports = {
  getOrders,
  createOrder,
  deleteOrder,
};
