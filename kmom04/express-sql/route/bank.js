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

    data.res = await bank.MoveMoney("Eva", "Adam");
    if (data.res) {
        data.message = `Adam got 1.5 pengar, Adam is currently checking out her account blance.`;
    } else {
        data.message = `Eva has not enough money to transfer to Adam`;
    }
    res.render("bank/move-to-adam", data);
});

module.exports = router;
