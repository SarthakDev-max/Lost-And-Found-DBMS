const { sql, poolPromise } = require("../config/db");

async function createClaim(req, res) {
    try {
        const {
            foundItemID,
            userID,
            claimDescription
        } = req.body;

        if (!foundItemID || !userID || !claimDescription) {
            return res.status(400).json({
                success: false,
                message: "Found item, user and claim description are required."
            });
        }

        const pool = await poolPromise;

        // Check whether the found item exists
        const itemResult = await pool.request()
            .input("foundItemID", sql.Int, foundItemID)
            .query(`
                SELECT FoundItemID, Status
                FROM FoundItems
                WHERE FoundItemID = @foundItemID
            `);

        if (itemResult.recordset.length === 0) {
            return res.status(404).json({
                success: false,
                message: "Found item not found."
            });
        }

        // Prevent duplicate pending claim by same user
        const existingClaim = await pool.request()
            .input("foundItemID", sql.Int, foundItemID)
            .input("userID", sql.Int, userID)
            .query(`
                SELECT ClaimID
                FROM Claims
                WHERE FoundItemID = @foundItemID
                  AND UserID = @userID
                  AND Status = 'Pending'
            `);

        if (existingClaim.recordset.length > 0) {
            return res.status(409).json({
                success: false,
                message: "You already have a pending claim for this item."
            });
        }

        const result = await pool.request()
            .input("foundItemID", sql.Int, foundItemID)
            .input("userID", sql.Int, userID)
            .input("claimDescription", sql.VarChar(1000), claimDescription)
            .query(`
                INSERT INTO Claims
                (
                    FoundItemID,
                    UserID,
                    ClaimDescription,
                    ClaimDate,
                    Status
                )
                OUTPUT INSERTED.ClaimID
                VALUES
                (
                    @foundItemID,
                    @userID,
                    @claimDescription,
                    GETDATE(),
                    'Pending'
                )
            `);

        res.status(201).json({
            success: true,
            message: "Claim submitted successfully.",
            claimID: result.recordset[0].ClaimID
        });

    } catch (error) {
        console.error("Create claim error:", error);

        res.status(500).json({
            success: false,
            message: "Unable to submit claim.",
            error: error.message
        });
    }
}

async function getMyClaims(req, res) {
    try {
        const { userID } = req.query;

        if (!userID) {
            return res.status(400).json({
                success: false,
                message: "User ID is required."
            });
        }

        const pool = await poolPromise;

        const result = await pool.request()
            .input("userID", sql.Int, userID)
            .query(`
                SELECT
                    c.ClaimID,
                    c.FoundItemID,
                    c.UserID,
                    c.ClaimDescription,
                    c.ClaimDate,
                    c.Status,
                    f.ItemName,
                    f.Description,
                    f.Color,
                    f.Brand,
                    cat.CategoryName,
                    l.LocationName
                FROM Claims c
                INNER JOIN FoundItems f
                    ON c.FoundItemID = f.FoundItemID
                LEFT JOIN Categories cat
                    ON f.CategoryID = cat.CategoryID
                LEFT JOIN Locations l
                    ON f.LocationID = l.LocationID
                WHERE c.UserID = @userID
                ORDER BY c.ClaimDate DESC
            `);

        res.json({
            success: true,
            claims: result.recordset
        });

    } catch (error) {
        console.error("Get claims error:", error);

        res.status(500).json({
            success: false,
            message: "Unable to fetch claims.",
            error: error.message
        });
    }
}
async function getAllClaims(req, res) {
    try {

        const pool = await poolPromise;

        const result = await pool.request()
            .query(`
                SELECT
                    c.ClaimID,
                    c.FoundItemID,
                    c.UserID,
                    c.ClaimDescription,
                    c.ClaimDate,
                    c.Status,

                    u.FullName,
                    u.Email,

                    f.ItemName,
                    f.Description,
                    f.Color,
                    f.Brand,

                    cat.CategoryName,
                    l.LocationName

                FROM Claims c

                INNER JOIN Users u
                    ON c.UserID = u.UserID

                INNER JOIN FoundItems f
                    ON c.FoundItemID = f.FoundItemID

                LEFT JOIN Categories cat
                    ON f.CategoryID = cat.CategoryID

                LEFT JOIN Locations l
                    ON f.LocationID = l.LocationID

                ORDER BY c.ClaimDate DESC
            `);

        res.json({
            success: true,
            claims: result.recordset
        });

    } catch (error) {

        console.error("Get all claims error:", error);

        res.status(500).json({
            success: false,
            message: "Unable to fetch claims.",
            error: error.message
        });

    }
}
module.exports = {
    createClaim,
    getMyClaims,
    getAllClaims
};
/* =========================
   ADMIN CLAIM ACTIONS
========================= */

async function approveClaim(req, res) {

    try {

        const { claimID } = req.params;

        if (!claimID) {
            return res.status(400).json({
                success: false,
                message: "Claim ID is required."
            });
        }

        const pool = await poolPromise;

        const claimResult = await pool.request()
            .input("claimID", sql.Int, claimID)
            .query(`
                SELECT
                    ClaimID,
                    FoundItemID,
                    Status
                FROM Claims
                WHERE ClaimID = @claimID
            `);

        if (claimResult.recordset.length === 0) {

            return res.status(404).json({
                success: false,
                message: "Claim not found."
            });

        }

        const claim = claimResult.recordset[0];

        if (claim.Status !== "Pending") {

            return res.status(400).json({
                success: false,
                message: "Only pending claims can be approved."
            });

        }

        await pool.request()
            .input("claimID", sql.Int, claimID)
            .input("foundItemID", sql.Int, claim.FoundItemID)
            .query(`
                UPDATE Claims
                SET Status = 'Approved'
                WHERE ClaimID = @claimID;

                UPDATE FoundItems
                SET Status = 'Claimed'
                WHERE FoundItemID = @foundItemID;
            `);

        res.json({
            success: true,
            message: "Claim approved successfully."
        });

    } catch (error) {

        console.error("Approve claim error:", error);

        res.status(500).json({
            success: false,
            message: "Unable to approve claim.",
            error: error.message
        });

    }

}


async function rejectClaim(req, res) {

    try {

        const { claimID } = req.params;

        if (!claimID) {
            return res.status(400).json({
                success: false,
                message: "Claim ID is required."
            });
        }

        const pool = await poolPromise;

        const claimResult = await pool.request()
            .input("claimID", sql.Int, claimID)
            .query(`
                SELECT
                    ClaimID,
                    Status
                FROM Claims
                WHERE ClaimID = @claimID
            `);

        if (claimResult.recordset.length === 0) {

            return res.status(404).json({
                success: false,
                message: "Claim not found."
            });

        }

        const claim = claimResult.recordset[0];

        if (claim.Status !== "Pending") {

            return res.status(400).json({
                success: false,
                message: "Only pending claims can be rejected."
            });

        }

        await pool.request()
            .input("claimID", sql.Int, claimID)
            .query(`
                UPDATE Claims
                SET Status = 'Rejected'
                WHERE ClaimID = @claimID
            `);

        res.json({
            success: true,
            message: "Claim rejected successfully."
        });

    } catch (error) {

        console.error("Reject claim error:", error);

        res.status(500).json({
            success: false,
            message: "Unable to reject claim.",
            error: error.message
        });

    }

}



module.exports = {
    createClaim,
    getMyClaims,
    getAllClaims,
    approveClaim,
    rejectClaim
};
