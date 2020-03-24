//
//  protocols.swift
//  hacking-with-swift
//
//  Created by rafaelviewcontroller on 10/3/19.
//  Copyright © 2019 rafaelviewcontroller. All rights reserved.
//

//Protocols are a way of describing what properties and methods something must have. You then tell Swift which types use that protocol – a process known as adopting or conforming to a protocol.
//
//For example, we can write a function that accepts something with an id property, but we don’t care precisely what type of data is used. We’ll start by creating an Identifiable protocol, which will require all conforming types to have an id string that can be read (“get”) or written (“set”):

protocol Identifiable {
    var id: String { get set }
}
//We can’t create instances of that protocol - it’s a description, not a type by itself. But we can create a struct that conforms to it:

struct User: Identifiable {
    var id: String
}
//Finally, we’ll write a displayID() function that accepts any Identifiable object:

func displayID(thing: Identifiable) {
    print("My ID is \(thing.id)")
}

protocol Rafael {
    var isBusy: Bool { get set }
    
    func printMyName()
}

struct Rafa: Rafael {
    //var isBusy : Bool
    func printMyName() {
        print("My name is"")
    }
}

func printRafa(thing: Rafael) {
    thing.printMyName
}

printRafa(Rafael())
