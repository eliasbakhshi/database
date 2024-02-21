/**
 * Route for eshop.
 */
"use strict";

const express = require("express");
const router  = express.Router();
const eShop    = require("../src/eshop.js");
const bodyParser = require("body-parser");
const urlencodedParser = bodyParser.urlencoded({ extended: false });

router.get("/index", (req, res) => {
    let data = {
        title: "Welcome | eShop"
    };

    res.render("eshop/index", data);
});

router.get("/about", async (req, res) => {
    let data = {
        title: "About | eShop"
    };

    res.render("eshop/about", data);
});

router.get("/category", async (req, res) => {
    let data = {
        title: "Category | eShop"
    };

    data.res = await eShop.getCategories();

    res.render("eshop/category", data);
});

router.get("/product", async (req, res) => {
    let data = {
        title: "Products | eShop"
    };

    data.res = await eShop.getProducts();

    res.render("eshop/product/index", data);
});

router.get("/product/edit", async (req, res) => {
    let data = {
        title: "Edit product balance | eShop"
    };
    
    data.res = await eShop.getProduct(req.body.id);
    res.render("eshop/product/edit", data);
});

router.get("/product/delete", async (req, res) => {
    let data = {
        title: "Delete product | eShop"
    };

    data.res = await eShop.getProduct(req.body.id);
    res.render("eshop/product/delete", data);
});

router.post("/product/edit", async (req, res) => {
    await eShop.editProduct(req.body.id);
    res.redirect(`/product/edit/${req.body.id}`);
});

router.post("/product/delete", async (req, res) => {
    data.res = await eShop.deleteProduct(res.body.id);
    if (data.res === 0) {
        console.info("Product not found.");
    } else {
        res.redirect("/product/index");
    }
});




module.exports = router;
