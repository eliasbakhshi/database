/**
 * Show teachers and their departments.
 *
 * @author Elias Bakhshi
 *
 */
"use strict";

const f = require("./functions");
// Read from commandline
const readline = require("readline");
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
});

/**
 * Main function.
 *
 * @async
 * @returns void
 */
(async function () {
    // Ask question and handle answer in async arrow function callback.
    rl.question("What to search for? ", async (search) => {
        const res = await f.searchLike(search);

        console.info(await f.getAsTable(res));

        rl.close();
    });
})();
