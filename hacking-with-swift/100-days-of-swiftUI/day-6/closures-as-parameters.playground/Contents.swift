import UIKit

//Because closures can be used just like strings and integers, you can pass them into functions. The syntax for this can hurt your brain at first, so we’re going to take it slow.
//
//First, here’s our basic driving() closure again

let driving = {
    print("I'm driving in my car")
}
//If we wanted to pass that closure into a function so it can be run inside that function, we would specify the parameter type as () -> Void. That means “accepts no parameters, and returns Void” – Swift’s way of saying “nothing”.
//
//So, we can write a travel() function that accepts different kinds of traveling actions, and prints a message before and after:

func travel(action: () -> Void) {
    print("I'm getting ready to go.")
    action()
    print("I arrived!")
}
//We can now call that using our driving closure, like this:

travel(action: driving)


let newAction = { () -> String in
   return "is a new action from Garça"
}

func whatIsNewAction(action: () -> String) {
    print("James, where from this your new action?")
    let str = action()
    print("Oh sir, my action " + str)
}
whatIsNewAction(action: newAction)

let another = {
    return "is from another place"
}

whatIsNewAction(action: another)




