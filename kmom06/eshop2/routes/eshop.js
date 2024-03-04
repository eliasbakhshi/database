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

router.use(bodyParser.urlencoded({ extended: false }));

function formatDate(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const day = String(date.getDate()).padStart(2, "0");
    const hours = String(date.getHours()).padStart(2, "0");
    const minutes = String(date.getMinutes()).padStart(2, "0");
    const seconds = String(date.getSeconds()).padStart(2, "0");

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
        const { name, description, price, stock } = req.body;

        // Create the product and get the product ID
        const productId = await eShop.createProduct(name, description, price, stock);
        const eventDescription = `A new product was added with product ID '${productId}'`;

        // Add inventory log with the retrieved product ID
        await eShop.addInventoryLog(productId, eventDescription, formattedDate);

        res.redirect(`/eshop/product`);
    } catch (error) {
        console.error("Error:", error);
        res.status(500).send("An error occurred while creating the product.");
    }
});

router.post("/product/edit", urlencodedParser, async (req, res) => {
    const date = new Date();
    const formattedDate = formatDate(date);
    const eventDescription = `En ändring skedde  med produkt ID '${req.body.id}'`;

    await eshop.addInventoryLog(req.body.id, eventDescription, formattedDate);
    res.redirect(`/eshop/product/edit/${req.body.id}&edited=true`);
});

router.post("/product/delete", urlencodedParser, async (req, res) => {
    let result = await eShop.deleteProduct(req.body.id);
    const date = new Date();
    const formattedDate = formatDate(date);
    let eventDescription = `en borttagning skedde med produkt ID '${req.body.id}'`;

    await eshop.addInventoryLog(req.body.id, eventDescription, formattedDate);
    if (result.serverStatus !== 2) {
        console.info("Product not found.");
    }
    res.redirect("/eshop/product");
});

router.get("/order", async (req, res) => {
    let data = {
        title: "Order | eShop",
    };

    data.res = await eShop.getOrders();
    console.log(data.res);
    res.render("eshop/order/index", data);
});

router.get("/customer", async (req, res) => {
    let data = {
        title: "customer | eShop",
    };

    data.res = await eShop.getCustomers();
    console.log(data.res);
    res.render("eshop/customer/index", data);
});

router.get("/show/pro/:customerId", async (req, res) => {
    const customerId = req.params.customerId; // Retrieve customerId from route parameter

    try {
        let data = {
            title: "Show | eShop",
        };

        // Your logic to fetch customer details using the customerId
        // For example:
        data.res = await eshop.getCustomerById(customerId); // Assuming you have a Customer model
        res.render("eshop/customer/customer-info", data);
    } catch (error) {
        console.error("Error fetching customer details:", error);
        res.status(500).send("Internal Server Error");
    }
});

router.get("/order/create/:id", async (req, res) => {
    try {
        // Extract data from the request body
        // Use req.params to get the customerId from the URL parameter
        const customerId = req.params.id;
        const date = new Date();
        const formattedDate = formatDate(date);
        const status = "Created";
        const totalPrice = 0;

        // Call function to create the order in the database
        await eshop.createOrder(formattedDate, totalPrice, customerId, status);
        console.log("customerId:", customerId);

        // Redirect to a success page or render a success message
        res.redirect("/eshop/order"); // Corrected the URL for redirect
    } catch (error) {
        console.error("Error creating order:", error);
        res.status(500).send("Internal Server Error");
    }
});

router.get("/order/show/:id");

router.get("/order/show/:order_id", async (req, res) => {
    try {
        const orderId = req.params.order_id;
        const data = {
            title: "Add product | eShop",
            orderId: orderId, // Include orderId in the data object
        };

        // Assuming you have a function to fetch order details
        data.res = await eshop.getProductDetails(orderId);
        res.render("eshop/order/add-product", data); // Pass data object to render function
    } catch (error) {
        console.error("Error fetching order details:", error);
        res.status(500).send("Internal Server Error");
    }
});

router.get("/order/add-to-cart/:order_id", async (req, res) => {
    try {
        const orderId = req.params.order_id;
        const data = {
            title: "Add product | eShop",
            orderId: orderId,
        };

        data.res = await eshop.getProducts(); // Assuming you have a function to fetch products
        res.render("eshop/order/add-to-cart", data);
    } catch (error) {
        console.error("Error fetching order details:", error);
        res.status(500).send("Internal Server Error");
    }
});

router.post("/order/show/create/:order_id", async (req, res) => {
    const orderId = req.params.order_id;

    const { productId, price, quantity } = req.body;

    try {
        await eshop.insertOrderItem(orderId, productId, price, quantity);

        res.redirect(`/eshop/order`);
    } catch (error) {
        console.error("Error:", error);
        res.status(500).send("Failed to add product to order.");
    }
});

router.get("/order/status/:order_id", async (req, res) => {
    try {
        const orderId = req.params.order_id;
        const data = {
            title: "Add product | eShop",
        };

        // Here you can retrieve the order status based on orderId
        // let's assume you have a function to fetch the order status from the database
        await eShop.updateOrderStatus(orderId);

        // Render the order status page with the retrieved order status
        res.render(`eshop/order/thank-you`, data);
    } catch (error) {
        console.error("Error fetching order status:", error);
        res.status(500).send("Internal Server Error");
    }
});

router.get("/order/delete/:order_id", async (req, res) => {
    const orderId = req.params.order_id;

    try {
        // Execute SQL statement to update the `deleted_at` column in the `order` table
        await eshop.softDeleteOrder(orderId);
        res.redirect("/eshop/order");
    } catch (error) {
        console.error("Error deleting product from order:", error);
        res.status(500).send("Failed to delete product from order.");
    }
});

module.exports = router;
