const db = require("../../database");

async function updateOrder(req, res) {
  const supabase_uid = req.user.supabase_uid;  // แก้ตรงนี้
  const { order_id, receipt_img } = req.body;

  if (!order_id || !receipt_img) {
    return res.status(400).json({
      status: "error",
      message: "Order ID and payment receipt image are required",
      required_fields: {
        order_id: "number",
        receipt_img: "string (URL or base64)"
      }
    });
  }

  try {
    const { rows: [order] } = await db.query(
      `SELECT o.status 
       FROM orders o
       JOIN users u ON o.user_id = u.id
       WHERE o.id = $1 AND u.supabase_uid = $2`,  // แก้จาก uuid เป็น supabase_uid
      [order_id, supabase_uid]
    );

    if (!order) {
      return res.status(404).json({
        status: "error",
        message: "Order not found"
      });
    }

    if (order.status !== 'unpaid') {
      return res.status(400).json({
        status: "error",
        message: `Cannot upload receipt for order with status: ${order.status}`,
        allowed_status: "unpaid"
      });
    }

    // Update order with payment receipt
    const { rows: [updatedOrder] } = await db.query(
      `UPDATE orders 
       SET receipt_img = $1, status = 'in progress'
       WHERE id = $2
       RETURNING id, status, receipt_img`,
      [receipt_img, order_id]
    );

    res.json({
      status: "success",
      message: "Payment receipt uploaded successfully",
      data: {
        order: updatedOrder
      }
    });

  } catch (err) {
    console.error("Error uploading payment receipt:", err);
    
    if (err.code === '22P02') { 
      return res.status(400).json({
        status: "error",
        message: "Invalid order ID format"
      });
    }

    res.status(500).json({
      status: "error",
      message: "Failed to process payment receipt",
      system_message: err.message
    });
  }
}

module.exports = updateOrder;
