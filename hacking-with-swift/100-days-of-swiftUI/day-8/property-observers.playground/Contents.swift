import UIKit

//Property observers let you run code before or after any property changes. To demonstrate this, we’ll write a Progress struct that tracks a task and a completion percentage:

struct Progress1	 {
    var task: String
    var amount: Int
}
//We can now create an instance of that struct and adjust its progress over time:

var progress1 = Progress1(task: "Loading data", amount: 0)
progress1.amount = 30
progress1.amount = 80
progress1.amount = 100
//What we want to happen is for Swift to print a message every time amount changes, and we can use a didSet property observer for that. This will run some code every time amount changes:

struct Progress {
    var task: String
    var amount: Int {
        didSet {
            print("\(task) is now \(amount)% complete")
        }
    }
}
//You can also use willSet to take action before a property changes, but that is rarely used.
var progress = Progress(task: "Loading data", amount: 0)
progress.amount = 30
progress.amount = 80
progress.amount = 100

struct Guitar {
    var model: String
    var frets: Int {
        willSet {
            print("I'll set \(newValue) for \(model)")
        }
        didSet {
            print("\(model) has \(frets) frets")
        }
    }
}

var guitar = Guitar(model: "Stratocaster", frets: 32)

guitar.frets = 22
