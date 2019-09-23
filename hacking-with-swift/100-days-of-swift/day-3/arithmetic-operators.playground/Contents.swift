import UIKit

//Now you know all the basic types in Swift, we can start to put them together using operators. Operators are those little mathematical symbols like + and -, and Swift has a huge range of them.
//
//Here are a couple of test variables for us to work with:

let firstScore = 12
let secondScore = 4
//We can add and subtract using + and -:

let total = firstScore + secondScore
let difference = firstScore - secondScore
//And we can multiply and divide using * and /:

let product = firstScore * secondScore
let divided = firstScore / secondScore
//Swift has a special operator for calculating remainders after division: %. It calculates how many times one number can fit inside another, then sends back the value that’s left over.
//
//For example, we set secondScore to 4, so if we say 13 % secondScore we’ll get back one, because 4 fits into 13 three times with remainder one:

let remainder = 13 % secondScore
