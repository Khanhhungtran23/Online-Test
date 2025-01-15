const readline = require('readline');

// Product class
class Product {
    constructor(name, price, quantity) {
        this.name = name;
        this.price = price;
        this.quantity = quantity;
    }
}

// Create inventory
const inventory = [
    new Product("Laptop", 999.99, 5),
    new Product("Smartphone", 499.99, 10),
    new Product("Tablet", 299.99, 0),
    new Product("Smartwatch", 199.99, 3)
];

// Calculate total inventory value
function calculateTotalInventoryValue(products) {
    return products.reduce((total, product) => {
        return total + (product.price * product.quantity);
    }, 0).toFixed(2);
}

// Find the most expensive product
function findMostExpensiveProduct(products) {
    return products.reduce((mostExpensive, current) => {
        return current.price > mostExpensive.price ? current : mostExpensive;
    }).name;
}

// Check if a product is in stock or not
function isProductInStock(products, productName) {
    const product = products.find(p => p.name === productName);
    return product !== undefined && product.quantity > 0;
}

// Sort products by a given property in ascending or descending order
function sortProducts(products, property, ascending = true) {
    return [...products].sort((a, b) => {
        return ascending ? 
            a[property] - b[property] : 
            b[property] - a[property];
    });
}

// Create readline interface
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

// Function to display sorting results with hyphens
function displaySortedProducts(sortedProducts) {
    const productNames = sortedProducts.map(product => product.name);
    console.log(productNames.join(' - '));
}

// Function to handle user input for sorting
async function handleInventorySystem() {
    // Create promise-based question function
    const question = (query) => new Promise((resolve) => rl.question(query, resolve));

    try {
        console.log("\n=== Inventory Management System ===");
        console.log("Total inventory value:", calculateTotalInventoryValue(inventory));
        console.log("Most expensive product:", findMostExpensiveProduct(inventory));

        // Ask user for product name to check stock
        const productToCheck = await question("\nEnter product name to check stock: ");
        console.log(`${productToCheck} in stock:`, isProductInStock(inventory, productToCheck));

        // Ask for sort order
        console.log("\nSort order options:");
        console.log("1. Ascending");
        console.log("2. Descending");
        const orderChoice = await question("Choose sort order (1 or 2): ");
        const isAscending = orderChoice === "1";

        // Ask for sort factor
        console.log("\nSort by:");
        console.log("1. Price");
        console.log("2. Quantity");
        const factorChoice = await question("Choose sort factor (1 or 2): ");
        
        // Determine sort property
        const sortProperty = factorChoice === "1" ? "price" : "quantity";

        // Perform sorting
        const sortedProducts = sortProducts(inventory, sortProperty, isAscending);
        
        // Display results
        console.log(`\nProducts sorted by ${sortProperty} in ${isAscending ? 'ascending' : 'descending'} order:`);
        displaySortedProducts(sortedProducts);

    } catch (error) {
        console.error("An error occurred:", error);
    } finally {
        rl.close();
    }
}

// Run the program
handleInventorySystem();