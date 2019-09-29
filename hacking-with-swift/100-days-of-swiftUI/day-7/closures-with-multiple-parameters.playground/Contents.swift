import UIKit

//Just to make sure everything is clear, we’re going to write another closure example using two parameters.
//
//This time our travel() function will require a closure that specifies where someone is traveling to, and the speed they are going. This means we need to use (String, Int) -> String for the parameter’s type:

func travel(action: (String, Int) -> String) {
    print("I'm getting ready to go.")
    let description = action("London", 60)
    print(description)
    print("I arrived!")
}
//We’re going to call that using a trailing closure and shorthand closure parameter names. Because this accepts two parameters, we’ll be getting both $0 and $1:

travel {
    "I'm going to \($0) at \($1) miles per hour."
}
//Some people prefer not to use shorthand parameter names like $0 because it can be confusing, and that’s OK – do whatever works best for you.
