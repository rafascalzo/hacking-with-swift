import UIKit

//Capture lists in Swift: what’s the difference between weak, strong, and unowned references?
//Weak vs strong vs unowned – know the difference in closures
//
//Capture lists come before a closure’s parameter list in your code, and capture values from the environment as either strong, weak, or unowned. We use them a lot, mainly to avoid strong reference cycles – aka retain cycles.
//
//Deciding which to use isn’t easy when you’re learning, so you can spend time trying to figure out strong vs weak, or weak vs unowned, but as you progress with your learning you’ll start to realize there’s often only one right choice.
//
//First, let’s take a look at the problem. First, here’s a simple class:

class Singer {
    func playSong() {
        print("Shake it off!")
    }
}
//Second, here’s a function that creates an instance of Singer, creates a closure that uses the singer’s playSong() method, and returns that closure for us to use elsewhere:

func sing() -> () -> Void {
    let taylor = Singer()

    let singing = {
        taylor.playSong()
        return
    }

    return singing
}
//Finally, we can call sing() to get back a function we can call wherever we want to have playSong() printed:

let singFunction = sing()
singFunction()
//That will print “Shake it off!” thanks to the call to singFunction().
//
//Strong capturing
//Unless you ask for something special, Swift uses strong capturing. This means the closure will capture any external values that are used inside the closure, and make sure they never get destroyed.
//
//Look again at our sing() function:

func sing() -> () -> Void {
    let taylor = Singer()

    let singing = {
        taylor.playSong()
        return
    }

    return singing
}
//That taylor constant is made inside the sing() function, so normally it would be destroyed when the function ends. However, it gets used inside the closure, which means Swift will automatically make sure it stays alive for as long as the closure exists somewhere, even after the function has returned.
//
//This is strong capturing in action. If Swift allowed taylor to be destroyed, then the closure would no longer be safe to call – its taylor.playSong() method wouldn’t be valid any more.
//
//Weak capturing
//Swift lets us specify a capture list to determine how values used inside the closure should be captured. The most common alternative to strong capturing is called weak capturing, and it changes two things:
//
//Weakly captured values aren’t kept alive by the closure, so they might be destroyed and be set to nil.
//As a result of 1, weakly captured values are always optional in Swift. This stops you assuming they are present when in fact they might not be.
//We can modify our example to use weak capturing and you’ll see an immediate difference:

func sing() -> () -> Void {
    let taylor = Singer()

    let singing = { [weak taylor] in
        taylor?.playSong()
        return
    }

    return singing
}
//That [weak taylor] part is our capture list, which is a specific part of closures where we give specific instructions as to how values should be captured. Here we’re saying that taylor should be captured weakly, which is why we need to use taylor?.playSong() – it’s an optional now, because it could be set to nil at any time.
//
//If you run the code now you’ll see that calling singFunction() doesn’t print anything any more. The reason is that taylor exists only inside sing(), because the closure it returns doesn’t keep a strong hold of it.
//
//To see this behavior in action, try changing sing() to this:

func sing() -> () -> Void {
    let taylor = Singer()

    let singing = { [weak taylor] in
        taylor!.playSong()
        return
    }

    return singing
}
//That force unwraps taylor inside the closure, which will cause your code to crash because taylor becomes nil.
//
//Unowned capturing
//An alternative to weak is unowned, which behaves more like implicitly unwrapped optionals. Like weak capturing, unowned capturing allows values to become nil at any point in the future. However, you can work with them as if they are always going to be there – you don’t need to unwrap optionals.
//
//For example:

func sing() -> () -> Void {
    let taylor = Singer()

    let singing = { [unowned taylor] in
        taylor.playSong()
        return
    }

    return singing
}
//That will crash in a similar way to our force-unwrapped example from earlier: unowned taylor says I know for sure that taylor will always exist for the lifetime of the closure I’m sending back so I don’t need to hold on to the memory, but in practice taylor will be destroyed almost immediately so the code will crash.
//
//You should use unowned very carefully indeed.
//
//Common problems
//There are four problems folks commonly hit when using closure capturing:
//
//They aren’t sure where to use capture lists when closures accept parameters.
//They make strong reference cycles, causing memory to get eaten up.
//They accidentally use strong references, particularly when using multiple captures.
//They make copies of closures and share captured data.
//Let’s walk through each of those with some code examples, so you can see what happens.
//
//
//
//Capture lists alongside parameters
//This is a common problem to hit when you’re first starting out with capture lists, but fortunately it’s one that Swift catches for us.
//
//When using capture lists and closure parameters together the capture list must always come first, then the word in to mark the start of your closure body – trying to put it after the closure parameters will stop your code from compiling.
//
//For example:

writeToLog { [weak self] user, message in
    self?.addToLog("\(user) triggered event: \(message)")
}
 

//Strong reference cycles
//When thing A owns thing B, and thing B owns thing A, you have what’s called a strong reference cycle, or often just a retain cycle.
//
//As an example, consider this code:

class House {
    var ownerDetails: (() -> Void)?

    func printDetails() {
        print("This is a great house.")
    }

    deinit {
        print("I'm being demolished!")
    }
}
//That creates a House class with one property (a closure), one method, and a deinitializer so it prints a message when it’s being destroyed.
//
//Now here’s an Owner class that is the same, except its closure stores house details:

class Owner {
    var houseDetails: (() -> Void)?

    func printDetails() {
        print("I own a house.")
    }

    deinit {
        print("I'm dying!")
    }
}
//We can try creating two instances of those classes inside a do block. We don’t need a catch block here, but using do ensures they will be destroyed as soon as the } is reached:

print("Creating a house and an owner")

do {
    let house = House()
    let owner = Owner()
}

print("Done")
//That should print “Creating a house and an owner”, “I’m dying!”, “I'm being demolished!”, then “Done” – everything works as expected.
//
//Now let’s create a strong reference cycle:

print("Creating a house and an owner")

do {
    let house = House()
    let owner = Owner()
    house.ownerDetails = owner.printDetails
    owner.houseDetails = house.printDetails
}

print("Done")
//Now it will print “Creating a house and an owner” then “Done”, with neither deinitializer being called.
//
//What’s happening here is that house has a property that points to a method of owner, and owner has a property that points to a method of house, so neither can be safely destroyed. In real code this causes memory that can’t be freed, known as a memory leak, which degrades system performance and can even cause your app to be terminated.
//
//To fix this we need to create a new closure and use weak capturing for one or both values, like this:

print("Creating a house and an owner")

do {
    let house = House()
    let owner = Owner()
    house.ownerDetails = { [weak owner] in owner?.printDetails() }
    owner.houseDetails = { [weak house] in house?.printDetails() }
}

print("Done")
//It isn’t necessary to have both values weakly captured – all that matters is that at least one is, because it allows Swift to destroy them both when necessary.
//
//Now, in real project code it’s rare to find strong reference cycles that are so obvious, but that just means it’s all the more important to use weak capturing to avoid the problem entirely.
//
//
//
//Accidental strong references
//Swift defaults to strong capturing, which can cause unintentional problems.
//
//Going back to our singing example from earlier, consider this code:

func sing() -> () -> Void {
    let taylor = Singer()
    let adele = Singer()

    let singing = { [unowned taylor, adele] in
        taylor.playSong()
        adele.playSong()
        return
    }

    return singing
}
//Now we have two values being captured by the closure, and both values are being used the same way inside the closure. However, only taylor is being captured as unowned – adele is being captured strongly, because the unowned keyword must be used for each captured value in the list.
//
//Now, if you want taylor to be unowned but adele to be strongly captured, that’s fine. But if you want both to be unowned you need to say so:
//
//[unowned taylor, unowned adele]
//Swift does offer some protection against accidental capturing, but it’s limited: if you use self implicitly inside a closure, Swift forces you to add self. or self?. to make your intentions clear.
//
//Implicit use of self happens a lot in Swift. For example, this initializer calls playSong(), but what it really means is self.playSong() – the self part is implied by the context:

class Singer {
    init() {
        playSong()
    }

    func playSong() {
        print("Shake it off!")
    }
}
//Swift won’t let you use implicit self inside closures, which helps reduce a common type of retain cycle.
//
//
//
//Copies of closures
//The last thing that trips people up is the way closures themselves are copied, because their captured data becomes shared amongst copies.
//
//For example, here’s a simple closure that captures the numberOfLinesLogged integer created outside so that it can increment and print its value whenever its called:

var numberOfLinesLogged = 0

let logger1 = {
    numberOfLinesLogged += 1
    print("Lines logged: \(numberOfLinesLogged)")
}

logger1()
//That will print “Lines logged: 1” because we call the closure at the end.
//
//Now, if we take a copy of that closure, that copy shares the same capturing values as its original, so whether we call the original or the copy you’ll see the log line count increasing:

let logger2 = logger1
logger2()
logger1()
logger2()
//That will now print that 1, 2, 3, and 4 lines have been logged, because both logger1 and logger2 are pointing at the same captured numberOfLinesLogged value.
//
//When to use strong, when to use weak, when to use unowned
//Now that you understand how everything works, let’s try to summarize whether to use strong, weak, or unowned references:
//
//If you know for sure your captured value will never go away while the closure has any chance of being called, you can use unowned. This is really only for the handful of times when weak would cause annoyances to use, but even when you could use guard let inside the closure with a weakly captured variable.
//If you have a strong reference cycle situation – where thing A owns thing B and thing B owns thing A – then one of the two should use weak capturing. This should usually be whichever of the two will be destroyed first, so if view controller A presents view controller B, view controller B might hold a weak reference back to A.
//If there’s no chance of a strong reference cycle you can use strong capturing. For example, performing animation won’t cause self to be retained inside the animation closure, so you can use strong capturing.
//If you’re not sure which to use, start out with weak and change only if you need to.
//
//Where now?
//As you’ve seen, closure capture lists help us avoid memory problems by controlling each how values are captured inside our closures. They are captured strongly by default, but we can use weak and even unowned to allow values to be destroyed even if they are used inside our closure.
//
//I go into a lot more detail on closures in my book Pro Swift, so for more information you might want to check that out.

