//
//  Extensions.swift
//  Consolidation_IX
//
//  Created by Rafael VSM on 19/01/20.
//  Copyright © 2020 Rafael VSM. All rights reserved.
//

import Foundation

extension Int {
    
    var isOdd: Bool {
        return !self.isMultiple(of: 2)
    }
    
    var isEven: Bool {
        return self.isMultiple(of: 2)
    }
}

// However, that will only extend Int – Swift has a variety of different sizes and types of integers to handle very specific situations. For example, ‌Int8 is a very small integer that holds between -128 and 127, for times when you don’t need much data but space is really restricted. Or there’s UInt64, which holds much larger numbers than a regular Int, but those numbers must always be positive.

// Making extensions for whole protocols at once adds our functionality to many places, which in the case of integers means we can add isOdd and isEven to Int, Int8, UInt64, and more by extending the BinaryInteger protocol that covers them all:


extension BinaryInteger {
    
    var isOdd: Bool {
        return !self.isMultiple(of: 2)
    }
    
    var isEven: Bool {
        return self.isMultiple(of: 2)
    }
}

// However, where things get really interesting is if when we want only a subset of a protocol to be extended. For example, Swift has a Collection protocol that covers arrays, dictionaries, sets, and more, and if we wanted to write a method that counted how many odd and even numbers it held we might start by writing something like this:

extension Collection {
    
    func countOddEven() -> (odd:Int, even:Int) {
        var odd = 0
        var even = 0
        
        for case let val as Int in self {
            if val.isMultiple(of: 2) {
                even += 1
            } else {
                odd += 1
            }
        }
        
        
        /* go over all values
               for val in self {
                   if val.isMultiple(of: 2) {
                       // this is even; add one to our even count
                       even += 1
                   } else {
                       // this must be odd; add one to our odd count
                       odd += 1
                   }
               }
        */
        return (odd,even)
    }
}

// However, that code won’t work. You see, we’re trying to extend all collections, which means we’re asking Swift to make the method available on arrays like this one:

// That array contains strings, and we can’t check whether a string is a multiple of 2 – it just doesn’t make sense.

// What we mean to say is “add this method to all collections that contain integers, regardless of that integer type.” To make this work, you need to specify a where clause to filter where the extension is applied: we want this extension only for collections where the elements inside that collection conform to the BinaryInteger protocol.

// This is actually surprisingly easy to do – just modify the extension to this:

extension Collection where Element: BinaryInteger {
    
    func countOddEven() -> (odd:Int, even:Int) {
        var odd = 0
        var even = 0
        
        for val in self {
            if val.isMultiple(of: 2) {
                even += 1
            } else {
                odd += 1
            }
        }
        return (odd,even)
    }
}

// As you’ll learn, these extension constraints are extraordinarily powerful, particularly when you constrain using a protocol rather than specific type. For example, if you extend Array so that your methods only apply to arrays that hold Comparable objects, the methods in that extension gain access to a whole range of built-in methods such as firstIndex(of:), contains(), sort(), and more – because Swift knows the elements must all conform to Comparable.

// If you want to try such a constraint yourself – and trust me, you’ll need it for one of the challenges coming up! – write your extensions like this:

extension Array where Element: Comparable {
    func doStuff(with: Element) {
        //
    }
}
