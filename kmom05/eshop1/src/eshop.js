/**
 * A module exporting functions to access the eshop database.
 */
"use strict";
const { v4: uuidv4 } = require('uuid');

module.exports = {
    createCategory: createCategory,
    getCategories: getCategories,
    getCategory: getCategory,
    editCategory: editCategory,
    deleteCategory: deleteCategory,
    createProduct: createProduct,
    getProducts: getProducts,
    getProduct: getProduct,
    editProduct: editProduct,
    deleteProduct: deleteProduct,
    addInventoryLog: addInventoryLog,
    getProductIDByProductName: getProductIDByProductName,
    getCustomers: getCustomers,
    getOrders: getOrders,
    getCustomerById: getCustomerById,
    createOrder: createOrder,
    getProductDetails: getProductDetails,
    insertOrderItem: insertOrderItem,
    updateOrderStatus: updateOrderStatus,
    softDeleteOrder: softDeleteOrder,
    getundercategory: getundercategory
};

const mysql = require("promise-mysql");
const config = require("../config/db/eshop.json");
let db;

/**
 * Main function.
 * @async
 * @returns void
 */
(async function () {
    db = await mysql.createConnection(config);

    process.on("exit", () => {
        db.end();
    });
})();

/**
 * Create a category.
 *
 * @async
 * @param {string} name             The name of the category.
 * @param {string} description      The description of the category.
 * @param {string} price            The price in the category.
 * @param {string} stock            The stock in the category.
 *
 * @returns {RowDataPacket} Resultset from the query.
 */
async function createCategory(name) {
    let sql = `CALL p_create_category(?);`;

    let res = await db.query(sql, [name]);

    return res;
}

/**
 * Show all entries in the selected table.
 *
 * @async
 *
 * @returns {RowDataPacket} Resultset from the query.
 */
async function getCategories() {
    let sql = `CALL p_get_categories();`;

    let res = await db.query(sql);

    return res[0];
}

/**
 * Get details on an category.
 *
 * @async
 *
 * @param {string} id      The id of the category.
 *
 * @returns {RowDataPacket} Resultset from the query.
 */
async function getCategory(id) {
    let sql = `CALL p_get_category(?);`;

    let res = await db.query(sql, [id]);

    return res[0][0];
}

/**
 * Edit details of a category.
 *
 * @async
 * @param {string} id      The id of the category to be updated.
 * @param {string} name    The updated name of the category.
 * @param {string} price   The updated price in the category.
 * @param {string} stock   The updated stock in the category.
 *
 * @returns {RowDataPacket} Resultset from the query.
 */
async function editCategory(id, name) {
    let sql = `CALL p_edit_category(?, ?);`;

    let res = await db.query(sql, [id, name]);


    return res;
}

/**
 * Delete an category.
 *
 * @async
 * @param {string} id      The id of the category to be updated.
 *
 * @returns {RowDataPacket} Resultset from the query.
 */
async function deleteCategory(id) {
    let sql = `CALL p_delete_category(?);`;

    let res = await db.query(sql, [id]);

    console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res;
}

/**
 * Create a product.
 *
 * @async
 * @param {string} name             The name of the product.
 * @param {string} description      The description of the product.
 * @param {string} price            The price in the product.
 * @param {string} stock            The stock in the product.
 *
 * @returns {RowDataPacket} Resultset from the query.
 */
async function createProduct(name, description, price, stock) {
    let sql = `CALL p_create_product(?, ?, ?, ?);`;

    await db.query(sql, [name, description, price, stock]);

    let productIdQuery = 'SELECT @productId AS productId;';

    let productIdResult = await db.query(productIdQuery);

    console.log('productIdResult:', productIdResult[0].productId);
    // Check the structure of productIdResult

    return productIdResult[0].productId;
}

/**
 * Get all products.
 *
 * @async
 *
 * @returns {RowDataPacket} Resultset from the query.
 */
async function getProducts() {
    let sql = `CALL p_get_products();`;

    let res = await db.query(sql);

    console.info(`SQL: ${sql} got ${res.length} rows.`);

    return res[0];
}

/**
 * Get details on an product.
 *
 * @async
 *
 * @param {string} id      The id of the product.
 *
 * @returns {RowDataPacket} Resultset from the query.
 */
async function getProduct(id) {
    let sql = `CALL p_get_product(?);`;

    let res = await db.query(sql, [id]);

    return res[0][0];
}

/**
 * Edit details of a product.
 *
 * @async
 * @param {string} id      The id of the product to be updated.
 * @param {string} name    The updated name of the product.
 * @param {string} price   The updated price in the product.
 * @param {string} stock   The updated stock in the product.
 *
 * @returns {RowDataPacket} Resultset from the query.
 */
async function editProduct(id, name, description, price, stock) {
    let sql = `CALL p_edit_product(?, ?, ?, ?, ?);`;

    let res = await db.query(sql, [id, name, description, price, stock]);

    return res;
}

/**
 * Delete an product.
 *
 * @async
 * @param {string} id      The id of the product to be updated.
 *
 * @returns {RowDataPacket} Resultset from the query.
 */
async function deleteProduct(id) {
    let sql = `CALL p_delete_product(?);`;

    let res = await db.query(sql, [id]);

    console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res;
}

function generateUUID() {
    return uuidv4();
}

async function generateEventInstanceId() {
    return generateUUID();
}
async function addInventoryLog(id, eventDescription, eventDate) {
    // Generate Event_instance_id
    const eventInstanceId = await generateEventInstanceId(id);

    const sql = 'CALL p_add_inventory_log_procedure(?, ?, ?)';

    const result = await db.query(sql, [ eventInstanceId, eventDescription, eventDate]);

    return result;
}

function getProductIDByProductName(productName) {
    return new Promise((resolve, reject) => {
        const query = 'SELECT product_id FROM product WHERE product_name = ?';

        db.query(query, [productName], (error, results) => {
            if (error) {
                reject(error);
            } else {
                // If results are found, resolve with product_id, otherwise resolve with null
                const productId = results.length > 0 ? results[0].product_id : null;

                resolve(productId);
            }
        });
    });
}

// get all customers
async function getCustomers() {
    let sql = `CALL p_show_all_customers();`;
    let res = await db.query(sql);

    console.info(`SQL: ${sql} got ${res.length} rows.`);

    return res[0];
}

// get all orders
async function getOrders() {
    let sql = `CALL p_show_orders_with_totals();`;

    let res = await db.query(sql);

    return res[0];
}

async function getCustomerById(customerId) {
    const sql = 'CALL p_show_customer_by_id(?)';

    let res;

    res = await db.query(sql, [customerId]);
    return res[0];
}

async function createOrder(ORDERDATE, TotalPrice, CustomerID, status) {
    let sql = `CALL p_insert_order(?, ?, ?, ?);`;

    let res = await db.query(sql, [ORDERDATE, TotalPrice, CustomerID, status]);

    return res;
}
async function getProductDetails(customerId) {
    const sql = 'CALL p_show_order_details(?);';

    let res;

    res = await db.query(sql, [customerId]);
    return res[0];
}

async function insertOrderItem(orderId, productId, price, quantity) {
    const result = await db.query(
        'INSERT INTO order_item (order_id, product_id, price, quantity) VALUES (?, ?, ?, ?)',
        [orderId, productId, price, quantity]
    );

    return result;
}


async function updateOrderStatus(id) {
    let sql = `CALL p_change_order_status(?);`;

    await db.query(sql, [id]);

    return 0;
}

async function softDeleteOrder(id) {
    let sql = ` CALL p_soft_delete_order(?);`;

    await db.query(sql, [id]);

    return 0;
}

async function getundercategory(id) {
    let sql = `CALL p_get_products_by_category(?);`;

    let res = await db.query(sql, [id]);

    return res[0];
}
