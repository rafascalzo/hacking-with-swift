import UIKit

// Sets are collections of values just like arrays, except they have two differences:

// Items aren’t stored in any order; they are stored in what is effectively a random order.

// No item can appear twice in a set; all items must be unique.
// You can create sets directly from arrays, like this:

let colors = Set(["red", "green", "blue"])
//When you look at the value of colors inside the playground output you’ll see it doesn’t match the order we used to create it. It’s not really a random order, it’s just unordered – Swift makes no guarantees about its order. Because they are unordered, you can’t read values from a set using numerical positions like you can with arrays.
//
//If you try to insert a duplicate item into a set, the duplicates get ignored. For example:

let colors2 = Set(["red", "green", "blue", "red", "blue"])
//The final colors2 set will still only include red, green, and blue once.

print(colors)
print(colors2)
