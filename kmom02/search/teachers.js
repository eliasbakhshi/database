/**
 * To verify that mysql is installed and is working.
 * Create a connection to the database and execute
 * a query without actually using the database.
 */
"use strict";

const mysql = require("promise-mysql");
const config = require("./config.json");
/**
 * Main function.
 * @async
 * @returns void
 */
(async function () {
  const db = await mysql.createConnection(config);

  let sql = `
        SELECT
            akronym,
            fornamn,
            efternamn,
            avdelning,
            lon
        FROM larare
        ORDER BY akronym;
    `;
  let res = await db.query(sql);

//   res = JSON.stringify(res, null, 4);
  // Output as formatted text in table
  let str;

  console.log(res);
  str = "+-----------+---------------------+-----------+----------+\n";
  str += "| Akronym   | Namn                | Avdelning |   Lön    |\n";
  str += "|-----------|---------------------|-----------|----------|\n";
  for (const row of res) {
    str += "| ";
    str += row.akronym.padEnd(10);
    str += "| ";
    str += (row.fornamn + " " + row.efternamn).padEnd(20);
    str += "| ";
    str += row.avdelning.padEnd(10);
    str += "| ";
    str += row.lon.toString().padStart(8);
    str += " |\n";
  }
  str += "+-----------+---------------------+-----------+----------+\n";
  console.info(str);

  db.end();
})();
