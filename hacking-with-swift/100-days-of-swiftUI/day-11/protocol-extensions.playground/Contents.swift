let pythons = ["Eric", "Graham", "John", "Michael", "Terry", "Terry"]
let beatles = Set(["John", "Paul", "George", "Ringo"])
//Swift’s arrays and sets both conform to a protocol called Collection, so we can write an extension to that protocol to add a summarize() method to print the collection neatly

extension Collection {
    func summarize() {
        print("There are \(count) of us:")
        
        for name in self {
            print(name)
        }
    }
}
//Both Array and Set will now have that method, so we can try it out:

pythons.summarize()
beatles.summarize()

protocol NovoProtocolo {
    typealias Name = () -> Void
}

extension NovoProtocolo {
    func possoImplementar(_ retorno: Int) -> Int {
        return retorno / 2
    }
}

struct Haha: NovoProtocolo {
    
}

var haha = Haha()

print(haha.possoImplementar(5))
