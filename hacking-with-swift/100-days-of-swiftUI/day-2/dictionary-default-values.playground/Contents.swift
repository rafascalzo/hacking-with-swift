import UIKit

//If you try to read a value from a dictionary using a key that doesn’t exist, Swift will send you back nil – nothing at all. While this might be what you want, there’s an alternative: we can provide the dictionary with a default value to use if we request a missing key.
//
//To demonstrate this, let’s create a dictionary of favorite ice creams for two people:

let favoriteIceCream = [
    "Paul": "Chocolate",
    "Sophie": "Vanilla"
]
//We can read Paul’s favorite ice cream like this:

favoriteIceCream["Paul"]
//But if we tried reading the favorite ice cream for Charlotte, we’d get back nil, meaning that Swift doesn’t have a value for that key:

favoriteIceCream["Charlotte"]
//We can fix this by giving the dictionary a default value of “Unknown”, so that when no ice cream is found for Charlotte we get back “Unknown” rather than nil:

favoriteIceCream["Charlotte", default: "Unknown"]

extension String {
 static let DEFAULT_STRING_VALUE = "Unknown"
}

extension Int {
    static let DEFAULT_INT_VALUE = 999
}

let things = [
    "iniciar": 0,
    "finalizar":1,
    "parada":3
]

things["iniciare", default: Int.DEFAULT_INT_VALUE]



