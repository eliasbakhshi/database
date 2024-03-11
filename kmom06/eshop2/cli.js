const mysql = require('mysql');
const readline = require('readline');
const util = require('util');
const con = require("./config/db/eshop.json");

const connection = mysql.createConnection(con);
const queryAsync = util.promisify(connection.query).bind(connection);

connection.connect((err) => {
    if (err) {
        console.error('Error connecting to the database:', err);
        return;
    }
    console.log('Connected to the database');

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
    console.log('10. Menu: to see all the options.');
    console.log('11. Exit');
    console.log('12. To see orders');
    console.log('13. See order <orderid>');
    console.log('14. Ship <orderid>');
    console.log('15. Picklist <orderid>');
    console.log('16. Orderstatus <orderid>');
    rl.question('Enter your choice: ', handleChoice);
}

function handleChoice(choice) {
    const args = choice.split(' ');
    let id = 0;
    let delargs=0;
    let filterString=0;
    let logNumber=0;
    let log="";

    let addArgs=0;

    choice = args[0];

    switch (choice) {
        case '1':
            displayShelves();
            break;
        case '2':
            log="About: This program is for managing an eshop built by Senao, Elias and Daniel.";

            console.log(log);
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
            filterString = args.slice(1).join(' ');

            filterInventory(filterString);
            break;
        case '8':
            addArgs = args.slice(1);

            addProductToInventory(addArgs);
            break;
        case '9':
            delargs = args.slice(1);

            removeProductFromInventory(delargs);
            break;
        case '10':
            displayMenu();
            break;
        case '11':
            console.log('Exiting...');
            connection.end();
            rl.close();
            break;
        case '12':
            getOrders();
            break;
        case '13':
            id = args.slice(1);
            displayOrderId(id);
            break;
        case '14':
            id = args.slice(1);
            updateOrderStatusToShipped(id);
            break;
        case '15':
            id = args.slice(1);
            pickList(id);
            break;
        case '16':
            id = args.slice(1);
            getOrderStatus(id);
            break;
        default:
            console.log('Invalid choice. Please enter a valid command.');
            displayMenu();
            break;
    }
}

async function displayShelves() {
    try {
        const results = await queryAsync('CALL p_display_shelves_procedure();');

        console.log('Displaying shelves in the warehouse:');
        console.table(results[0]);
        displayMenu();
    } catch (error) {
        console.error('Error fetching shelves:', error);
        return;
    }
}

async function displayLog(logNumber) {
    try {
        const results = await queryAsync('CALL p_display_log_procedure(?)', [logNumber]);

        console.log(`Displaying last ${logNumber} log entries:`);
        console.table(results[0]);
        displayMenu();
    } catch (error) {
        console.error('Error fetching log:', error);
        return;
    }
}

async function displayProducts() {
    try {
        const results = await queryAsync('CALL p_display_products_procedure()');

        console.log('Displaying products:');
        console.table(results[0]);
        displayMenu();
    } catch (error) {
        console.error('Error fetching products:', error);
        return;
    }
}

async function getOrders() {
    try {
        const results = await queryAsync('CALL p_show_orders_with_totals()');

        console.log('Displaying orders:');
        console.table(results[0]);
        displayMenu();
    } catch (error) {
        console.error('Error fetching orders:', error);
        return;
    }
}

async function displayShelfLocations() {
    try {
        const results = await queryAsync('CALL p_display_shelf_locations_procedure()');

        console.log('Displaying shelf locations:');
        console.table(results[0]);
        displayMenu();
    } catch (error) {
        console.error('Error fetching shelf locations:', error);
        return;
    }
}

async function displayInventory() {
    try {
        const results = await queryAsync('CALL p_display_inventory_procedure()');

        console.log('Displaying inventory:');
        console.table(results[0]);
        displayMenu();
    } catch (error) {
        console.error('Error fetching inventory:', error);
        return;
    }
}

async function filterInventory(filterString) {
    try {
        const results = await queryAsync('CALL p_filter_inventory_procedure(?)', [filterString]);

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
        console.error('Error fetching filtered inventory:', error);
        return;
    }
}


function addProductToInventory(args) {
    const [productId, shelf, quantity] = args;

    connection.query('CALL p_add_product_to_inventory_procedure(?, ?, ?)',
        [productId, shelf, quantity], (error) => {
            if (error) {
                console.error('Error adding product to inventory:', error);
                return;
            }
            console.log(`Added ${quantity} of product ${productId} to shelf ${shelf}`);
            displayMenu();
        });
}

function removeProductFromInventory(args) {
    const [productId, shelf, quantity] = args;

    connection.query(
        'CALL p_remove_product_from_inventory_procedure(?, ?, ?)',
        [productId, shelf, quantity],
        (error) => {
            if (error) {
                console.error('Error removing product from inventory:', error);
                return;
            }
            console.log(`Removed ${quantity} of product ${productId} from shelf ${shelf}`);
            displayMenu();
        });
}

async function displayOrderId(logNumber) {
    try {
        const results = await queryAsync('CALL p_show_order_with_totals_custom(?)', [logNumber]);

        console.log(`Displaying order with ID ${logNumber}:`);
        console.table(results[0]);
        displayMenu();
    } catch (error) {
        console.error('Error fetching order information:', error);
        return;
    }
}

async function updateOrderStatusToShipped(logNumber) {
    try {
        const results = await queryAsync('CALL p_update_order_status_to_shipped(?)', [logNumber]);

        console.log(`Updated order status to shipped for order with ID ${logNumber}:`);
        console.table(results[0]);
        displayMenu();
    } catch (error) {
        console.error('Error updating order status:', error);
        return;
    }
}

async function pickList(logNumber) {
    try {
        const results = await queryAsync('CALL p_plocklist(?)', [logNumber]);

        console.log(`Generating picklist for order with ID ${logNumber}:`);
        console.table(results[0]);
        displayMenu();
    } catch (error) {
        console.error('Error generating picklist:', error);
        return;
    }
}

async function getOrderStatus(logNumber) {
    try {
        const results = await queryAsync('CALL p_get_order_status(?)', [logNumber]);

        console.log(`Displaying order status for order with ID ${logNumber}:`);
        console.table(results[0]);
        displayMenu();
    } catch (error) {
        console.error('Error fetching order status:', error);
        return;
    }
}
