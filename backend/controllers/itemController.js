const { sql, poolPromise } = require("../config/db");

// ========================================
// REPORT LOST ITEM
// ========================================

const reportLostItem = async (req, res) => {

    try {

        const {
            userID,
            itemName,
            category,
            location,
            color,
            brand,
            dateLost,
            description
        } = req.body;


        // Validate required fields
        if (
            !userID ||
            !itemName ||
            !category ||
            !location ||
            !dateLost
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
            .input("CategoryName", sql.VarChar(100), category)
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
            .input("LocationName", sql.VarChar(100), location)
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


        // Insert lost item
        const result = await pool
            .request()

            .input("UserID", sql.Int, userID)
            .input("CategoryID", sql.Int, categoryID)
            .input("LocationID", sql.Int, locationID)
            .input("ItemName", sql.VarChar(255), itemName)
            .input("Description", sql.VarChar(sql.MAX), description || null)
            .input("Color", sql.VarChar(100), color || null)
            .input("Brand", sql.VarChar(100), brand || null)
            .input("DateLost", sql.Date, dateLost)
            .input("Status", sql.VarChar(20), "Lost")

            .query(`
                INSERT INTO LostItems
                (
                    UserID,
                    CategoryID,
                    LocationID,
                    ItemName,
                    Description,
                    Color,
                    Brand,
                    DateLost,
                    Status,
                    CreatedAt
                )

                OUTPUT
                    INSERTED.LostItemID,
                    INSERTED.ItemName,
                    INSERTED.Status,
                    INSERTED.DateLost

                VALUES
                (
                    @UserID,
                    @CategoryID,
                    @LocationID,
                    @ItemName,
                    @Description,
                    @Color,
                    @Brand,
                    @DateLost,
                    @Status,
                    GETDATE()
                )
            `);


        return res.status(201).json({

            success: true,

            message: "Lost item reported successfully",

            item: result.recordset[0]

        });


    } catch (error) {

        console.error("Report lost item error:", error);

        return res.status(500).json({

            success: false,

            message: "Failed to report lost item",

            error: error.message

        });

    }

};


// ========================================
// GET MY REPORTS
// ========================================

const getMyReports = async (req, res) => {

    try {

        const userID = parseInt(req.query.userID);

        if (!userID) {
            return res.status(400).json({
                success: false,
                message: "User ID is required"
            });
        }

        const pool = await poolPromise;

        // Get user's lost items
        const lostResult = await pool
            .request()
            .input("UserID", sql.Int, userID)
            .query(`
                SELECT
                    L.LostItemID AS ItemID,
                    'Lost' AS ReportType,
                    L.ItemName,
                    L.Description,
                    L.Color,
                    L.Brand,
                    L.DateLost AS ReportDate,
                    L.Status,
                    C.CategoryName,
                    LOC.LocationName,
                    L.CreatedAt
                FROM LostItems L
                INNER JOIN Categories C
                    ON L.CategoryID = C.CategoryID
                INNER JOIN Locations LOC
                    ON L.LocationID = LOC.LocationID
                WHERE L.UserID = @UserID
            `);


        // Get user's found items
        const foundResult = await pool
            .request()
            .input("UserID", sql.Int, userID)
            .query(`
                SELECT
                    F.FoundItemID AS ItemID,
                    'Found' AS ReportType,
                    F.ItemName,
                    F.Description,
                    F.Color,
                    F.Brand,
                    F.DateFound AS ReportDate,
                    F.Status,
                    C.CategoryName,
                    LOC.LocationName,
                    F.CreatedAt
                FROM FoundItems F
                INNER JOIN Categories C
                    ON F.CategoryID = C.CategoryID
                INNER JOIN Locations LOC
                    ON F.LocationID = LOC.LocationID
                WHERE F.UserID = @UserID
            `);


        const reports = [
            ...lostResult.recordset,
            ...foundResult.recordset
        ];


        // Latest reports first
        reports.sort(
            (a, b) =>
                new Date(b.CreatedAt) -
                new Date(a.CreatedAt)
        );


        return res.status(200).json({
            success: true,
            count: reports.length,
            reports: reports
        });


    } catch (error) {

        console.error(
            "Get my reports error:",
            error
        );

        return res.status(500).json({
            success: false,
            message: "Failed to fetch reports",
            error: error.message
        });
    }
};
// ========================================
// SEARCH LOST AND FOUND ITEMS
// ========================================

const searchItems = async (req, res) => {

    try {

        const {
            keyword,
            category,
            location,
            type
        } = req.query;

        const pool = await poolPromise;

        const searchKeyword = keyword || "";
        const searchCategory = category || "";
        const searchLocation = location || "";


        // ================================
        // SEARCH LOST ITEMS
        // ================================

        const lostResult = await pool
            .request()

            .input(
                "Keyword",
                sql.VarChar(255),
                `%${searchKeyword}%`
            )

            .input(
                "Category",
                sql.VarChar(100),
                searchCategory
            )

            .input(
                "Location",
                sql.VarChar(100),
                searchLocation
            )

            .query(`
                SELECT
                    L.LostItemID AS ItemID,
                    'Lost' AS ItemType,
                    L.ItemName,
                    L.Description,
                    L.Color,
                    L.Brand,
                    L.DateLost AS ItemDate,
                    L.Status,
                    C.CategoryName,
                    LOC.LocationName
                FROM LostItems L

                INNER JOIN Categories C
                    ON L.CategoryID = C.CategoryID

                INNER JOIN Locations LOC
                    ON L.LocationID = LOC.LocationID

                WHERE
                    (
                        L.ItemName LIKE @Keyword
                        OR L.Description LIKE @Keyword
                        OR L.Color LIKE @Keyword
                        OR L.Brand LIKE @Keyword
                    )

                    AND
                    (
                        @Category = ''
                        OR C.CategoryName = @Category
                    )

                    AND
                    (
                        @Location = ''
                        OR LOC.LocationName = @Location
                    )
            `);


        // ================================
        // SEARCH FOUND ITEMS
        // ================================

        const foundResult = await pool
            .request()

            .input(
                "Keyword",
                sql.VarChar(255),
                `%${searchKeyword}%`
            )

            .input(
                "Category",
                sql.VarChar(100),
                searchCategory
            )

            .input(
                "Location",
                sql.VarChar(100),
                searchLocation
            )

            .query(`
                SELECT
                    F.FoundItemID AS ItemID,
                    'Found' AS ItemType,
                    F.ItemName,
                    F.Description,
                    F.Color,
                    F.Brand,
                    F.DateFound AS ItemDate,
                    F.Status,
                    C.CategoryName,
                    LOC.LocationName
                FROM FoundItems F

                INNER JOIN Categories C
                    ON F.CategoryID = C.CategoryID

                INNER JOIN Locations LOC
                    ON F.LocationID = LOC.LocationID

                WHERE
                    (
                        F.ItemName LIKE @Keyword
                        OR F.Description LIKE @Keyword
                        OR F.Color LIKE @Keyword
                        OR F.Brand LIKE @Keyword
                    )

                    AND
                    (
                        @Category = ''
                        OR C.CategoryName = @Category
                    )

                    AND
                    (
                        @Location = ''
                        OR LOC.LocationName = @Location
                    )
            `);


        let results = [
            ...lostResult.recordset,
            ...foundResult.recordset
        ];


        // Filter Lost / Found if selected
        if (type === "Lost" || type === "Found") {

            results = results.filter(
                item => item.ItemType === type
            );

        }


        return res.status(200).json({

            success: true,

            count: results.length,

            items: results

        });


    } catch (error) {

        console.error(
            "Search items error:",
            error
        );

        return res.status(500).json({

            success: false,

            message: "Failed to search items",

            error: error.message

        });

    }

};
module.exports = {
    reportLostItem,
    getMyReports,
    searchItems
};