const express = require("express");

const {
    reportLostItem,
    getMyReports
} = require("../controllers/itemController");

const { searchItems } = require("../controllers/searchController");

const router = express.Router();

router.post("/lost", reportLostItem);

router.get("/my-reports", getMyReports);

router.get("/search", searchItems);

module.exports = router;
