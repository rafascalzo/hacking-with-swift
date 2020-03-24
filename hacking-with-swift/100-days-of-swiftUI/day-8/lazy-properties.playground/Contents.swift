import UIKit

//As a performance optimization, Swift lets you create some properties only when they are needed. As an example, consider this FamilyTree struct – it doesn’t do much, but in theory creating a family tree for someone takes a long time:

struct FamilyTree1 {
    init() {
        print("Creating family tree!")
    }
}
//We might use that FamilyTree struct as a property inside a Person struct, like this:

struct Person1 {
    var name: String
    var familyTree = FamilyTree1()
    
    init(name: String) {
        self.name = name
    }
}

var ed1 = Person1(name: "Ed")
//But what if we didn’t always need the family tree for a particular person? If we add the lazy keyword to the familyTree property, then Swift will only create the FamilyTree struct when it’s first accessed:

struct FamilyTree {
    init() {
        print("Creating family tree!")
    }
}

struct Person {
    var name: String
    lazy var familyTree = FamilyTree()
    
    init(name: String) {
        self.name = name
    }
}

var ed = Person(name: "Ed")


//So, if you want to see the “Creating family tree!” message, you need to access the property at least once:

ed.familyTree

struct MerryChristmas {
    init() {
        print("Hohoho Merry Xmas!!")
    }
}

struct Natal {
    var date: Date
    lazy var xmas = MerryChristmas()
    
    init(_ date: Date) {
        self.date = date
    }
}

var natal = Natal(Date())

// late init
natal.xmas
