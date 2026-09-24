const sql = require("mssql/msnodesqlv8");

const config = {
    connectionString:
        "Driver={ODBC Driver 18 for SQL Server};" +
        "Server=Sarthak;" +
        "Database=LostFoundDB;" +
        "Trusted_Connection=Yes;" +
        "TrustServerCertificate=Yes;"
};

const poolPromise = new sql.ConnectionPool(config)
    .connect()
    .then(pool => {
        console.log("✅ Connected to LostFoundDB");
        return pool;
    })
    .catch(err => {
        console.error("❌ Database connection failed:", err);
        throw err;
    });

module.exports = {
    sql,
    poolPromise
};