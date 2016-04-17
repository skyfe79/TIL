/*:
# The Basic
*/

import UIKit

/*:
## Declaring Constants and Variables
*/

do {

    let maximumNumberOfLoginAttempts = 10
    var currentLoginAttempt = 0
}


do {
    var x = 0.0, y = 0.0, z = 0.0 // 동시에 여러개 선언
}



/*:
## Type Annotations
*/
do {
    var welcomeMessage: String
    welcomeMessage = "Hello"
}

do {
    var red, green, blue: Double
    red = 0.0
    green = 0.5
    blue = 1.0
}


/*:
## Naming Constants and Variables
*/

do {
    
    let π = 3.14159
    let 你好 = "你好世界"
    let 🐶🐮 = "dogcow"
    
}

do {
    var friendlyWelcome = "Hello!"
    friendlyWelcome = "Bonjour!" // It's Ok
    
    let languageName = "Swift"
    //languageName = "Swift++" // occuring compile time error

}

/*:
## Printing Constants and Variables
*/

do {
    var friendlyWelcome = "Hello!"
    friendlyWelcome = "Bonjour!"
    print(friendlyWelcome)
}

/*:
## String Interpolation
*/

do {
    let msg = "This is your message"
    print("Your message is \(msg)")
}

/*:
## Semicolons
*/

do {
    let cat = "🐱"; print(cat)
}

/*:
## Integers
*/

/*:
### Integer Bounds
*/
do {
    let minValue = UInt8.min
    let maxValue = UInt8.max
}

/*:
### Int
 * On a 32-bit platform, Int is the same size as Int32.
 * On a 64-bit platform, Int is the same size as Int64.
*/

do {
    let minValue = Int.min
    let maxValue = Int.max
}

/*:
### UInt
 * On a 32-bit platform, UInt is the same size as UInt32.
 * On a 64-bit platform, UInt is the same size as UInt64.
*/

do {
    let minValue = UInt.min
    let maxValue = UInt.max
}

/*:
### Overflow
*/

do {
    //let overflow1 : Int = Int.min - 1 // occuring compile error
    //let overflow2 : UInt = UInt.max + 1 // occuring compile error
}

/*:
## Floating-Point Numbers
 * Double represents a 64-bit floating-point number.
 * Float represents a 32-bit floating-point number.
*/

do {
    let PI : Float = 3.14159
    let PI_2 : Double = Double(PI) / 2
}

/*:
## Numeric Literals
 * A decimal number, with no prefix
 * A binary number, with a 0b prefix
 * An octal number, with a 0o prefix
 * A hexadecimal number, with a 0x prefix
 * 1.25e2 means 1.25 x 102, or 125.0.
 * 1.25e-2 means 1.25 x 10-2, or 0.0125.
 * 0xFp2 means 15 x 22, or 60.0.
 * 0xFp-2 means 15 x 2-2, or 3.75.
*/

do {
    let decimalInteger = 17
    let binaryInteger = 0b10001
    let octalInteger = 0o21
    let hexadecimalInteger = 0x11
    
    let decimalDouble = 12.1875
    let exponentDouble = 1.21875e1
    let hexadecimalDouble = 0xC.3p0
    
    let paddedDouble = 000123.456
    let oneMillion = 1_000_000
    let justOverOneMillion = 1_000_000.000_000_1
}

/*:
## Numeric Type Conversion
*/

/*:
### Integer Conversion
*/

do {
    //let cannotBeNegative: UInt8 = -1
    //let tooBig: Int8 = Int8.max + 1
}

/*:
### Integer and Floating-Point Conversion
*/
do {
    let three = 3
    let pointOneFourOneFiveNine = 0.14159
    let pi = Double(three) + pointOneFourOneFiveNine
    let integerPi = Int(pi)
}

/*:
## Type Aliases
*/

do {
    typealias AudioSample = UInt16
    var maxAmplitudeFound = AudioSample.min
}

/*:
## Booleans
*/

do {
    let orangesAreOrange = true
    let turnipsAreDelicious = false
    
    if turnipsAreDelicious {
        print("Mmm, tasty turnips!")
    } else {
        print("Eww, turnips are horrible.")
    }
    
    let i = 1
//    if i {
//        // this example will not compile, and will report an error
//    }

    if i == 1 {
        
    }
}

/*:
## Tuples
*/

do {
    let http404Error = (404, "Not Found")
    let (statusCode, statusMessage) = http404Error
    print("The status code is \(statusCode)")
    print("The status message is \(statusMessage)")
    
    let (justTheStatusCode, _) = http404Error
    print("The status code is \(justTheStatusCode)")
    
    print("The status code is \(http404Error.0)")
    print("The status message is \(http404Error.1)")
}

/*:
### Named parameter of Tuple
*/
do {
    let http200Status = (statusCode: 200, description: "OK")
    print("The status code is \(http200Status.statusCode)")
    print("The status message is \(http200Status.description)")
}



/*:
## Optionals
 * There is a value, and it equals x
 * There isn’t a value at all
*/

do {
    let possibleNumber = "123"
    let convertedNumber = Int(possibleNumber)
    
    let impossibleNumber = "123.xx"
    let convertedNumber2 = Int(impossibleNumber)
}

/*:
### nil
*/
do {
    var serverResponseCode: Int? = 404
    serverResponseCode = nil
    
    var surveyAnswer: String? // surveyAnswer is automatically set to nil
}

/*:
### If Statements and Forced Unwrapping
*/
do {
    let possibleNumber = "123"
    let convertedNumber = Int(possibleNumber)

    if convertedNumber != nil {
        print("convertedNumber contains some integer value.")
    }
    
    //Forced Unwrapping
    if convertedNumber != nil {
        print("convertedNumber has an integer value of \(convertedNumber!).")
    }
}

/*:
### Optional Binding
 * You can include multiple optional bindings in a single if statement and use a where clause to check for a Boolean condition.
*/
do {
    let possibleNumber = "123"
    if let actualNumber = Int(possibleNumber) {
        print("\"\(possibleNumber)\" has an integer value of \(actualNumber)")
    } else {
        print("\"\(possibleNumber)\" could not be converted to an integer")
    }
    
    // You can include multiple optional bindings in a single if statement and use a where clause to check for a Boolean condition. 
    if let firstNumber = Int("5"), secondNumber = Int("42") where firstNumber < secondNumber {
        print("\(firstNumber) < \(secondNumber)")
    }
    
    if let firstNumber = Int("50"), secondNumber = Int("42") where firstNumber < secondNumber {
        print("\(firstNumber) < \(secondNumber)")
    }
//  else block doesn't know firstNumber and secondNumber. it occurs compile error
//    else {
//        print("\(firstNumber) > \(secondNumber)")
//    }
}

/*:
### Implicitly Unwrapped Optionals
*/

do {
    let possibleString: String? = "An optional string."
    let forcedString: String = possibleString! // requires an exclamation mark
 
    let assumedString: String! = "An implicitly unwrapped optional string."
    let implicitString: String = assumedString // no need for an exclamation mark
    
    
    // implicit 이어도 optional이다. 따라서 nil 검사가 가능하다
    if assumedString != nil {
        print(assumedString)
    }
    
    // implicit 이어도 optional이다. 따라서 let 바인딩이 가능하다.
    if let definiteString = assumedString {
        print(definiteString)
    }
}


/*:
## Error Handling
* A do statement creates a new containing scope, which allows errors to be propagated to one or more catch clauses.
*/
do {
    
    func canThrowAnError() throws {
        // this function may or may not throw an error
    }
    
    
    do {
        try canThrowAnError()
        // no error was thrown
    } catch {
        // an error was thrown
    }
}

do {
    
    enum Error : ErrorType {
        case OutOfCleanDishes
        case MissingIngredients(ingredients : Int)
    }
    
    func makeASandwich() throws {
        // ...
        throw Error.MissingIngredients(ingredients: 10)
    }
    
    func eatASandwich() {
        print("eatASandwich")
    }
    
    func washDishes() {
        print("washDishes")
    }
    
    func buyGroceries(ingredients: Int) {
        print("buyGroceries \(ingredients)")
    }
    
    do {
        try makeASandwich()
        eatASandwich()
    } catch Error.OutOfCleanDishes {
        washDishes()
    } catch Error.MissingIngredients(let ingredients) {
        buyGroceries(ingredients)
    }
}


/*:
## Assertions
*/
do {
    assert(10 < 100, "It's impossible")
    //assert(10000 < 100, "It's impossible")
}

/*:
### Debugging with Assertions
*/
do {
    let age = 3
    assert(age >= 0, "A person's age cannot be less than zero")
    // this causes the assertion to trigger, because age is not >= 0
    
    // The assertion message can be omitted if desired, as in the following example:
    assert(age >= 0)
}

/*:
### When to Use Assertions
 * An integer subscript index is passed to a custom subscript implementation, but the subscript index value could be too low or too high.
 * A value is passed to a function, but an invalid value means that the function cannot fulfill its task.
 * An optional value is currently nil, but a non-nil value is essential for subsequent code to execute successfully.
*/

