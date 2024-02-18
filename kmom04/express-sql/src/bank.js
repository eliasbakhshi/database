/**
 * A module exporting functions to access the bank database.
 */
"use strict";

const mysql = require("promise-mysql");
const config = require("../config/db/bank.json");
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
 * Show all entries in the account table.
 *
 * @async
 * @returns {RowDataPacket} Resultset from the query.
 */
async function showBalance() {
    return findAllInTable("account");
}

/**
 * Update amount in the tables.
 *
 * @param {string} from Start account name.
 * @param {string} to Destination account name.
 * @param {number} amount A valid amount name.
 *
 * @async
 * @returns {RowDataPacket} Resultset from the transaction.
 */
async function MoveMoney(from, to, amount) {
    amount = amount || 1.5;
    if (amount < 0) {
        amount = 0;
    }

    let info = await findAllInTable("account");
    let fromAccount = info.find((o) => o.name.toLowerCase() === from.toLowerCase());
    let toAccount = info.find((o) => o.name.toLowerCase() === to.toLowerCase());
    let res = await startTransaction(fromAccount, toAccount, amount);

    if (res) {
        return { fromAccount, toAccount, successful: true };
    }
    return { fromAccount, toAccount, successful: false };
}

/**
 * Show all entries in the selected table.
 *
 * @async
 * @param {string} table A valid table name.
 *
 * @returns {RowDataPacket} Resultset from the query.
 */
async function findAllInTable(table) {
    let sql = `SELECT * FROM ??;`;
    let res;

    res = await db.query(sql, [table]);

    return res;
}

/**
 * Show all entries in the selected table.
 *
 * @async
 * @param {RowDataPacket} fromAccount Start account.
 * @param {RowDataPacket} toAccount Destination account.
 * @param {number} amount A valid amount name.
 *
 * @returns {boolean}  true if the transaction has been successful.
 */
async function startTransaction(fromAccount, toAccount, amount) {
    let res = false;

    if (fromAccount.balance > amount) {
        let sql = `
        START TRANSACTION;

        UPDATE account
        SET
            balance = balance - ?
        WHERE
            id = ?;

        UPDATE account
        SET
            balance = balance + ?
        WHERE
            id = ?;

        COMMIT;`;

        res = await db.query(sql, [amount, fromAccount.id, amount, toAccount.id]);
        if (res) {
            res = true;
        }
    }

    return res;
}

module.exports = {
    showBalance: showBalance,
    MoveMoney: MoveMoney,
};
