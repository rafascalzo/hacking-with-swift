import UIKit

//You can exit a loop at any time using the break keyword. To try this out, let’s start with a regular while loop that counts down for a rocket launch:

var countDown = 10

while countDown >= 0 {
    print(countDown)
    countDown -= 1
}
countDown = 10
print("Blast off!")
//In this case, the astronaut in command gets bored part-way through the countdown and decides to skip the remainder and launch straight away:

while countDown >= 0 {
    print(countDown)
    
    if countDown == 4 {
        print("I'm bored. Let's go now!")
        break
    }
    
    countDown -= 1
}
//With that change, as soon as countDown reaches 4 the astronaut’s message will be printed, and the rest of the loop gets skipped.
