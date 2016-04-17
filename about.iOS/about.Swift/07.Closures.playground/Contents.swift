/*:
# Closure
 * Closures are self-contained blocks of functionality that can be passed around and used in your code.

 * Global functions are closures that have a name and do not capture any values.
 * Nested functions are closures that have a name and can capture values from their enclosing function.
 * Closure expressions are unnamed closures written in a lightweight syntax that can capture values from their surrounding context.
*/
import UIKit


/*:
## Closure Expressions
*/

/*:
### The Sort Method
*/

do {
    let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
    func backwards(s1: String, _ s2: String) -> Bool {
        return s1 > s2
    }
    var reversed = names.sort(backwards)
}

/*:
### Closure Expression Syntax
*/
do {
    let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
    var reversed = names.sort({ (s1: String, s2: String) -> Bool in
        return s1 > s2
    })
    reversed = names.sort( { (s1: String, s2: String) -> Bool in return s1 > s2 } )
}

/*:
### Inferring Type From Context
*/
do {
    let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
    var reversed = names.sort( { s1, s2 in return s1 > s2 } )
}

/*:
### Implicit Returns from Single-Expression Closures
*/
do {
    let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
    var reversed = names.sort( { s1, s2 in s1 > s2 } )
}

/*:
### Shorthand Argument Names
*/
do {
    let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
    var reversed = names.sort( { $0 > $1 } )
}

/*:
### Operator Functions
*/
do {
    let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
    var reversed = names.sort(>)
}

/*:
## Trailing Closures
*/
do {
    func someFunctionThatTakesAClosure(closure: () -> Void) {
        // function body goes here
    }

    // here's how you call this function without using a trailing closure:
    
    someFunctionThatTakesAClosure({
        // closure's body goes here
    })
    
    // here's how you call this function with a trailing closure instead:
    
    someFunctionThatTakesAClosure {
        // trailing closure's body goes here
    }
    
    let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
    var reversed = names.sort { $0 > $1 }
}

do {
    let digitNames = [
        0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
        5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
    ]
    let numbers = [16, 58, 510]
    
    let strings = numbers.map {
        (number) -> String in
        var number = number
        var output = ""
        while number > 0 {
            output = digitNames[number % 10]! + output
            number /= 10
        }
        return output
    }
    
    // strings is inferred to be of type [String]
    // its value is ["OneSix", "FiveEight", "FiveOneZero"]
}

/*:
## Capturing Values
 * 중요!
*/

do {
    func makeIncrementer(forIncrement amount: Int) -> () -> Int {
        var runningTotal = 0
        func incrementer() -> Int {
            runningTotal += amount
            return runningTotal
        }
        return incrementer
    }
    
    // capture runningTotal as 0
    let incrementByTen = makeIncrementer(forIncrement: 10)

    incrementByTen()
    // returns a value of 10
    incrementByTen()
    // returns a value of 20
    incrementByTen()
    // returns a value of 30
    
    // capture runningTotal as 0
    let incrementBySeven = makeIncrementer(forIncrement: 7)
    incrementBySeven()
    
    incrementByTen()
}

/*:
## Closures Are Reference Types
 * 중요!
*/
do {
    func makeIncrementer(forIncrement amount: Int) -> () -> Int {
        var runningTotal = 0
        func incrementer() -> Int {
            runningTotal += amount
            return runningTotal
        }
        return incrementer
    }
    
    // capture runningTotal as 0
    let incrementByTen = makeIncrementer(forIncrement: 10)
    
    incrementByTen()
    // returns a value of 10
    incrementByTen()
    // returns a value of 20
    incrementByTen()
    // returns a value of 30
    
    incrementByTen()
    // returns a value of 40
    
    let alsoIncrementByTen = incrementByTen
    alsoIncrementByTen()
    // returns a value of 50

}

/*:
## Nonescaping Closures
 * A closure is said to escape a function when the closure is passed as an argument to the function, but is called after the function returns.
 * When you declare a function that takes a closure as one of its parameters, you can write @noescape before the parameter name to indicate that the closure is not allowed to escape.
 * Marking a closure with @noescape lets the compiler make more aggressive optimizations because it knows more information about the closure’s lifespan.
 * As an example, the sort(_:) method takes a closure as its parameter, which is used to compare elements. The parameter is marked @noescape because it is guaranteed not to be needed after sorting is complete.
*/
do {
//    func someFunctionWithNonescapingClosure(@noescape closure: () -> Void) {
//        closure()
//    }
//    
//    var completionHandlers: [() -> Void] = []
//    func someFunctionWithEscapingClosure(completionHandler: () -> Void) {
//        completionHandlers.append(completionHandler)
//    }
//    
//    class SomeClass {
//        var x = 10
//        func doSomething() {
//            someFunctionWithEscapingClosure { self.x = 100 }
//            someFunctionWithNonescapingClosure { x = 200 }
//        }
//    }
//    
//    let instance = SomeClass()
//    instance.doSomething()
//    print(instance.x)
//    // Prints "200"
//    
//    completionHandlers.first?()
//    print(instance.x)
//    // Prints "100"
//
}

/*:
## Autoclosures
 * An autoclosure is a closure that is automatically created to wrap an expression that’s being passed as an argument to a function.
 * An autoclosure lets you delay evaluation, because the code inside isn’t run until you call the closure. 
 * Delaying evaluation is useful for code that has side effects or is computationally expensive, because it lets you control when that code is evaluated.
*/

do {
    var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
    print(customersInLine.count)
    // Prints "5"
    
    let customerProvider = { customersInLine.removeAtIndex(0) }
    print(customersInLine.count)
    // Prints "5"
    
    print("Now serving \(customerProvider())!")
    // Prints "Now serving Chris!"
    print(customersInLine.count)
    // Prints "4"
}

do {
    var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
    func serveCustomer(customerProvider: () -> String) {
        print("Now serving \(customerProvider())!")
    }
    serveCustomer( { customersInLine.removeAtIndex(0) } )
}

// Overusing autoclosures can make your code hard to understand. 
// The context and function name should make it clear that evaluation is being deferred.
do {
    var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
    // customersInLine is ["Ewa", "Barry", "Daniella"]
    func serveCustomer(@autoclosure customerProvider: () -> String) {
        print("Now serving \(customerProvider())!")
    }
    serveCustomer(customersInLine.removeAtIndex(0))
}


// The @autoclosure attribute implies the @noescape attribute,
// If you want an autoclosure that is allowed to escape, use the @autoclosure(escaping) form of the attribute.

do {
    var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
    
    var customerProviders: [() -> String] = []
    func collectCustomerProviders(@autoclosure(escaping) customerProvider: () -> String) {
        customerProviders.append(customerProvider)
    }
    collectCustomerProviders(customersInLine.removeAtIndex(0))
    collectCustomerProviders(customersInLine.removeAtIndex(0))
    
    print("Collected \(customerProviders.count) closures.")
    // Prints "Collected 2 closures."
    for customerProvider in customerProviders {
        print("Now serving \(customerProvider())!") //클로저 customerProvider가 escaping 했다
    }
    // Prints "Now serving Barry!"
    // Prints "Now serving Daniella!"
    
    
}