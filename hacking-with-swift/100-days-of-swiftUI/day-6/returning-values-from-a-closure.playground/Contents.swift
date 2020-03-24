import UIKit

//Closures can also return values, and they are written similarly to parameters: you write them inside your closure, directly before the in keyword.
//
//To demonstrate this, we’re going to take our driving() closure and make it return its value rather than print it directly. Here’s the original:

let driving = { (place: String) in
    print("I'm going to \(place) in my car")
}
//We want a closure that returns a string rather than printing the message directly, so we need to use -> String before in, then use return just like a normal function:

let drivingWithReturn = { (place: String) -> String in
    return "I'm going to \(place) in my car"
}
//We can now run that closure and print its return value:

let message = drivingWithReturn("London")
print(message)


let canIPlayWith = { (word: String, power: Int) -> String in
    switch power {
    case 0..<2:
        return "Can i play with \(word) ??"
    case 2..<4:
        return "Can i play with \(word) ????"
    case 4..<6:
    return "Can i play with \(word) ??????"
    case 6..<8:
        return "Can i play with \(word) ????????"
    default:
    return "Can i play with \(word) ??????????!!!"
    }
}

let can = canIPlayWith("Madness", 2)
print(can)
