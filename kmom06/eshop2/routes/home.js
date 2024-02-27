/**
 * Route for Home page.
 */
"use strict";

const express = require("express");
const router  = express.Router();

router.get("/", (req, res) => {
    let data = {
        title: "Welcome | Website"
    };

    res.render("index", data);
});

// For 404 page
router.use((req, res) => {
    let data = {
        title: "Nothing found | Website"
    };

    res.status(404).render('error404', data);
});

module.exports = router;
