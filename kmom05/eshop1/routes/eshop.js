/**
 * Route for eshop.
 */
"use strict";

const express = require("express");
const router = express.Router();
const eShop = require("../src/eshop.js");
const bodyParser = require("body-parser");
const eshop = require("../src/eshop.js");
const urlencodedParser = bodyParser.urlencoded({ extended: false });


function formatDate(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const seconds = String(date.getSeconds()).padStart(2, '0');

    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
}

router.get("/index", (req, res) => {
    let data = {
        title: "Welcome | eShop",
    };

    res.render("eshop/index", data);
});

router.get("/about", async (req, res) => {
    let data = {
        title: "About | eShop",
    };

    res.render("eshop/about", data);
});

router.get("/category", async (req, res) => {
    let data = {
        title: "Category | eShop",
    };

    data.res = await eShop.getCategories();
    console.log(data.res);
    res.render("eshop/category/index", data);
});

router.get("/category/create", async (req, res) => {
    let data = {
        title: "Create a category | eShop",
    };

    res.render("eshop/category/create", data);
});

router.get("/category/edit/:id&:edited", async (req, res) => {
    let id = req.params.id;
    let edited = req.params.edited;
    let data = {
        title: "Edit category balance | eShop",
    };

    if (edited) {
        data.edited = true;
    }
    data.res = await eShop.getCategory(id);
    res.render("eshop/category/edit", data);
});

router.get("/category/edit/:id", async (req, res) => {
    let id = req.params.id;
    let data = {
        title: "Edit category balance | eShop",
        edited: false,
    };

    data.res = await eShop.getCategory(id);
    
    res.render("eshop/category/edit", data);
});

router.get("/category/delete/:id", async (req, res) => {
    let id = req.params.id;
    let data = {
        title: "Delete category | eShop",
    };

    data.res = await eShop.getCategory(id);
    res.render("eshop/category/delete", data);
});

router.post("/category/create", urlencodedParser, async (req, res) => {
    await eShop.createCategory(req.body.name);
    res.redirect(`/eshop/category`);
});

router.post("/category/edit", urlencodedParser, async (req, res) => {
    await eShop.editCategory(req.body.id, req.body.name);
    res.redirect(`/eshop/category/edit/${req.body.id}&edited=true`);
});

router.post("/category/delete", urlencodedParser, async (req, res) => {
    let result = await eShop.deleteCategory(req.body.id);

    if (result.serverStatus !== 2) {
        console.info("category not found.");
    }
    res.redirect("/eshop/category");
});

router.get("/product", async (req, res) => {
    let data = { 
        title: "Products | eShop",
    };

    data.res = await eShop.getProducts();
    console.log(data.res);
    res.render("eshop/product/index", data);
});

router.get("/product/create", async (req, res) => {
    let data = {
        title: "Create a product | eShop",
    };


    res.render("eshop/product/create", data);
});

router.get("/product/edit/:id&:edited", async (req, res) => {
    let id = req.params.id;
    let edited = req.params.edited;
    let data = {
        title: "Edit product balance | eShop",
    };

    if (edited) {
        data.edited = true;
    }
    const date = new Date();

    const formattedDate = formatDate(date);
    data.res = await eShop.getProduct(id);

    res.render("eshop/product/edit", data);
});

router.get("/product/edit/:id", async (req, res) => {
    let id = req.params.id;
    let data = {
        title: "Edit product balance | eShop",
        edited: false,
    };

    data.res = await eShop.getProduct(id);
    res.render("eshop/product/edit", data);
});

router.get("/product/delete/:id", async (req, res) => {
    let id = req.params.id;
    let data = {
        title: "Delete product | eShop",
    };
 
    data.res = await eShop.getProduct(id);

    res.render("eshop/product/delete", data);
});

router.post("/product/create", urlencodedParser, async (req, res) => {
    try {
      const date = new Date();
      const formattedDate = formatDate(date);
      const name = req.body.name;
  
      // Create the product
      await eShop.createProduct(req.body.name, req.body.description, req.body.price, req.body.stock);
  
      // Get the product ID by product name
      const id = await eshop.getProductIDByProductName(name);
  
      // Add inventory log
      await eshop.addInventoryLog(id, `En ny produkt lades till med produkt ID '${id}'`, formattedDate);
  
      res.redirect(`/eshop/product`);
    } catch (error) {
      console.error('Error:', error);
      res.status(500).send('An error occurred while creating the product.');
    }
  });
  

router.post("/product/edit", urlencodedParser, async (req, res) => {
    const date = new Date();

    const formattedDate = formatDate(date);
    let result = await eShop.editProduct(req.body.id, req.body.name, req.body.description, req.body.price, req.body.stock);
    await eshop.addInventoryLog(req.body.id,
        `En ändring skedde  med produkt ID '${req.body.id}'`, formattedDate); 
    res.redirect(`/eshop/product/edit/${req.body.id}&edited=true`);
});

router.post("/product/delete", urlencodedParser, async (req, res) => {
    let result = await eShop.deleteProduct(req.body.id);
    const date = new Date();

    const formattedDate = formatDate(date);
    await eshop.addInventoryLog(req.body.id,
        `en borttagning skedde med produkt ID '${req.body.id}'`, formattedDate); 
    if (result.serverStatus !== 2) {
        console.info("Product not found.");
    }
    res.redirect("/eshop/product");
});

module.exports = router;
