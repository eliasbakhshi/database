/**
 * A module exporting functions to access the eshop database.
 */
"use strict";

module.exports = {
    getCategories: getCategories,
    getProducts: getProducts,
    getProduct: getProduct,
    deleteProduct: deleteProduct,
};

const mysql  = require("promise-mysql");
const config = require("../config/db/eshop.json");
let db;


/**
 * Main function.
 * @async
 * @returns void
 */
(async function() {
    db = await mysql.createConnection(config);

    process.on("exit", () => {
        db.end();
    });
})();

/**
 * Show all entries in the selected table.
 *
 * @async
 *
 * @returns {RowDataPacket} Resultset from the query.
 */
async function getCategories() {
    let sql = `CALL get_categories();`;
    let res;

    res = await db.query(sql);
    console.info(`SQL: ${sql} got ${res.length} rows.`);

    return res[0];
}

/**
 * Create a new account.
 *
 * @async
 *
 * @returns {void}
 */
async function getProducts() {
    let sql = `CALL get_products();`;
    let res;

    res = await db.query(sql);
    console.info(`SQL: ${sql} got ${res.length} rows.`);

    return res[0];
}



/**
 * Edit details on an account.
 *
 * @async
 * @param {string} id      The id of the account to be updated.
 * @param {string} name    The updated name of the account holder.
 * @param {string} balance The updated amount in the account.
 *
 * @returns {void}
 */
async function getProduct(id) {
    let sql = `CALL get_product(?);`;
    let res;

    res = await db.query(sql, [id]);
    //console.log(res);
    console.info(`SQL: ${sql} got ${res.length} rows.`);
}

/**
 * Delete an account.
 *
 * @async
 * @param {string} id      The id of the account to be updated.
 *
 * @returns {RowDataPacket} Resultset from the query.
 */
async function deleteProduct(id) {
    let sql = `CALL delete_product(?);`;
    let res;

    res = await db.query(sql, [id]);
    //console.log(res);
    console.info(`SQL: ${sql} got ${res.length} rows.`);
}
