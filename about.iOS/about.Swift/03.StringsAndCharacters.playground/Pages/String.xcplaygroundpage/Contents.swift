/*:
# Strings and Characters
*/

import UIKit

/*:
## String Literals
*/

do {
    let someString = "Some string literal value"
}

/*:
## Initializing an Empty String
*/

do {
    // these two strings are both empty, and are equivalent to each other
    var emptyString = ""               // empty string literal
    var anotherEmptyString = String()  // initializer syntax
    
    if emptyString.isEmpty {
        print("Nothing to see here")
    }
}

/*:
## String Mutability
 * This approach is different from string mutation in Objective-C and Cocoa, where you choose between two classes (NSString and NSMutableString) to indicate whether a string can be mutated.
*/
do {
    var variableString = "Horse"
    variableString += " and carriage"

//    occurs compile error
//    let constantString = "Highlander"
//    constantString += " and another Highlander"
    
}

/*:
## Strings Are Value Types
 * String value is copied when it is passed to a function or method, or when it is assigned to a constant or variable.
 * In each case, a new copy of the existing String value is created, and the new copy is passed or assigned, not the original version.
*/

/*:
## Working with Characters
 * you can create a stand-alone Character constant or variable from a single-character string literal by providing a Character type annotation
*/

do {
    for character in "Dog!🐶".characters {
        print(character)
    }
    
    let exclamationMark: Character = "!"
}


do {
    // String values can be constructed by passing an array of Character values as an argument to its initializer:
    let catCharacters: [Character] = ["C", "a", "t", "!", "🐱"]
    let catString = String(catCharacters)
    print(catString)
}

/*:
## Concatenating Strings and Characters
*/

do {
    let string1 = "hello"
    let string2 = " there"
    var welcome = string1 + string2
}

/*:
### Append string
*/

do {
    let string2 = " there"
    var instruction = "look over"
    instruction += string2 // instruction must be variable
}

/*:
### Append Characters
 * You can’t append a String or Character to an existing Character variable, because a Character value must contain a single character only.
*/

do {
    
    let string1 = "hello"
    let string2 = " there"
    var welcome = string1 + string2
    
    let exclamationMark: Character = "!"
    welcome.append(exclamationMark)
}

/*:
## String Interpolation
*/
do {
    let multiplier = 3
    let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"
}



//: [Next](@next)



