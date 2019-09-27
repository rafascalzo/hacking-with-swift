import UIKit

//Sometimes you need to be able to assign values to enums so they have meaning. This lets you create them dynamically, and also use them in different ways.
//
//For example, you might create a Planet enum that stores integer values for each of its cases:

enum Planet0: Int {
    case mercury
    case venus
    case earth
    case mars
}
//Swift will automatically assign each of those a number starting from 0, and you can use that number to create an instance of the appropriate enum case. For example, earth will be given the number 2, so you can write this:
//
//let earth = Planet(rawValue: 2)
//If you want, you can assign one or more cases a specific value, and Swift will generate the rest. It’s not very natural for us to think of Earth as the second planet, so you could write this:

enum Planet: Int {
    case mercury = 1
    case venus
    case earth
    case mars
}
//Now Swift will assign 1 to mercury and count upwards from there, meaning that earth is now the third planet.
let venus = Planet.venus
print(venus.rawValue)

let mars = Planet.mars
print(mars.rawValue)

let earth = Planet(rawValue: 3)

print(earth.debugDescription)
