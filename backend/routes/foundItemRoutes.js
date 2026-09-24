const express = require("express");

const {
    reportFoundItem
} = require("../controllers/foundItemController");

const router = express.Router();

// POST /api/items/found
router.post("/found", reportFoundItem);

module.exports = router;