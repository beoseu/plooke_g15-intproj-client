const db = require("../../database");

async function getOrders(req, res) {
  const { supabase_uid, role } = req.user;  // เปลี่ยนจาก uuid เป็น supabase_uid

  try {
    // หา user.id จาก supabase_uid
    const { rows: userRows } = await db.query(
      `SELECT id FROM users WHERE supabase_uid = $1`,
      [supabase_uid]
    );

    if (userRows.length === 0) {
      return res.status(404).json({
        status: "error",
        message: "User not found",
      });
    }

    const userId = userRows[0].id;
    let ordersQuery;
    let queryParams;

    if (role === "planter") {
      // สำหรับ planter ดึง order ที่ assign ให้ planter_id = userId และ status != 'unpaid'
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
        WHERE o.planter_id = $1 AND o.status != 'unpaid'
        ORDER BY status = 'in progress' DESC, o.date DESC
      `;
      queryParams = [userId];
    } else {
      // สำหรับ user ปกติ ดึง order ของ user เอง
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
        data: { orders: [] },
      });
    }

    // ดึงข้อมูล user (planter หรือ user ขึ้นกับ role) และ location, plant
    let relatedDataQueries;
    if (role === "planter") {
      relatedDataQueries = [
        db.query(`SELECT id, email FROM users WHERE id = ANY($1::int[])`, [
          orders.map((o) => o.user_id).filter(Boolean),
        ]),
        db.query(
          `SELECT id, name, province FROM locations WHERE id = ANY($1::int[])`,
          [orders.map((o) => o.location_id)]
        ),
        db.query(`SELECT * FROM plants WHERE id = ANY($1::int[])`, [
          orders.map((o) => o.plant_id),
        ]),
      ];
    } else {
      relatedDataQueries = [
        db.query(`SELECT id, email FROM users WHERE id = ANY($1::int[])`, [
          orders.map((o) => o.planter_id).filter(Boolean),
        ]),
        db.query(
          `SELECT id, name, province FROM locations WHERE id = ANY($1::int[])`,
          [orders.map((o) => o.location_id)]
        ),
        db.query(`SELECT * FROM plants WHERE id = ANY($1::int[])`, [
          orders.map((o) => o.plant_id),
        ]),
      ];
    }

    const [relatedUsers, locations, plants] = await Promise.all(relatedDataQueries);

    // สร้าง map lookup
    const userMap = new Map(relatedUsers.rows.map((u) => [u.id, u]));
    const locationMap = new Map(locations.rows.map((l) => [l.id, l]));
    const plantMap = new Map(plants.rows.map((p) => [p.id, p]));

    // สร้าง response data
    const responseData = orders.map((order) => {
      const baseData = {
        id: order.id,
        date: order.date,
        status: order.status,
        receipt_img: order.receipt_img,
        planted_img: order.planted_img,
        location: locationMap.get(order.location_id),
        plant: plantMap.get(order.plant_id),
      };

      if (role === "planter") {
        return {
          ...baseData,
          user: order.user_id ? userMap.get(order.user_id) : null,
        };
      } else {
        return {
          ...baseData,
          planter: order.planter_id ? userMap.get(order.planter_id) : null,
        };
      }
    });

    res.json({
      status: "success",
      data: {
        orders: responseData,
      },
    });
  } catch (err) {
    console.error("Error fetching orders:", err);
    res.status(500).json({
      status: "error",
      message: "Failed to fetch orders",
    });
  }
}

module.exports = getOrders;
