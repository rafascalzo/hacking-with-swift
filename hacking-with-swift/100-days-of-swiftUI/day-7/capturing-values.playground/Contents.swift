import UIKit

//If you use any external values inside your closure, Swift captures them – stores them alongside the closure, so they can be modified even if they don’t exist any more.
//
//Right now we have a travel() function that returns a closure, and the returned closure accepts a string as its only parameter and returns nothing:

func travel1	() -> (String) -> Void {
    return {
        print("I'm going to \($0)")
    }
}
//We can call travel() to get back the closure, then call that closure freely:

let result1 = travel1()
result1("London")
//Closure capturing happens if we create values in travel() that get used inside the closure. For example, we might want to track how often the returned closure is called:

func travel() -> (String) -> Void {
    var counter = 1
    
    return {
        print("\(counter). I'm going to \($0)")
        counter += 1
    }
}
let result = travel()
//Even though that counter variable was created inside travel(), it gets captured by the closure so it will still remain alive for that closure.
//
//    So, if we call result("London") multiple times, the counter will go up and up:

result("London")
result("London")
result("London")


func review() -> (String) -> String {
    var count = 0
    return {
        count += 1
        return "notaaa \($0) irraaa \(count)"
    }
}

let reviews = review()

print(reviews("5"))
print(reviews("6"))
print(reviews("7"))
