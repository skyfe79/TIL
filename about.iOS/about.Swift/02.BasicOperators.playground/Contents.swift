/*:
# Basic Operators
*/

import UIKit

/*:
## Terminology
*/

do {
    let a = 100 > 10 ? true : false
}

/*:
## Assignment Operator
*/

do {
    let b = 10
    var a = 5
    a = b
    
    let (x, y) = (1, 2)
    
//    if x = y {
//        // this is not valid, because x = y does not return a value
//    }
}

/*:
## Arithmetic Operators
 * Addition (+)
 * Subtraction (-)
 * Multiplication (*)
 * Division (/)
*/

do {
    1 + 2       // equals 3
    5 - 3       // equals 2
    2 * 3       // equals 6
    10.0 / 2.5  // equals 4.0
    
    "hello, " + "world"  // equals "hello, world"
}

/*:
## Remainder Operator
 * a = (b x some multiplier) + remainder
*/

do {
    9 % 4  //  9 = (4 *  2) +  1
    -9 % 4 // -9 = (4 * -2) + -1
}

/*:
### Floating-Point Remainder Calculations
*/

do {
    8 % 2.5   // equals 0.5 8 = (2.5 * 3) + 0.5
}

/*:
## Unary Minus Operator
*/

do {
    let three = 3
    let minusThree = -three       // minusThree equals -3
    let plusThree = -minusThree   // plusThree equals 3, or "minus minus three"
}

/*:
## Unary Plus Operator
*/

do {
    let minusSix = -6
    let alsoMinusSix = +minusSix  // alsoMinusSix equals -6
}

/*:
## Compound Assignment Operators
 * The compound assignment operators do not return a value. For example, you cannot write let b = a += 2.
 * You can only use compound assignment operator to variable
*/

do {
    var a = 1
    a += 2
}


/*:
## Comparison Operators
 * Equal to (a == b)
 * Not equal to (a != b)
 * Greater than (a > b)
 * Less than (a < b)
 * Greater than or equal to (a >= b)
 * Less than or equal to (a <= b)
 * Swift also provides two identity operators (=== and !==), which you use to test whether two object references both refer to the same object instance.
*/

do {
    1 == 1   // true because 1 is equal to 1
    2 != 1   // true because 2 is not equal to 1
    2 > 1    // true because 2 is greater than 1
    1 < 2    // true because 1 is less than 2
    1 >= 1   // true because 1 is greater than or equal to 1
    2 <= 1   // false because 2 is not less than or equal to 1
}

do {
    let name = "world"
    if name == "world" {
        print("hello, world")
    } else {
        print("I'm sorry \(name), but I don't recognize you")
    }
}

do {
//    #if swift(2.2)
//    (1, "zebra") < (2, "apple")   // true because 1 is less than 2
//    (3, "apple") < (3, "bird")    // true because 3 is equal to 3, and "apple" is less than "bird"
//    (4, "dog") == (4, "dog")      // true because 4 is equal to 4, and "dog" is equal to "dog"
//    #endif
}

/*:
## Ternary Conditional Operator
*/

do {
    let contentHeight = 40
    let hasHeader = true
    let rowHeight = contentHeight + (hasHeader ? 50 : 20)
}

// is equal to below

do {
    let contentHeight = 40
    let hasHeader = true
    let rowHeight: Int
    if hasHeader {
        rowHeight = contentHeight + 50
    } else {
        rowHeight = contentHeight + 20
    }
}

/*:
## Nil Coalescing Operator
 * a != nil ? a! : b
*/

do {
    let defaultColorName = "red"
    var userDefinedColorName: String?   // defaults to nil
    
    var colorNameToUse = userDefinedColorName ?? defaultColorName
    
    userDefinedColorName = "green"
    colorNameToUse = userDefinedColorName ?? defaultColorName
}

/*:
## Range Operators
 * Closed Range Operator
 * Half-Open Range Operator
*/

/*:
### Closed Range Operator
 * a...b
*/

do {
    for index in 1...5 {
        print("\(index) times 5 is \(index * 5)")
    }
}

/*:
### Half-Open Range Operator
 * a..<b
*/

do {
    let names = ["Anna", "Alex", "Brian", "Jack"]
    let count = names.count
    for i in 0..<count {
        print("Person \(i + 1) is called \(names[i])")
    }
}

/*:
## Logical Operators
 * Logical NOT (!a)
 * Logical AND (a && b)
 * Logical OR (a || b)
*/


/*:
### Logical NOT Operator
*/

do {
    let allowedEntry = false
    if !allowedEntry {
        print("ACCESS DENIED")
    }
}

/*:
### Logical AND Operator
*/

do {
    let enteredDoorCode = true
    let passedRetinaScan = false
    if enteredDoorCode && passedRetinaScan {
        print("Welcome!")
    } else {
        print("ACCESS DENIED")
    }
}

/*:
### Logical OR Operator
*/

do {
    let hasDoorKey = false
    let knowsOverridePassword = true
    if hasDoorKey || knowsOverridePassword {
        print("Welcome!")
    } else {
        print("ACCESS DENIED")
    }
}

/*:
## Combining Logical Operators
 * The Swift logical operators && and || are left-associative, meaning that compound expressions with multiple logical operators evaluate the leftmost subexpression first.
*/

do {
    let enteredDoorCode = true
    let passedRetinaScan = false
    let hasDoorKey = false
    let knowsOverridePassword = true
    
    if enteredDoorCode && passedRetinaScan || hasDoorKey || knowsOverridePassword {
        print("Welcome!")
    } else {
        print("ACCESS DENIED")
    }
}

/*:
### Explicit Parentheses
*/
do {
    do {
        let enteredDoorCode = true
        let passedRetinaScan = false
        let hasDoorKey = false
        let knowsOverridePassword = true
        
        if (enteredDoorCode && passedRetinaScan) || hasDoorKey || knowsOverridePassword {
            print("Welcome!")
        } else {
            print("ACCESS DENIED")
        }
    }
}








