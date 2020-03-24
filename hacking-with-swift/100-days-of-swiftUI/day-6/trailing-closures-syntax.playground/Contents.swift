import UIKit

//If the last parameter to a function is a closure, Swift lets you use special syntax called trailing closure syntax. Rather than pass in your closure as a parameter, you pass it directly after the function inside braces.
//
//To demonstrate this, here’s our travel() function again. It accepts an action closure so that it can be run between two print() calls:

func travel(action: () -> Void) {
    print("I'm getting ready to go.")
    action()
    print("I arrived!")
}
//Because its last parameter is a closure, we can call travel() using trailing closure syntax like this:

travel() {
    print("I'm driving in my car")
}
//In fact, because there aren’t any other parameters, we can eliminate the parentheses entirely:

travel {
    print("I'm driving in my car")
}
//Trailing closure syntax is extremely common in Swift, so it’s worth getting used to.



let action = {
    return "Noveaul"
}

func printMyAction(action: () -> String) {
    print("James again, what you want?")
    let answer = action()
    print("I want to " + answer)
}

printMyAction(action: action)

printMyAction {
    action()
}


func play(_ game1: String, _ game2: String , action: (String, String) -> Void) {
    print("What game you want to play?? ")
    action(game1, game2)
    print("Ok lets play!!")
}

play("Call of duty", "Batman") {
    print("I want to play \($0) and \($1)")
}

func review(day: Int, of course: String, topics: String, review: (Int, String, String) ->Void ) {
    print("Just reviewed")
    review(day, course, topics)
    print("Now going to day 7")
}

review(day: 6, of: "100DaysOfSwifUI", topics: """
basic closures
accepting parameters
returning values from a closure
closures as parameters
trailing closure syntax
""") { (day: Int, course: String, topics: String) in
    print("day \(day) of #\(course)\ntopics:\n\(topics)")
}


func play1(_ game1: String, _ game2: String , action: (String, String) -> (String, String)) {
    let result = action(game1, game2)
    print("Ok lets play \(result.0) and \(result.1)!!")
}

play1("Call of duty", "Batman") {
   return ($0, $1)
}
