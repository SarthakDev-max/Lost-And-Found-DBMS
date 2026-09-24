const { sql, poolPromise } = require("../config/db");

// ========================================
// REPORT FOUND ITEM
// ========================================

const reportFoundItem = async (req, res) => {

    try {

        const {
            userID,
            itemName,
            category,
            location,
            color,
            brand,
            dateFound,
            description
        } = req.body;


        // Validate required fields
        if (
            !userID ||
            !itemName ||
            !category ||
            !location ||
            !dateFound
        ) {
            return res.status(400).json({
                success: false,
                message: "Required fields are missing"
            });
        }


        const pool = await poolPromise;


        // Find CategoryID
        const categoryResult = await pool
            .request()
            .input(
                "CategoryName",
                sql.VarChar(100),
                category
            )
            .query(`
                SELECT CategoryID
                FROM Categories
                WHERE CategoryName = @CategoryName
            `);


        if (categoryResult.recordset.length === 0) {
            return res.status(400).json({
                success: false,
                message: "Invalid category"
            });
        }


        const categoryID =
            categoryResult.recordset[0].CategoryID;


        // Find LocationID
        const locationResult = await pool
            .request()
            .input(
                "LocationName",
                sql.VarChar(100),
                location
            )
            .query(`
                SELECT LocationID
                FROM Locations
                WHERE LocationName = @LocationName
            `);


        if (locationResult.recordset.length === 0) {
            return res.status(400).json({
                success: false,
                message: "Invalid location"
            });
        }


        const locationID =
            locationResult.recordset[0].LocationID;


        // Insert found item
        const result = await pool
            .request()

            .input("UserID", sql.Int, userID)
            .input("CategoryID", sql.Int, categoryID)
            .input("LocationID", sql.Int, locationID)
            .input("ItemName", sql.VarChar(255), itemName)
            .input(
                "Description",
                sql.VarChar(sql.MAX),
                description || null
            )
            .input("Color", sql.VarChar(100), color || null)
            .input("Brand", sql.VarChar(100), brand || null)
            .input("DateFound", sql.Date, dateFound)
            .input("Status", sql.VarChar(20), "Found")

            .query(`
                INSERT INTO FoundItems
                (
                    UserID,
                    CategoryID,
                    LocationID,
                    ItemName,
                    Description,
                    Color,
                    Brand,
                    DateFound,
                    Status,
                    CreatedAt
                )

                OUTPUT
                    INSERTED.FoundItemID,
                    INSERTED.ItemName,
                    INSERTED.Status,
                    INSERTED.DateFound

                VALUES
                (
                    @UserID,
                    @CategoryID,
                    @LocationID,
                    @ItemName,
                    @Description,
                    @Color,
                    @Brand,
                    @DateFound,
                    @Status,
                    GETDATE()
                )
            `);


        return res.status(201).json({
            success: true,
            message: "Found item reported successfully",
            item: result.recordset[0]
        });


    } catch (error) {

        console.error(
            "Report found item error:",
            error
        );

        return res.status(500).json({
            success: false,
            message: "Failed to report found item",
            error: error.message
        });
    }
};


module.exports = {
    reportFoundItem
};