/**
 * A module exporting functions to access the bank database.
 */
"use strict";

module.exports = {
    showBalance: showBalance,
    MoveToAdam: MoveToAdam,
};

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
 * @async
 * @returns {RowDataPacket} Resultset from the transaction.
 */
async function MoveToAdam() {
    let info = await findAllInTable("account");
    return moveMoneyToAdam(info);
    console.info("Moved");
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
    // console.info(`SQL: ${sql} (${table}) got ${res.length} rows.`);

    return res;
}

/**
 * Show all entries in the selected table.
 *
 * @async
 * @param {string} table A valid table name.
 * @param {RowDataPacket} res from the transaction.
 *
 * @returns {boolean}  true if the transaction has been successful.
 */
async function moveMoneyToAdam(info) {
    // let sql = `SELECT * FROM ??;`;
    let res = false;
    if (info[1].balance > 1.5) {
        let sql = `
        START TRANSACTION;

        UPDATE account
        SET
            balance = balance + 1.5
        WHERE
            id = ?;

        UPDATE account
        SET
            balance = balance - 1.5
        WHERE
            id = ?;

        COMMIT;`;
        res = await db.query(sql, [info[0].id, info[1].id]);
    }

    // res = await db.query(sql, [table]);
    // console.info(`SQL: ${sql} (${table}) got ${res.length} rows.`);

    // db.beginTransaction(function (err) {
    //     if (err) {
    //       console.log("w11");
    //         throw err;
    //     }
    //     db.query('INSERT INTO account values(3, "Ali", 5)', function (error, results, fields) {
    //         console.log(results);
    //         if (error) {
    //             return db.rollback(function () {
    //                 throw error;
    //             });
    //         }

    //         db.commit(function (err) {
    //             if (err) {
    //                 return db.rollback(function () {
    //                     throw err;
    //                 });
    //             }
    //             res = true;
    //             console.log("success!");
    //         });

    //         // var log = "Post " + results.insertId + " added";

    //         // db.query("INSERT INTO account SET id=4, name = ?, balance = 5", log, function (error, results, fields) {
    //         //     if (error) {
    //         //         return db.rollback(function () {
    //         //             throw error;
    //         //         });
    //         //     }

    //         // });
    //     });
    // });

    return res;
}
