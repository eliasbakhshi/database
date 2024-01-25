/**
 * To verify that mysql is installed and is working.
 * Create a connection to the database and execute
 * a query without actually using the database.
 *
 * @author Elias Bakhshi
 *
 */
"use strict";

const f = require("./functions");

/**
 * Main function.
 *
 * @async
 * @returns void
 */
(async function () {
    const res = await f.searchAll();
	
    console.info(await f.getAsTable(res));
})();
