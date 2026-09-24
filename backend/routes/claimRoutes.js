const express = require("express");

const {
    createClaim,
    getMyClaims,
    getAllClaims,
    approveClaim,
    rejectClaim
} = require("../controllers/claimController");

const router = express.Router();

router.post("/", createClaim);

router.get("/", getMyClaims);

router.get("/all", getAllClaims);

router.put("/:claimID/approve", approveClaim);

router.put("/:claimID/reject", rejectClaim);

module.exports = router;
