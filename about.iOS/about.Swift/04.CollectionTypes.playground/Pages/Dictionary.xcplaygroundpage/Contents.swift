//: [Previous](@previous)
/*:
## Dictionary
*/
import UIKit

/*:
### Dictionary Type Shorthand Syntax
 * A dictionary Key type must conform to the Hashable protocol, like a set’s value type.
*/
do {
    let dict = Dictionary<String, Int>()
    let dict2 = [String:Int]()
}


/*:
### Creating an Empty Dictionary
*/
do {
    var namesOfItegers = [Int:String]()
    namesOfItegers[16] = "sixteen"
    namesOfItegers = [:]
}

/*:
### Creating a Dictionary with a Dictionary Literal
*/

do {
    var airports: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]
    
}

/*:
### Accessing and Modifying a Dictionary
*/
do {
    var airports: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]
    print("The airports dictionary contains \(airports.count) items.")
    
    if airports.isEmpty {
        print("The airports dictionary is empty.")
    } else {
        print("The airports dictionary is not empty.")
    }
    
    airports["LHR"] = "London"
    airports["LHR"] = "London Heathrow"
    
    if let oldValue = airports.updateValue("Dublin Airport", forKey: "DUB") {
        print("The old value for DUB was \(oldValue).")
    }
    
    if let airportName = airports["DUB"] {
        print("The name of the airport is \(airportName).")
    } else {
        print("That airport is not in the airports dictionary.")
    }
    
    airports["APL"] = "Apple International"
    // "Apple International" is not the real airport for APL, so delete it
    airports["APL"] = nil
    // APL has now been removed from the dictionary
    
    if let removedValue = airports.removeValueForKey("DUB") {
        print("The removed airport's name is \(removedValue).")
    } else {
        print("The airports dictionary does not contain a value for DUB.")
    }
    // Prints "The removed airport's name is Dublin Airport."
}

/*:
### Iterating Over a Dictionary
*/
do {
    var airports: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]
    
    for (airportCode, airportName) in airports {
        print("\(airportCode): \(airportName)")
    }
    
    for airportCode in airports.keys {
        print("Airport code: \(airportCode)")
    }
    
    for airportName in airports.values {
        print("Airport name: \(airportName)")
    }
    
    // If you need to use a dictionary’s keys or values with an API that takes an Array instance, initialize a new array with the keys or values property:
    let airportCodes = [String](airports.keys)
    // airportCodes is ["YYZ", "LHR"]

    let airportNames = [String](airports.values)
    // airportNames is ["Toronto Pearson", "London Heathrow"]
}


//: [Next](@next)
