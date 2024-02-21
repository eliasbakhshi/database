/**
 * A module exporting functions to access the eshop database.
 */
"use strict";

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
async function createCategory(name, description, price, stock) {
    let sql = `CALL create_product(?, ?, ?, ?);`;
    let res = await db.query(sql, [name, description, price, stock]);

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
    let sql = `CALL get_categories();`;
    let res = await db.query(sql);

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
async function getCategory(id) {
    let sql = `CALL get_product(?);`;
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
async function editCategory(id, name, description, price, stock) {
    let sql = `CALL edit_product(?, ?, ?, ?, ?);`;
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
async function deleteCategory(id) {
    let sql = `CALL delete_product(?);`;
    let res = await db.query(sql, [id]);
    console.log("2", res);
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
    let sql = `CALL create_product(?, ?, ?, ?);`;
    let res = await db.query(sql, [name, description, price, stock]);

    return res;
}

/**
 * Get all products.
 *
 * @async
 *
 * @returns {RowDataPacket} Resultset from the query.
 */
async function getProducts() {
    let sql = `CALL get_products();`;
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
    let sql = `CALL get_product(?);`;
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
    let sql = `CALL edit_product(?, ?, ?, ?, ?);`;
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
    let sql = `CALL delete_product(?);`;
    let res = await db.query(sql, [id]);
    console.log("2", res);
    console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res;
}
