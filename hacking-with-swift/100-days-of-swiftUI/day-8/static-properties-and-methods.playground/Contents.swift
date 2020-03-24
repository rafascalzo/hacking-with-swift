import UIKit

//All the properties and methods we’ve created so far have belonged to individual instances of structs, which means that if we had a Student struct we could create several student instances each with their own properties and methods:

struct Student1 {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

let ed1 = Student1(name: "Ed")
let taylor1 = Student1(name: "Taylor")
//You can also ask Swift to share specific properties and methods across all instances of the struct by declaring them as static.
//
//To try this out, we’re going to add a static property to the Student struct to store how many students are in the class. Each time we create a new student, we’ll add one to it:

struct Student {
    static var classSize = 0
    var name: String
    
    init(name: String) {
        self.name = name
        Student.classSize += 1
    }
}
//Because the classSize struct belongs to the struct itself rather than instances of the struct, we need to read it using Student.classSize:

let stud = Student(name: "Rofoood")
let studi = Student(name: "fooras")
let st = Student(name: "Porwea")
print(Student.classSize)
