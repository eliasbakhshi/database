/**
 * All functions stores here.
 *
 * @author Elias Bakhshi
 */
"use strict";

const mysql = require("promise-mysql");
const config = require("./config.json");
const { table } = require("table");

/**
 * Output resultset as formatted table with details on teachers.
 *
 * @param {Array} res Resultset with details on from database query.
 *
 * @returns {string} Formatted table to print out.
 */
function getAsTable(res) {
    let data = [["Akronym", "Namn", "Avdelning", "Lön", "Komp", "Född"]];

    // Add each teacher's information in the array
    for (const row of res) {
        /* eslint-disable max-len */
        data.push([row.akronym, row.fornamn + " " + row.efternamn, row.avdelning, row.lon.toString(), row.kompetens.toString(), row.fodd.toString()]);
        /* eslint-enable max-len */
    }
    return table(data);
}

/**
 * Output result set as formatted table with details on a teacher.
 *
 * @async
 * @param {connection} db     Database connection.
 * @param {string}     search String to search for.
 *
 * @returns {string} Formatted table to print out.
 */
async function searchLike(search) {
    const db = await mysql.createConnection(config);

    let like = `%${search}%`;

    console.info(`Searching for: ${search}`);

    let sql = `
        SELECT
          akronym,
          fornamn,
          efternamn,
          avdelning,
          lon,
          kompetens,
          DATE_FORMAT(fodd,"%Y-%m-%d") as fodd
        FROM larare
        WHERE
            akronym LIKE ?
            OR fornamn LIKE ?
            OR efternamn LIKE ?
            OR avdelning LIKE ?
            OR kompetens LIKE ?
            OR lon = ?
        ORDER BY akronym;
    `;
    let res = await db.query(sql, [like, like, like, like, like, search]);

    db.end();

    return res;
}

/**
 * Output resultset as formatted table with details on a teacher.
 *
 * @async
 * @param {connection} db     Database connection.
 * @param {string}     search String to search for.
 *
 * @returns {string} Formatted table to print out.
 */
async function searchBetween(min, max) {
    const db = await mysql.createConnection(config);

    console.info(`Searching for values between ${min} - ${max}`);

    let sql = `
      SELECT
            akronym,
            fornamn,
            efternamn,
            avdelning,
            lon,
            kompetens,
            DATE_FORMAT(fodd,"%Y-%m-%d") as fodd
          FROM larare
          WHERE
              kompetens BETWEEN ? AND ?
              OR lon BETWEEN ? AND ?
          ORDER BY akronym;
      `;
    let res = await db.query(sql, [min, max, min, max]);

    db.end();

    return res;
}

/**
 * Output resultset as formatted table with details on a teacher.
 *
 * @async
 * @param {connection} db     Database connection.
 * @param {string}     search String to search for.
 *
 * @returns {string} Formatted table to print out.
 */
async function searchAll() {
    const db = await mysql.createConnection(config);

    console.info(`Searching for all teachers.`);

    let sql = `
        SELECT
            akronym,
            fornamn,
            efternamn,
            avdelning,
            lon,
            kompetens,
            DATE_FORMAT(fodd,"%Y-%m-%d") as fodd
        FROM larare
        ORDER BY akronym;
    `;
    let res = await db.query(sql);

    db.end();
    return res;
}

module.exports = {
    searchBetween: searchBetween,
    searchLike: searchLike,
    searchAll: searchAll,
    getAsTable: getAsTable,
};
