// const jwt = require("jsonwebtoken");
// const bcrypt = require("bcryptjs");
// const db = require("../../database");
// const { JWT_SECRET } = process.env;

// async function login(req, res) {
//   try {
//     const { email, password } = req.body;

//     if (!email || !password) {
//       return res.status(400).json({
//         status: "error",
//         message: "Email and password are required",
//       });
//     }

//     const { rows } = await db.query("SELECT * FROM users WHERE email = $1", [email]);
//     if (rows.length === 0) {
//       return res.status(401).json({
//         status: "error",
//         message: "Invalid email or password",
//       });
//     }

//     const user = rows[0];
//     const isPasswordValid = await bcrypt.compare(password, user.password);
//     if (!isPasswordValid) {
//       return res.status(401).json({
//         status: "error",
//         message: "Invalid email or password",
//       });
//     }

//     // Create tokens
//     const accessToken = jwt.sign(
//       { uuid: user.uuid, email: user.email, role: user.role },
//       JWT_SECRET,
//       { expiresIn: process.env.ACCESS_TOKEN_EXPIRES_IN || "15m" }
//     );

//     const refreshToken = jwt.sign(
//       { uuid: user.uuid },
//       JWT_SECRET,
//       { expiresIn: process.env.REFRESH_TOKEN_EXPIRES_IN || "7d" }
//     );

//     // Update refresh token in DB
//     await db.query("UPDATE users SET refresh_token = $1 WHERE uuid = $2", [
//       refreshToken,
//       user.uuid,
//     ]);

//     // Set cookies
//     res.cookie("accessToken", accessToken, {
//       httpOnly: true,
//       secure: process.env.NODE_ENV === "production",
//       sameSite: "strict",
//       maxAge: 15 * 60 * 1000 // 15 minutes
//     });

//     res.cookie("refreshToken", refreshToken, {
//       httpOnly: true,
//       secure: process.env.NODE_ENV === "production",
//       sameSite: "strict",
//       maxAge: 7 * 24 * 60 * 60 * 1000 // 7 days
//     });

//     res.json({
//       status: "success",
//       accessToken,
//       refreshToken,
//       JWT_SECRET,
//       data: {
//         user: {
//           uuid: user.uuid,
//           id: user.id,
//           email: user.email,
//           role: user.role,
//         },
//       },
//     });

//   } catch (err) {
//     console.error("Login error:", err);
//     res.status(500).json({
//       status: "error",
//       message: "Failed to login",
//     });
//   }
// }

// module.exports = login;


const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");
const db = require("../../database");

const {
  JWT_SECRET,
  ACCESS_TOKEN_EXPIRES_IN = "15m",
  REFRESH_TOKEN_EXPIRES_IN = "7d"
} = process.env;

async function login(req, res) {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        status: "error",
        message: "Email and password are required"
      });
    }

    const { rows } = await db.query("SELECT * FROM users WHERE email = $1", [email]);
    if (rows.length === 0) {
      return res.status(401).json({
        status: "error",
        message: "Invalid email or password"
      });
    }

    const user = rows[0];

    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(401).json({
        status: "error",
        message: "Invalid email or password"
      });
    }

    // Generate tokens
    const accessToken = jwt.sign(
      { uuid: user.uuid, email: user.email, role: user.role },
      JWT_SECRET,
      { expiresIn: ACCESS_TOKEN_EXPIRES_IN }
    );

    const refreshToken = jwt.sign(
      { uuid: user.uuid },
      JWT_SECRET,
      { expiresIn: REFRESH_TOKEN_EXPIRES_IN }
    );

    // Save refresh token in database
    await db.query("UPDATE users SET refresh_token = $1 WHERE uuid = $2", [
      refreshToken,
      user.uuid
    ]);

    // Set cookies
    const cookieOptions = {
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      sameSite: "strict"
    };

    res.cookie("accessToken", accessToken, {
      ...cookieOptions,
      maxAge: 15 * 60 * 1000
    });

    res.cookie("refreshToken", refreshToken, {
      ...cookieOptions,
      maxAge: 7 * 24 * 60 * 60 * 1000
    });

    // Send response
    res.json({
      status: "success",
      data: {
        user: {
          uuid: user.uuid,
          id: user.id,
          email: user.email,
          role: user.role
        },
        tokens: {
          access_token: accessToken,
          refresh_token: refreshToken,
          expires_in: ACCESS_TOKEN_EXPIRES_IN
        }
      }
    });

  } catch (err) {
    console.error("Login error:", err);
    res.status(500).json({
      status: "error",
      message: "Failed to login"
    });
  }
}

module.exports = login;
