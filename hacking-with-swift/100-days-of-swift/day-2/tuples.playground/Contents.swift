import UIKit

//Tuples allow you to store several values together in a single value. That might sound like arrays, but tuples are different:
//
//You can’t add or remove items from a tuple; they are fixed in size.
//You can’t change the type of items in a tuple; they always have the same types they were created with.
//You can access items in a tuple using numerical positions or by naming them, but Swift won’t let you read numbers or names that don’t exist.
//Tuples are created by placing multiple items into parentheses, like this:

var name = (first: """
Taylor
main
tem noio
sd
""", last: "Swift")
//You then access items using numerical positions starting from 0:

name.0
//Or you can access items using their names:

name.first
//Remember, you can change the values inside a tuple after you create it, but not the types of values. So, if you tried to change name to be (first: "Justin", age: 25) you would get an error.
print(name.first)

