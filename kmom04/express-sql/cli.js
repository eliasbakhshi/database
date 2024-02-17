/**
 * Guess my number, a sample CLI client.
 */
"use strict";

// Read from commandline
const readline = require("readline");
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
});
const bank = require("./src/bank.js");
const { move } = require("./route/bank.js");




/**
 * Main function.
 *
 * @returns void
 */
(function () {
    rl.on("close", exitProgram);
    rl.on("line", handleInput);

    showMenu();

    rl.setPrompt("\nBank: ");
    rl.prompt();
})();

/**
 * Handle input as a command and send it to a function that deals with it.
 *
 * @param {string} line The input from the user.
 *
 * @returns {void}
 */
async function handleInput(line) {
    line = line.trim().split(" ");

    if (line == "quit" || line[0] == "exit") {
        process.exit();
    } else if (line[0] == "help" || line[0] == "menu") {
        showMenu();
    } else if (line[0] == "move") {
        let {fromAccount, toAccount, successful} = await bank.MoveMoney("Adam", "Eva", 1.5);

        if (successful) {
            console.info(`(Move 1.5 money from ${fromAccount.id} to ${toAccount.id}.)`);
            console.info(`${toAccount.name} got 1.5 pengar, ${toAccount.name} is currently checking out her account balance.`);
        } else {
            console.info(`${fromAccount.name} has not enough money to transfer to ${toAccount.name}`);
        }
    }

    rl.prompt();
}

/**
 * Show the menu on that can be done.
 *
 * @returns {void}
 */
function showMenu() {
    console.clear();
    console.info(
        ` You can choose from the following commands.\n` +
        `  exit ------------------> quit, ctrl-d - to exit the program.\n` +
        `  help, menu ------------> to show this menu.\n` +
        `  move ------------------> Move 1.5 peng to Eva.\n`);
}


/**
 * Close down program and exit with a status code.
 *
 * @param {number} code Exit with this value, defaults to 0.
 *
 * @returns {void}
 */
function exitProgram(code) {
    code = code || 0;

    console.info("Exiting with status code " + code);
    process.exit(code);
}
