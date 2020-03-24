import UIKit

//Arrays, sets, and tuples can seem similar at first, but they have distinct uses. To help you know which to use, here are some rules.
//
//If you need a specific, fixed collection of related values where each item has a precise position or name, you should use a tuple:

let address = (house: 555, street: "Taylor Swift Avenue", city: "Nashville")
//If you need a collection of values that must be unique or you need to be able to check whether a specific item is in there extremely quickly, you should use a set:

let set = Set(["aardvark", "astronaut", "azalea"])
//If you need a collection of values that can contain duplicates, or the order of your items matters, you should use an array:

let pythons = ["Eric", "Graham", "John", "Michael", "Terry", "Terry"]
//Arrays are by far the most common of the three types.


struct Start: Hashable, Equatable {
    let code: String
    let translate: String
}

enum Street: Int {
    case _0
    case _1 = 2
}



let itens = Set([Start(code: "0", translate: "vish"),Start(code: "0", translate: "vish")])
