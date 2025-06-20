const db = require("../../database");

async function confirmOrder(req, res) {
  const { supabase_uid } = req.user;  // เปลี่ยนจาก uuid เป็น supabase_uid
  const { order_id, planted_img } = req.body;

  if (!order_id || !planted_img) {
    return res.status(400).json({
      status: "error",
      message: "Order ID and planted image are required",
    });
  }

  try {
    const { rows: [order] } = await db.query(
      `SELECT status FROM orders 
       WHERE id = $1 
       AND planter_id = (SELECT id FROM users WHERE supabase_uid = $2)`,
      [order_id, supabase_uid]
    );

    if (!order) {
      return res.status(404).json({
        status: "error",
        message: "Order not found",
      });
    }

    if (order.status !== 'in progress') {
      return res.status(409).json({
        status: "error",
        message: `Order must be 'in progress' to complete (current: ${order.status})`,
      });
    }

    const { rows: [updatedOrder] } = await db.query(
      `UPDATE orders 
       SET planted_img = $1, status = 'completed'
       WHERE id = $2 AND status = 'in progress' 
       RETURNING id, status, planted_img`,
      [planted_img, order_id]
    );

    if (!updatedOrder) {
      // กรณี status ถูกเปลี่ยนก่อนหน้า
      return res.status(409).json({
        status: "error",
        message: "Order status changed before completion",
      });
    }

    res.json({
      status: "success",
      message: "Order marked as completed",
      data: updatedOrder,
    });

  } catch (err) {
    console.error("Error completing order:", err);
    res.status(500).json({
      status: "error",
      message: "Failed to complete order",
    });
  }
}

module.exports = confirmOrder;
