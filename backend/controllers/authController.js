const bcrypt = require("bcryptjs");
const { sql, poolPromise } = require("../config/db");

// ===============================
// REGISTER USER
// ===============================
const registerUser = async (req, res) => {
    try {
        const { fullName, email, phone, password } = req.body;

        // Validate required fields
        if (!fullName || !email || !phone || !password) {
            return res.status(400).json({
                success: false,
                message: "All fields are required"
            });
        }

        // Basic password validation
        if (password.length < 6) {
            return res.status(400).json({
                success: false,
                message: "Password must be at least 6 characters"
            });
        }

        const pool = await poolPromise;

        // Check whether email already exists
        const existingUser = await pool
            .request()
            .input("Email", sql.VarChar(255), email)
            .query(`
                SELECT UserID
                FROM Users
                WHERE Email = @Email
            `);

        if (existingUser.recordset.length > 0) {
            return res.status(409).json({
                success: false,
                message: "Email already registered"
            });
        }

        // Hash password
        const passwordHash = await bcrypt.hash(password, 10);

        // Insert new user
        const result = await pool
            .request()
            .input("FullName", sql.VarChar(255), fullName)
            .input("Email", sql.VarChar(255), email)
            .input("PasswordHash", sql.VarChar(255), passwordHash)
            .input("Phone", sql.VarChar(20), phone)
            .input("Role", sql.VarChar(20), "User")
            .query(`
                INSERT INTO Users
                    (FullName, Email, PasswordHash, Phone, Role, CreatedAt)
                OUTPUT INSERTED.UserID, INSERTED.FullName, INSERTED.Email, INSERTED.Phone, INSERTED.Role
                VALUES
                    (@FullName, @Email, @PasswordHash, @Phone, @Role, GETDATE())
            `);

        const user = result.recordset[0];

        return res.status(201).json({
            success: true,
            message: "Registration successful",
            user: user
        });

    } catch (error) {
        console.error("Registration error:", error);

        return res.status(500).json({
            success: false,
            message: "Registration failed",
            error: error.message
        });
    }
};

// ===============================
// LOGIN USER
// ===============================
const loginUser = async (req, res) => {
    try {
        const { email, password } = req.body;

        // Validate required fields
        if (!email || !password) {
            return res.status(400).json({
                success: false,
                message: "Email and password are required"
            });
        }

        const pool = await poolPromise;

        // Find user by email
        const result = await pool
            .request()
            .input("Email", sql.VarChar(255), email)
            .query(`
                SELECT
                    UserID,
                    FullName,
                    Email,
                    PasswordHash,
                    Phone,
                    Role
                FROM Users
                WHERE Email = @Email
            `);

        if (result.recordset.length === 0) {
            return res.status(401).json({
                success: false,
                message: "Invalid email or password"
            });
        }

        const user = result.recordset[0];

        // Compare entered password with hashed password
        const passwordMatch = await bcrypt.compare(
            password,
            user.PasswordHash
        );

        if (!passwordMatch) {
            return res.status(401).json({
                success: false,
                message: "Invalid email or password"
            });
        }

        // Remove password hash before sending response
        delete user.PasswordHash;

        return res.status(200).json({
            success: true,
            message: "Login successful",
            user: user
        });

    } catch (error) {
        console.error("Login error:", error);

        return res.status(500).json({
            success: false,
            message: "Login failed",
            error: error.message
        });
    }
};


module.exports = {
    registerUser,
    loginUser
};