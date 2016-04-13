/*:
# Functions
*/
import UIKit

/*:
## Defining and Calling Functions
*/

do {
    
    func sayHello(personName: String) -> String {
        let greeting = "Hello, " + personName + "!"
        return greeting
    }
    
    print(sayHello("Anna"))
    print(sayHello("Brian"))
}

do {
    
    func sayHelloAgain(personName: String) -> String {
        return "Hello again, " + personName + "!"
    }
    print(sayHelloAgain("Anna"))
    
}



/*:
## Function Parameters and Return Values
*/

/*:
### Functions Without Parameters
*/

do {
    func sayHelloWorld() -> String {
        return "hello, world"
    }
    print(sayHelloWorld())
}

/*:
### Functions With Multiple Parameters
*/

do {
    func sayHelloAgain(personName: String) -> String {
        return "Hello again, " + personName + "!"
    }
    
    func sayHello(personName: String, alreadyGreeted: Bool = false) -> String {
        if alreadyGreeted {
            return sayHelloAgain(personName)
        } else {
            return sayHello(personName)
        }
    }
    print(sayHello("Tim", alreadyGreeted: true))
}

/*:
### Functions Without Return Values
*/

do {
    func sayGoodbye(personName: String) {
        print("Goodbye, \(personName)!")
    }
    sayGoodbye("Dave")
}

/*:
### The return value of a function can be ignored when it is called:
*/

do {
    
    func printAndCount(stringToPrint: String) -> Int {
        print(stringToPrint)
        return stringToPrint.characters.count
    }
    func printWithoutCounting(stringToPrint: String) {
        printAndCount(stringToPrint)
    }
    printAndCount("hello, world")
    // prints "hello, world" and returns a value of 12
    printWithoutCounting("hello, world")
    // prints "hello, world" but does not return a value
    
}


/*:
### Functions with Multiple Return Values
 * 반환 값에 이름을 지을 수 있다!
*/

do {
    func minMax(array: [Int]) -> (min: Int, max: Int) {
        var currentMin = array[0]
        var currentMax = array[0]
        for value in array[1..<array.count] {
            if value < currentMin {
                currentMin = value
            } else if value > currentMax {
                currentMax = value
            }
        }
        return (currentMin, currentMax)
    }
    
    let bounds = minMax([8, -6, 2, 109, 3, 71])
    print("min is \(bounds.min) and max is \(bounds.max)")
}

/*:
### Optional Tuple Return Types
*/

do {
    func minMax(array: [Int]) -> (min: Int, max: Int)? {
        if array.isEmpty { return nil }
        var currentMin = array[0]
        var currentMax = array[0]
        for value in array[1..<array.count] {
            if value < currentMin {
                currentMin = value
            } else if value > currentMax {
                currentMax = value
            }
        }
        return (currentMin, currentMax)
    }
    
    if let bounds = minMax([8, -6, 2, 109, 3, 71]) {
        print("min is \(bounds.min) and max is \(bounds.max)")
    }
}

/*:
## Function Parameter Names
*/

do {
    func someFunction(firstParameterName: Int, secondParameterName: Int) {
        // function body goes here
        // firstParameterName and secondParameterName refer to
        // the argument values for the first and second parameters
    }
    someFunction(1, secondParameterName: 2)
}

/*:
### Specifying External Parameter Names
*/

do {
    func someFunction(externalParameterName localParameterName: Int) {
        // function body goes here, and can use localParameterName
        // to refer to the argument value for that parameter
    }
    
    func sayHello(to person: String, and anotherPerson: String) -> String {
        return "Hello \(person) and \(anotherPerson)!"
    }
    print(sayHello(to: "Bill", and: "Ted"))
}

/*:
### Omitting External Parameter Names
*/

do {
    func someFunction(firstParameterName: Int, _ secondParameterName: Int) {
        // function body goes here
        // firstParameterName and secondParameterName refer to
        // the argument values for the first and second parameters
    }
    someFunction(1, 2)
}

/*:
### Default Parameter Values
*/

do {
    func someFunction(parameterWithDefault: Int = 12) {
        // function body goes here
        // if no arguments are passed to the function call,
        // value of parameterWithDefault is 12
    }
    someFunction(6) // parameterWithDefault is 6
    someFunction() // parameterWithDefault is 12
}

/*:
### Variadic Parameters
 * A variadic parameter accepts zero or more values of a specified type.
*/

do {
    func arithmeticMean(numbers: Double...) -> Double {
        var total: Double = 0
        for number in numbers {
            total += number
        }
        return total / Double(numbers.count)
    }
    arithmeticMean(1, 2, 3, 4, 5)
    // returns 3.0, which is the arithmetic mean of these five numbers
    arithmeticMean(3, 8.25, 18.75)
    // returns 10.0, which is the arithmetic mean of these three numbers
}

/*:
### In-Out Parameters
 * Function parameters are constants by default. 
 * An in-out parameter has a value that is passed in to the function, is modified by the function, and is passed back out of the function to replace the original value.
 * In-out parameters cannot have default values, and variadic parameters cannot be marked as inout.
*/
do {
    func swapTwoInts(inout a: Int, inout _ b: Int) {
        let temporaryA = a
        a = b
        b = temporaryA
    }
    
    var someInt = 3
    var anotherInt = 107
    swapTwoInts(&someInt, &anotherInt)
    print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")
}

/*:
## Function Types
 * Every function has a specific function type, made up of the parameter types and the return type of the function.
*/

do {
    
    // (Int, Int) -> Int
    func addTwoInts(a: Int, _ b: Int) -> Int {
        return a + b
    }
    // (Int, Int) -> Int
    func multiplyTwoInts(a: Int, _ b: Int) -> Int {
        return a * b
    }
    // () -> Void
    func printHelloWorld() {
        print("hello, world")
    }
}

/*:
### Using Function Types
*/

do {
    // (Int, Int) -> Int
    func addTwoInts(a: Int, _ b: Int) -> Int {
        return a + b
    }
    // (Int, Int) -> Int
    func multiplyTwoInts(a: Int, _ b: Int) -> Int {
        return a * b
    }
    // () -> Void
    func printHelloWorld() {
        print("hello, world")
    }
    
    var mathFunction: (Int, Int) -> Int = addTwoInts
    print("Result: \(mathFunction(2, 3))")
    
    mathFunction = multiplyTwoInts
    print("Result: \(mathFunction(2, 3))")
    
    let anotherMathFunction = addTwoInts
}

/*:
### Function Types as Parameter Types
*/

do {
    
    // (Int, Int) -> Int
    func addTwoInts(a: Int, _ b: Int) -> Int {
        return a + b
    }
    // (Int, Int) -> Int
    func multiplyTwoInts(a: Int, _ b: Int) -> Int {
        return a * b
    }
    // () -> Void
    func printHelloWorld() {
        print("hello, world")
    }
    
    func printMathResult(mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
        print("Result: \(mathFunction(a, b))")
    }
    printMathResult(addTwoInts, 3, 5)
}

/*:
### Function Types as Return Types
*/

do {
    func stepForward(input: Int) -> Int {
        return input + 1
    }
    func stepBackward(input: Int) -> Int {
        return input - 1
    }
    
    func chooseStepFunction(backwards: Bool) -> (Int) -> Int {
        return backwards ? stepBackward : stepForward
    }
    
    var currentValue = 3
    let moveNearerToZero = chooseStepFunction(currentValue > 0)

    print("Counting to zero:")
    // Counting to zero:
    while currentValue != 0 {
        print("\(currentValue)... ")
        currentValue = moveNearerToZero(currentValue)
    }
    print("zero!")
}


/*:
## Nested Functions
*/

do {
    
    // It's function factory!
    func chooseStepFunction(backwards: Bool) -> (Int) -> Int {
        func stepForward(input: Int) -> Int { return input + 1 }
        func stepBackward(input: Int) -> Int { return input - 1 }
        return backwards ? stepBackward : stepForward
    }
    
    var currentValue = -4
    let moveNearerToZero = chooseStepFunction(currentValue > 0)
    // moveNearerToZero now refers to the nested stepForward() function
    while currentValue != 0 {
        print("\(currentValue)... ")
        currentValue = moveNearerToZero(currentValue)
    }
    print("zero!")
}