const { sql, poolPromise } = require("../config/db");

async function searchItems(req, res) {

    try {

        const {
            keyword = "",
            color = "",
            brand = "",
            category = "",
            location = "",
            type = ""
        } = req.query;

        const pool = await poolPromise;

        const lostQuery = `
            SELECT
                L.LostItemID AS ItemID,
                L.ItemName,
                L.Description,
                L.Color,
                L.Brand,
                L.Status,
                L.DateLost AS ItemDate,
                C.CategoryName,
                LC.LocationName,
                'Lost' AS ItemType
            FROM LostItems L
            INNER JOIN Categories C
                ON L.CategoryID = C.CategoryID
            INNER JOIN Locations LC
                ON L.LocationID = LC.LocationID
            WHERE
                (
                    @keyword = ''
                    OR L.ItemName LIKE '%' + @keyword + '%'
                    OR L.Description LIKE '%' + @keyword + '%'
                )
                AND
                (
                    @color = ''
                    OR L.Color LIKE '%' + @color + '%'
                )
                AND
                (
                    @brand = ''
                    OR L.Brand LIKE '%' + @brand + '%'
                )
                AND
                (
                    @category = ''
                    OR C.CategoryName = @category
                )
                AND
                (
                    @location = ''
                    OR LC.LocationName = @location
                )
        `;

        const foundQuery = `
            SELECT
                F.FoundItemID AS ItemID,
                F.ItemName,
                F.Description,
                F.Color,
                F.Brand,
                F.Status,
                F.DateFound AS ItemDate,
                C.CategoryName,
                LC.LocationName,
                'Found' AS ItemType
            FROM FoundItems F
            INNER JOIN Categories C
                ON F.CategoryID = C.CategoryID
            INNER JOIN Locations LC
                ON F.LocationID = LC.LocationID
            WHERE
                (
                    @keyword = ''
                    OR F.ItemName LIKE '%' + @keyword + '%'
                    OR F.Description LIKE '%' + @keyword + '%'
                )
                AND
                (
                    @color = ''
                    OR F.Color LIKE '%' + @color + '%'
                )
                AND
                (
                    @brand = ''
                    OR F.Brand LIKE '%' + @brand + '%'
                )
                AND
                (
                    @category = ''
                    OR C.CategoryName = @category
                )
                AND
                (
                    @location = ''
                    OR LC.LocationName = @location
                )
        `;

        let lostItems = [];
        let foundItems = [];

        if (type === "" || type === "Lost") {

            const lostResult = await pool.request()
                .input("keyword", sql.VarChar(255), keyword)
                .input("color", sql.VarChar(100), color)
                .input("brand", sql.VarChar(100), brand)
                .input("category", sql.VarChar(100), category)
                .input("location", sql.VarChar(100), location)
                .query(lostQuery);

            lostItems = lostResult.recordset;
        }

        if (type === "" || type === "Found") {

            const foundResult = await pool.request()
                .input("keyword", sql.VarChar(255), keyword)
                .input("color", sql.VarChar(100), color)
                .input("brand", sql.VarChar(100), brand)
                .input("category", sql.VarChar(100), category)
                .input("location", sql.VarChar(100), location)
                .query(foundQuery);

            foundItems = foundResult.recordset;
        }

        const items = [...lostItems, ...foundItems];

        items.sort(
            (a, b) =>
                new Date(b.ItemDate) - new Date(a.ItemDate)
        );

        res.json({
            success: true,
            count: items.length,
            items
        });

    } catch (error) {

        console.error("Search items error:", error);

        res.status(500).json({
            success: false,
            message: "Unable to search items.",
            error: error.message
        });
    }
}

module.exports = {
    searchItems
};
