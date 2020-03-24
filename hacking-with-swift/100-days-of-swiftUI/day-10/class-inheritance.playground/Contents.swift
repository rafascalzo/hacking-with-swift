import UIKit

//The second difference between classes and structs is that you can create a class based on an existing class – it inherits all the properties and methods of the original class, and can add its own on top.
//
//This is called class inheritance or subclassing, the class you inherit from is called the “parent” or “super” class, and the new class is called the “child” class.
//
//Here’s the Dog class we just created:

class Dog {
    var name: String
    var breed: String
    
    init(name: String, breed: String) {
        self.name = name
        self.breed = breed
    }
}
//We could create a new class based on that one called Poodle. It will inherit the same properties and initializer as Dog by default:

class Poodle: Dog {
    
}
//However, we can also give Poodle its own initializer. We know it will always have the breed “Poodle”, so we can make a new initializer that only needs a name property. Even better, we can make the Poodle initializer call the Dog initializer directly so that all the same setup happens:

class Poodle1: Dog {
    init(name: String) {
        super.init(name: name, breed: "Poodle")
    }
}
//For safety reasons, Swift always makes you call super.init() from child classes – just in case the parent class does some important work when it’s created.


class Science {
    var topic: String
    
    init(_ topic: String) {
        self.topic = topic
    }
    
    func myTopic() -> String {
        return "My topic is: \(topic)"
    }
}

class Math: Science {
    
    var number: Double
    
    init(_ topic: String,_ number: Double) {
        self.number = number
        super.init(topic)
    }
    
    func multiplyBy(_ multiplier: Double) -> Double {
        return multiplier * number
    }
    
    override func myTopic() -> String {
        return "Ayayayayyy " + topic
    }
}

let math = Math("Math", 3)

print(math.myTopic())
print(math.multiplyBy(3.5))
