/**
 * Route for bank.
 */
"use strict";

const express = require("express");
const router = express.Router();
const bank = require("../src/bank.js");

router.get("/index", (req, res) => {
    let data = {
        title: "Welcome | The Bank",
    };

    res.render("bank/index", data);
});

router.get("/balance", async (req, res) => {
    let data = {
        title: "Account balance | The Bank",
    };

    data.res = await bank.showBalance();
    // console.info(data.res);
    res.render("bank/balance", data);
});

router.get("/move-to-adam", async (req, res) => {
    let data = {
        title: "Move to Adam | The Bank",
    };

    data.res = await bank.MoveToAdam();
    console.info("data respons", data.res);
    res.render("bank/move-to-adam", data);
});

module.exports = router;
