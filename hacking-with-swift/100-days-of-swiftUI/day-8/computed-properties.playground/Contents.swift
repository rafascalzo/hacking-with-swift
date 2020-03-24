import UIKit

//We just created a Sport struct like this:

struct Sport1 {
    var name: String
}
//That has a name property that stores a String. These are called stored properties, because Swift has a different kind of property called a computed property – a property that runs code to figure out its value.
//
//We’re going to add another stored property to the Sport struct, then a computed property. Here’s how that looks:

struct Sport {
    var name: String
    var isOlympicSport: Bool
    
    var olympicStatus: String {
        if isOlympicSport {
            return "\(name) is an Olympic sport"
        } else {
            return "\(name) is not an Olympic sport"
        }
    }
}
//As you can see, olympicStatus looks like a regular String, but it returns different values depending on the other properties.
//
//We can try it out by creating a new instance of Sport:

let chessBoxing = Sport(name: "Chessboxing", isOlympicSport: false)
print(chessBoxing.olympicStatus)

struct Guitar {
    var model: String
    var isFender: Bool
    
    var fenderStstus: String {
        if isFender {
            return "\(model) is a fender guitar"
        } else {
            return "\(model) isn't a fender guitar"
        }
    }
}

let stratocaster = Guitar(model: "Stratocaster", isFender: true)
print(stratocaster.fenderStstus)
