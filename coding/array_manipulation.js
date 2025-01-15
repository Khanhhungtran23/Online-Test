function findMissingNumber(arr) {
    // Find min and max to determine the range
    const min = Math.min(...arr);
    const max = Math.max(...arr);
    
    // Expected sum from min to max
    const expectedSum = ((max - min + 1) * (max + min)) / 2;
    
    // Calculate actual sum of array
    const actualSum = arr.reduce((sum, num) => sum + num, 0);
    
    // The difference is our missing number
    return expectedSum - actualSum;
}

// Test the function
const testArray1 = [3, 7, 1, 2, 6, 4];
const testArray2 = [14, 18, 15, 13, 16, 17, 20];
const testArray3 = [101, 102, 104, 105, 106, 107];
console.log("Missing number in array 1: " + findMissingNumber(testArray1));
console.log("Missing number in array 2: " + findMissingNumber(testArray2));
console.log("Missing number in array 3: " + findMissingNumber(testArray3));