import UIKit

//In the same way that you can pass a closure to a function, you can get closures returned from a function too.
//
//The syntax for this is a bit confusing a first, because it uses -> twice: once to specify your function’s return value, and a second time to specify your closure’s return value.
//
//To try this out, we’re going to write a travel() function that accepts no parameters, but returns a closure. The closure that gets returned must be called with a string, and will return nothing.
//
//Here’s how that looks in Swift:

func travel() -> (String) -> Void {
    return {
        print("I'm going to \($0)")
    }
}
//We can now call travel() to get back that closure, then call it as a function:

let result = travel()
result("London")
//It’s technically allowable – although really not recommended! – to call the return value from travel() directly:

let result2 = travel()("London")

func review() -> (String, Int) -> Void {
    return { (first: String, second: Int) in
        print("String is \(first) and number is \(second)")
    }
}

let reviews = review()

reviews("rwar", 4)
reviews("test", 3)
reviews("hahaha", 43)

let reviews1 = review()("String", 40)

