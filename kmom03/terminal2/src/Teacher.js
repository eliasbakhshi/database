/**
 * A module for game Guess the number I'm thinking of.
 */
"use strict";

const mysql = require("promise-mysql");
const config = require("../config.json");

class Teacher {
    /**
     * @constructor
     */
    constructor() {}

    /**
     * Output result set as formatted table with details on teachers with their ages.
     *
     * @async
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

        let data = [["Akronym", "Avdelning", "Namn", "kon", "Lön", "Komp", "Ålder"]];

        // Add each teacher's information in the array
        for (const row of res) {
            /* eslint-disable max-len */
            data.push([
                row.akronym,
                row.avdelning,
                row.fornamn + " " + row.efternamn,
                row.kon,
                row.lon.toString(),
                row.kompetens.toString(),
                row.Ålder.toString()
            ]);
            /* eslint-enable max-len */
        }
        return data;
    }


    /**
     * Output result set as formatted table with details on salary difference.
     *
     * @async
     *
     * @param {string} word The word to search for.
     * @returns {string} Formatted table to print out.
     */
    async getInfoByWord(word) {
        // word = `%${word}%`;
        const db = await mysql.createConnection(config);
        let sql = `
        SELECT
            *
        FROM
            larare
        WHERE
            akronym LIKE '%${word}%'
            OR
            fornamn LIKE '%${word}%'
            OR
            efternamn LIKE '%${word}%'
            OR
            avdelning LIKE '%${word}%'
            OR
            kon LIKE '%${word}%'
            OR
            lon LIKE '%${word}%'
            OR
            kompetens LIKE '%${word}%'
        `;
        let res = await db.query(sql);

        db.end();

        let data = [["Akronym", "Avdelning", "Namn", "kon", "Lön", "Fodd", "Kompetens"]];

        // Add each teacher's information in the array
        for (const row of res) {
            /* eslint-disable max-len */
            data.push([
                row.akronym,
                row.avdelning,
                row.fornamn + " " + row.efternamn,
                row.kon,
                row.lon.toString(),
                row.fodd.toString(),
                row.kompetens.toString(),
            ]);
            /* eslint-enable max-len */
        }

        return data;
    }


    /**
     * Output result set as formatted table with details on difference on competences .
     *
     * @async
     *
     * @returns {string} Formatted table to print out.
     */
    async getCompetenceDiff() {
        const db = await mysql.createConnection(config);
        let sql = `
        SELECT
            l.akronym as akronym,
            l.kompetens as kompetens,
            lp.kompetens as kompetens_pre,
            l.kompetens - lp.kompetens as diff
        FROM
            larare as l join
            larare_pre as lp
        on
            l.akronym = lp.akronym
        `;
        let res = await db.query(sql);

        db.end();

        let data = [["akronym", "kompetens", "kompetens_pre", "diff"]];

        // Add each teacher's information in the array
        for (const row of res) {
            /* eslint-disable max-len */
            data.push([
                row.akronym,
                row.kompetens,
                row.kompetens_pre,
                row.diff,
            ]);
            /* eslint-enable max-len */
        }
        return data;
    }


    /**
     * Output result set as formatted table with details on salary difference.
     *
     * @async
     *
     * @returns {string} Formatted table to print out.
     */
    async getSalaryDiff() {
        const db = await mysql.createConnection(config);
        let sql = `
        SELECT
            l.akronym as akronym,
            l.lon as lon,
            lp.lon as lon_pre,
            l.lon - lp.lon as diff
        FROM
            larare as l join
            larare_pre as lp
        on
            l.akronym = lp.akronym
        `;
        let res = await db.query(sql);

        db.end();

        let data = [["akronym", "kompetens", "kompetens_pre", "diff"]];

        // Add each teacher's information in the array
        for (const row of res) {
            /* eslint-disable max-len */
            data.push([
                row.akronym,
                row.lon,
                row.lon_pre,
                row.diff,
            ]);
            /* eslint-enable max-len */
        }
        return data;
    }


    /**
     * Output result set as formatted table with details on salary difference.
     *
     * @async
     *
     * @param {string} word The word to search for.
     * @returns {string} Formatted table to print out.
     */
    async updateSalary(akronym, lon) {
        // word = `%${word}%`;
        const db = await mysql.createConnection(config);
        let sql = `
        UPDATE
            larare
        SET lon = ${lon}
        WHERE
            akronym = '${akronym}'
        `;
        let res = await db.query(sql);

        db.end();

        return res;
    }
}

module.exports = Teacher;
