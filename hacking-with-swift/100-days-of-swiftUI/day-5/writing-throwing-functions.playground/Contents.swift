import UIKit

//Sometimes functions fail because they have bad input, or because something went wrong internally. Swift lets us throw errors from functions by marking them as throws before their return type, then using the throw keyword when something goes wrong.
//
//First we need to define an enum that describes the errors we can throw. These must always be based on Swift’s existing Error type. We’re going to write a function that checks whether a password is good, so we’ll throw an error if the user tries an obvious password:

enum PasswordError: Error {
    
    case obvious
    
    var localizedDescription: String {
        switch self {
        case .obvious:
            return "Password Is Obvious"
        }
    }
    
    func localized() -> String {
        switch self {
        case .obvious:
            return "Password is obvious"
        }
    }
}
//Now we’ll write a checkPassword() function that will throw that error if something goes wrong. This means using the throws keyword before the function’s return value, then using throw PasswordError.obvious if their password is “password”.
//
//Here’s that in Swift:

func checkPassword(_ password: String) throws -> Bool {
    if password == "password" {
        throw PasswordError.obvious
    }
    
    return true
}

do {
    try checkPassword("password")
} catch let error as PasswordError {
    print(error.localizedDescription)
    print(error.localized())
}
