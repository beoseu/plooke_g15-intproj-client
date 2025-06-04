const db = require("../../database");

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

module.exports = deleteOrder;
