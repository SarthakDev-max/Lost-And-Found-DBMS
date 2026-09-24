const express = require("express");
const cors = require("cors");

const { poolPromise } = require("./config/db");
const authRoutes = require("./routes/authRoutes");
const itemRoutes = require("./routes/itemRoutes");
const foundItemRoutes = require("./routes/foundItemRoutes");
const claimRoutes = require("./routes/claimRoutes");

const app = express();
const PORT = 5000;

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
// ===============================
// ROUTES
// ===============================

app.get("/", (req, res) => {
    res.json({
        success: true,
        message: "Lost and Found API is running"
    });
});


app.get("/api/health", async (req, res) => {
    try {
        const pool = await poolPromise;

        const result = await pool.request().query(`
            SELECT
                DB_NAME() AS DatabaseName,
                SUSER_SNAME() AS LoginName
        `);

        res.json({
            success: true,
            message: "Database connected successfully",
            database: result.recordset[0].DatabaseName,
            user: result.recordset[0].LoginName
        });

    } catch (error) {
        console.error("Database health check failed:", error.message);

        res.status(500).json({
            success: false,
            message: "Database connection failed",
            error: error.message
        });
    }
});


// Authentication routes

app.get("/api/admin/stats", async (req, res) => {

    try {

        const pool = await poolPromise;

        const result = await pool.request().query(`
            SELECT
                (SELECT COUNT(*) FROM Users) AS TotalUsers,

                (SELECT COUNT(*) FROM LostItems) AS TotalLostItems,

                (SELECT COUNT(*) FROM FoundItems) AS TotalFoundItems,

                (SELECT COUNT(*) FROM Claims) AS TotalClaims,

                (SELECT COUNT(*)
                 FROM Claims
                 WHERE Status = 'Pending') AS PendingClaims,

                (SELECT COUNT(*)
                 FROM Claims
                 WHERE Status = 'Approved') AS ApprovedClaims,

                (SELECT COUNT(*)
                 FROM Claims
                 WHERE Status = 'Rejected') AS RejectedClaims
        `);

        res.json({
            success: true,
            stats: result.recordset[0]
        });

    } catch (error) {

        console.error("Admin stats error:", error);

        res.status(500).json({
            success: false,
            message: "Unable to fetch admin statistics.",
            error: error.message
        });

    }

});
app.use("/api/auth", authRoutes);
app.use("/api/items", itemRoutes);
app.use("/api/items", foundItemRoutes);
app.use("/api/claims", claimRoutes);

// ===============================
// START SERVER
// ===============================

app.listen(PORT, async () => {

    console.log(`ðŸš€ Server running at http://localhost:${PORT}`);

    try {
        await poolPromise;
        console.log("âœ… Connected to LostFoundDB");
    } catch (error) {
        console.error(
            "âŒ Database connection failed:",
            error.message
        );
    }
});
