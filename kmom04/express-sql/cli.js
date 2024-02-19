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
        let amount = 1.5,
            from = "",
            to = "",
            ok = false;

        if (line.length == 3 || line.length > 4) {
            // if the length does not matches.
            console.info("Arguments are not right.");
        } else if (line.length == 1) {
            // if the length is 1
            (from = "Adam"), (to = "Eva"), (ok = true);
        } else if (line.length == 2) {
            // if the length is 2
            amount = parseFloat(line[1]);
            (from = "Adam"), (to = "Eva"), (ok = true);
        } else if (line.length == 4) {
            // if the length is more than 4
            amount = parseFloat(line[1]);
            from = line[2];
            to = line[3];
            ok = true;
        }

        if (ok) {
            /* eslint-disable max-len */
            let { fromAccount: f, toAccount: t, successful } = await bank.MoveMoney(from, to, amount);

            if (successful) {
                console.info(`(Move ${amount} money from ${f.id} to ${t.id}.)`);
                console.info(`${t.name} got ${amount} pengar, ${t.name} is currently checking out her account balance.`);
            } else {
                console.info(`${f.name} has not enough money to transfer to ${t.name}`);
            }
            /* eslint-enable max-len */
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
        `  exit ------------------------> quit, ctrl-d - to exit the program.\n` +
        `  help, menu ------------------> to show this menu.\n` +
        `  move ------------------------> Move 1.5 peng to Eva.\n` +
        `  move <amount> ---------------> Move amount peng to Eva.\n` +
        `  move <amount> <from> <to> ---> Move amount peng from one person to another.\n`);
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
