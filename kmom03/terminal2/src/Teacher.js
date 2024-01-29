/**
 * A module for game Guess the number I'm thinking of.
 */
"use strict";

const mysql = require("promise-mysql");
const config = require("./config.json");

class Teacher {
    /**
     * @constructor
     */
    constructor() {}

    /**
     * Output result set as formatted table with details on a teacher.
     *
     * @async
     * @param {connection} db     Database connection.
     * @param {string}     search String to search for.
     *
     * @returns {string} Formatted table to print out.
     */
    async getAllWithAge() {
        const db = await mysql.createConnection(config);
        let sql = `
        SELECT
            *
        FROM
            v_all_with_age
    `;
        let res = await db.query(sql);

        db.end();

        return res;
    }

    /**
     * Init the game and guess the number.
     *
     * @returns void
     */
    init() {
        this.thinking = Math.round(Math.random() * 100 + 1);
    }

    /**
     * Check if the guess is correct or not.
     *
     * @param {integer} guess The number being guessed.
     *
     * @returns {boolean} True if guess matches thinking, else false.
     */
    check(guess) {
        return guess === this.thinking;
    }

    /**
     * Return a string stating the correct number is "higher" or "lower"
     * than the current guess.
     *
     * @param {integer} guess The number being guessed.
     *
     * @returns {string} "higher" or "lower".
     */
    compare(guess) {
        return guess > this.thinking ? "lower" : "higher";
    }

    /**
     * Return the number Im thinking of.
     *
     * @returns {number} as current number.
     */
    cheat() {
        return this.thinking;
    }
}

module.exports = Teacher;
