import UIKit

var action: String
var person = "jumbo"

if person == "hater" {
    action = "hate"
} else if  person == "player" {
    action = "play"
} else {
    action = "cruise"
}

var action1: String

var stayOutTooLate = false
var nothingInBrain = true

if stayOutTooLate && nothingInBrain {
    action = "cruise"
}

if !stayOutTooLate && nothingInBrain {
    action = "other"
}
if !stayOutTooLate && !nothingInBrain {
    action = "free pipe"
}
