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

// // Promisify rl.question to question
// const util = require("util");
//
// rl.question[util.promisify.custom] = (arg) => {
//     return new Promise((resolve) => {
//         rl.question(arg, resolve);
//     });
// };
// const question = util.promisify(rl.question);

// Import the game module
const Teacher = require("./src/Teacher");
const teacher = new Teacher();

/**
 * Main function.
 *
 * @returns void
 */
(function () {
    rl.on("close", exitProgram);
    rl.on("line", handleInput);

    showMenu();

    rl.setPrompt("Your choice: ");
    rl.prompt();
})();

/**
 * Handle input as a command and send it to a function that deals with it.
 *
 * @param {string} line The input from the user.
 *
 * @returns {void}
 */
function handleInput(line) {
    line = line.trim();
    if (line.search("quit") || line.search("exit")) {
        process.exit();
    } else if (line.search("help") || line.search("menu")) {
        showMenu();
    } else if (line.search("larare") ) {

    } else if (line.search("kompetens") ) {

    } else if (line.search("lon") ) {

    } else if (line.search("sok") ) {

    } else if (line.search("nylon") ) {

    }
    rl.prompt();
}

/**
 * Show the menu on that can be done.
 *
 * @returns {void}
 */
function showMenu() {
    console.info(
        ` You can choose from the following commands.\n` +
        `  exit ------------------> quit, ctrl-d - to exit the program.\n` +
        `  help, menu ------------> to show this menu.\n` +
        `  larare ----------------> show the current number.\n` +
        `  kompetens -------------> randomize a new number.\n` +
        `  lon -------------------> randomize a new number.\n` +
        `  sok <word> ------------> randomize a new number.\n` +
        `  nylon <akronym> <lon> -> update the salary.\n`);
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
