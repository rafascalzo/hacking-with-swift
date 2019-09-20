import UIKit

var evenNumbers = [2, 4, 6, 7]
var songs:[String] = ["Fear of The Dark", "Master of puppets","Can i play with madness?", "The Dance of Eternity"]
var songsAnd:[Any] = ["Fear of The Dark", "Master of puppets","Can i play with madness?", "The Dance of Eternity", 3]

songs[0]
songs[1]
songs[2]
//songs[7] index out of range
type(of: songs)
type(of: songsAnd)

var songs1:[String] = []
//songs1[0] = "Stairway to heaven" index out of range
songs1.append("Stairway to heaven")

var songs2 = [String]()
//songs2[0] = "Stairway to heaven" // index out of range
songs2.append("Stairwai to heaven")

var songs3 = ["Give it away","Octavarium","sonata n.º14, Op. 27 n.º2"]
var songs4 = ["Hungarian rhapsody","Californication","Fairy Tale"]

var both = songs3 + songs4

both  += ["Welcome to the jungle"]

print(both)
