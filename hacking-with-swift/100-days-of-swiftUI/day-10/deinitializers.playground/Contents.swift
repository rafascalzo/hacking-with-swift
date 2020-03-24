import UIKit

//The fourth difference between classes and structs is that classes can have deinitializers – code that gets run when an instance of a class is destroyed.
//
//To demonstrate this, here’s a Person class with a name property, a simple initializer, and a printGreeting() method that prints a message:

class Person {
    var name = "John Doe"
    
    init() {
        print("\(name) is alive!")
    }
    
    func printGreeting() {
        print("Hello, I'm \(name)")
    }
    deinit {
        print("\(name) is no more!")
    }
}
//We’re going to create a few instances of the Person class inside a loop, because each time the loop goes around a new person will be created then destroyed:

    for _ in 1...3 {
        let person = Person()
        person.printGreeting()
}
//And now for the deinitializer. This will be called when the Person instance is being destroyed:


class Xmas {
    var santaName: String
    
    init(_ santaName: String) {
        self.santaName = santaName
        print("\(self.santaName) merry Xmas")
    }
    
    deinit {
        print("See you later \(santaName)")
    }
}

for _ in 0..<10 {
    let _ = Xmas("GoldNoel")
}
