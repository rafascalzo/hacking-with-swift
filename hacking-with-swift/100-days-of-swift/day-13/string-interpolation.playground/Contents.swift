import UIKit

//This is a fancy name for what is actually a very simple thing: combining variables and constants inside a string.
//
//    Clear out all the code you just wrote and leave only this:

var name = "Tim McGraw"
//If we wanted to print out a message to the user that included their name, string interpolation is what makes that easy: you just write a backslash, then an open parenthesis, then your code, then a close parenthesis, like this:

var name1 = "Tim McGraw"
"Your name is \(name1)"
//The results pane will now show "Your name is Tim McGraw" all as one string, because string interpolation combined the two for us.

//    Now, we could have written that using the + operator, like this:

var name2 = "Tim McGraw"
"Your name is " + name2
//…but that's not as efficient, particularly if you're combining multiple variables together. In addition, string interpolation in Swift is smart enough to be able to handle a variety of different data types automatically. For example:

var name3 = "Tim McGraw"
var age = 25
var latitude = 36.166667

"Your name is \(name3), your age is \(age), and your latitude is \(latitude)"
//Doing that using + is much more difficult, because Swift doesn't let you add integers and doubles to a string.
//
//At this point your result may no longer fit in the results pane, so either resize your window or hover over the result and click the + button that appears to have it shown inline.
//
//One of the powerful features of string interpolation is that everything between \( and ) can actually be a full Swift expression. For example, you can do mathematics in there using operators, like this:

var age2 = 25
"You are \(age2) years old. In another \(age2) years you will be \(age2 * 2)."
