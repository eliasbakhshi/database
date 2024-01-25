/**
 * A simple test program.
 *
 * @author Elias Bakhshi
 */
"use strict";

const f = require("./functions");
// Read from command line
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
    rl.question("Enter minimum value? ", async (min) => {
        rl.question("Enter maximum value? ", async (max) => {
            const res = await f.searchBetween(min, max);

            console.info(await f.getAsTable(res));

            rl.close();
        });
    });
})();
