const mysql = require('mysql');
const readline = require('readline');
const util = require('util');
const con = require("./config/db/eshop.json");

const connection = mysql.createConnection(con);

const queryAsync = util.promisify(connection.query).bind(connection);

connection.connect((err) => {
    if (err) {
        console.error('Error connecting to database: ', err);
        return;
    }
    console.log('Connected to database');

    displayMenu();
});

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

function displayMenu() {
    console.log("Welcome to the eshop");
    console.log('\nMenu:');
    console.log('1. Display shelves in the warehouse');
    console.log('2. About');
    console.log('3. Log <number>');
    console.log('4. Product');
    console.log('5. Shelf');
    console.log('6. Inv');
    console.log('7. Inv <str>');
    console.log('8. Invadd <productid> <shelf> <number>');
    console.log('9. Invdel <productid> <shelf> <number>');
    console.log("10. Menu: to see all the options.");
    console.log('11. Exit');

    rl.question('Enter your choice: ', handleChoice);
}

function handleChoice(choice) {
    let args = choice.split(' ');
    let logNumber=0;
    let addArgs="";
    let delArgs="";

    choice = args[0];

    switch (choice) {
        case '1':
            displayShelves();
            break;
        case '2':
            console.log('Gruppen består av, Senai amanuel, Elias bakshi, Daniel');
            displayMenu();
            break;
        case '3':
            logNumber = parseInt(args[1]);
            displayLog(logNumber);
            break;
        case '4':
            displayProducts();
            break;
        case '5':
            displayShelfLocations();
            break;
        case '6':
            displayInventory();
            break;
        case '7':
            if (args.length > 1) {
                filterInventory(args.slice(1).join(' '));
            } else {
                displayInventory();
            }
            break;
        case '8':
            addArgs = args.slice(1);

            addProductToInventory(addArgs);
            break;
        case '9':
            delArgs = args.slice(1);
            removeProductFromInventory(delArgs);
            break;
        case "10":
            displayMenu();
            break;
        case '11':
            console.log('Exiting...');
            connection.end(); // Close connection
            rl.close(); // Close readline interface
            break;
        default:
            console.log('Invalid choice. Please enter a valid command.');
            displayMenu(); // Display menu again
            break;
    }
}

async function displayShelves() {
    try {
        const results = await queryAsync('Call displayShelvesProcedure();');

        console.log('Shelves in the warehouse:');
        console.table(results[0]);
        displayMenu();
    } catch (error) {
        console.error('Error fetching shelves: ', error);
        return;
    }
}





async function displayLog(logNumber) {
    try {
        const results = await queryAsync('Call displayLogProcedure(?)', [logNumber]);

        console.log(`Last ${logNumber} log entries:`);
        console.table(results[0]); // Assuming results is an array of objects
        displayMenu();// Display menu again
    } catch (error) {
        console.error('Error fetching log: ', error);
        return;
    }
}

async function displayProducts() {
    try {
        const results = await queryAsync('Call displayProductsProcedure()');

        console.log('Products:');
        console.table(results[0]);
        displayMenu();
    } catch (error) {
        console.error('Error fetching products: ', error);
        return;
    }
}

async function displayShelfLocations() {
    try {
        const results = await queryAsync('Call displayShelfLocationsProcedure()');

        console.log('Shelf Locations:');
        console.table(results[0]);
        displayMenu();
    } catch (error) {
        console.error('Error fetching shelf locations: ', error);
        return;
    }
}

async function displayInventory() {
    try {
        const results = await queryAsync('Call displayInventoryProcedure()');

        console.log('Inventory:');
        console.table(results[0]);
        displayMenu();
    } catch (error) {
        console.error('Error fetching inventory: ', error);
        return;
    }
}

async function filterInventory(filterString) {
    try {
        const results = await queryAsync('CALL filterInventoryProcedure(?)', [filterString]);

        const resultSet = results[0];

        if (resultSet.length === 0) {
            console.log('No matching items found.');
            displayMenu();
            return;
        }

        console.log(`Filtered Inventory (Filter: ${filterString}):`);
        console.table(resultSet);
        displayMenu();
    } catch (error) {
        console.error('Error fetching filtered inventory: ', error);
        return;
    }
}

function addProductToInventory(args) {
    const [productId, shelf, quantity] = args;

    connection.query('CALL invadd(?, ?, ?)', [productId, shelf, quantity], (error) => {
        if (error) {
            console.error('Error adding product to inventory: ', error);
            return;
        }
        console.log(`Added ${quantity} of product ${productId} to shelf ${shelf}`);
        displayMenu();
    });
}

function removeProductFromInventory(args) {
    const [productId, shelf, quantity] = args;

    connection.query(
        'CALL removeProductFromInventoryProcedure(?, ?, ?)',
        [productId, shelf, quantity],
        (error) => {
            if (error) {
                console.error('Error removing product from inventory: ', error);
                return;
            }
            console.log(`Removed ${quantity} of product ${productId} from shelf ${shelf}`);
            displayMenu();
        });
}
