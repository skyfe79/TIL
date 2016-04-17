/*:
# Generics
*/
import UIKit

/*:
## The Problem That Generics Solve
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
    // Prints "someInt is now 107, and anotherInt is now 3"
    
    func swapTwoStrings(inout a: String, inout _ b: String) {
        let temporaryA = a
        a = b
        b = temporaryA
    }
    
    func swapTwoDoubles(inout a: Double, inout _ b: Double) {
        let temporaryA = a
        a = b
        b = temporaryA
    }
}

/*:
## Generic Functions
*/
do {
    func swapTwoValues<T>(inout a: T, inout _ b: T) {
        let temporaryA = a
        a = b
        b = temporaryA
    }
    
    var someInt = 3
    var anotherInt = 107
    swapTwoValues(&someInt, &anotherInt)
    // someInt is now 107, and anotherInt is now 3
    
    var someString = "hello"
    var anotherString = "world"
    swapTwoValues(&someString, &anotherString)
    // someString is now "world", and anotherString is now "hello"
}

struct IntStack {
    var items = [Int]()
    mutating func push(item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
}

struct Stack<Element> {
    var items = [Element]()
    mutating func push(item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
stackOfStrings.push("cuatro")
// the stack now contains 4 strings

let fromTheTop = stackOfStrings.pop()
// fromTheTop is equal to "cuatro", and the stack now contains 3 strings

/*:
## Extending a Generic Type
*/
extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}
if let topItem = stackOfStrings.topItem {
    print("The top item on the stack is \(topItem).")
}
// Prints "The top item on the stack is tres."


/*:
## Type Constraints
 * 중요함
*/
//func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
//    // function body goes here
//}

func findStringIndex(array: [String], _ valueToFind: String) -> Int? {
    for (index, value) in array.enumerate() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

let strings = ["cat", "dog", "llama", "parakeet", "terrapin"]
if let foundIndex = findStringIndex(strings, "llama") {
    print("The index of llama is \(foundIndex)")
}
// Prints "The index of llama is 2"

func findIndex<T : Equatable>(array: [T], _ valueToFind: T) -> Int? {
    for (index, value) in array.enumerate() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

let doubleIndex = findIndex([3.14159, 0.1, 0.25], 9.3)
// doubleIndex is an optional Int with no value, because 9.3 is not in the array
let stringIndex = findIndex(["Mike", "Malcolm", "Andrea"], "Andrea")
// stringIndex is an optional Int containing a value of 2


/*:
## Associated Types
 * When defining a protocol, it is sometimes useful to declare one or more associated types as part of the protocol’s definition
 * An associated type gives a placeholder name to a type that is used as part of the protocol.
 * The actual type to use for that associated type is not specified until the protocol is adopted. 
 * Associated types are specified with the associatedtype keyword.
*/
protocol Container {
    associatedtype ItemType
    mutating func append(item: ItemType)
    var count: Int { get }
    subscript(i: Int) -> ItemType { get }
}

struct IntStack: Container {
    // original IntStack implementation
    var items = [Int]()
    mutating func push(item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
    // conformance to the Container protocol
    typealias ItemType = Int
    mutating func append(item: Int) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Int {
        return items[i]
    }
}


/*
This time, the type parameter Element is used as the type of the append(_:) method’s item parameter and the return type of the subscript. Swift can therefore infer that Element is the appropriate type to use as the ItemType for this particular container.
*/


struct Stack2<Element>: Container {
    // original Stack<Element> implementation
    var items = [Element]()
    mutating func push(item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    // conformance to the Container protocol
    mutating func append(item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}



/*:
## Where Clauses
 * C1 must conform to the Container protocol (written as C1: Container).
 * C2 must also conform to the Container protocol (written as C2: Container).
 * The ItemType for C1 must be the same as the ItemType for C2 (written as C1.ItemType == C2.ItemType).
 * The ItemType for C1 must conform to the Equatable protocol (written as C1.ItemType: Equatable).
*/
func allItemsMatch<
    C1: Container, C2: Container
    where C1.ItemType == C2.ItemType, C1.ItemType: Equatable>
    (someContainer: C1, _ anotherContainer: C2) -> Bool {
        
        // check that both containers contain the same number of items
        if someContainer.count != anotherContainer.count {
            return false
        }
        
        // check each pair of items to see if they are equivalent
        for i in 0..<someContainer.count {
            if someContainer[i] != anotherContainer[i] {
                return false
            }
        }
        
        // all items match, so return true
        return true
        
}

var stackOfStrings = Stack2<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")

var arrayOfStrings = ["uno", "dos", "tres"]

if allItemsMatch(stackOfStrings, arrayOfStrings) {
    print("All items match.")
} else {
    print("Not all items match.")
}
// Prints "All items match."
