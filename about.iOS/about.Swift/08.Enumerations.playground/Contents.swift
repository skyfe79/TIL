/*:
# Enumerations
*/
import UIKit

/*:
## Enumeration Syntax
*/
do {
    enum SomeEnumeration {
        // enumeration definition goes here
    }
}

do {
    enum CompassPoint {
        case North
        case South
        case East
        case West
    }
}

do {
    enum Planet {
        case Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune
    }
}

do {
    enum CompassPoint {
        case North
        case South
        case East
        case West
    }

    var directionToHead = CompassPoint.West
    directionToHead = .East
}

/*:
## Matching Enumeration Values with a Switch Statement
*/
do {
    enum CompassPoint {
        case North
        case South
        case East
        case West
    }
    
    var directionToHead = CompassPoint.West
    directionToHead = .East
    
    switch directionToHead {
    case .North:
        print("Lots of planets have a north")
    case .South:
        print("Watch out for penguins")
    case .East:
        print("Where the sun rises")
    case .West:
        print("Where the skies are blue")
    }
}

do {
    enum Planet {
        case Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune
    }
    
    let somePlanet = Planet.Earth
    switch somePlanet {
    case .Earth:
        print("Mostly harmless")
    default:
        print("Not a safe place for humans")
    }
    // Prints "Mostly harmless"
}

/*:
## Associated Values
 * You can define Swift enumerations to store associated values of any given type, and the value types can be different for each case of the enumeration if needed.
*/

do {
    enum Barcode {
        case UPCA(Int, Int, Int, Int)
        case QRCode(String)
    }
    
    var productBarcode = Barcode.UPCA(8, 85909, 51226, 3)
    productBarcode = .QRCode("ABCDEFGHIJKLMNOP")
    
    switch productBarcode {
    case .UPCA(let numberSystem, let manufacturer, let product, let check):
        print("UPC-A: \(numberSystem), \(manufacturer), \(product), \(check).")
    case .QRCode(let productCode):
        print("QR code: \(productCode).")
    }
    
    
    // If all of the associated values for an enumeration case are extracted as constants, or if all are extracted as variables, you can place a single var or let annotation before the case name, for brevity:
    switch productBarcode {
    case let .UPCA(numberSystem, manufacturer, product, check):
        print("UPC-A: \(numberSystem), \(manufacturer), \(product), \(check).")
    case let .QRCode(productCode):
        print("QR code: \(productCode).")
    }
}

/*:
## Raw Values
*/
do {
    enum ASCIIControlCharacter: Character {
        case Tab = "\t"
        case LineFeed = "\n"
        case CarriageReturn = "\r"
    }
}

/*:
### Implicitly Assigned Raw Values
*/
do {
    enum Planet: Int {
        case Mercury = 1, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune
    }
    
    //CompassPoint.South has an implicit raw value of "South", and so on.
    enum CompassPoint: String {
        case North, South, East, West
    }
    
    let earthsOrder = Planet.Earth.rawValue
    // earthsOrder is 3
    
    let sunsetDirection = CompassPoint.West.rawValue
    // sunsetDirection is "West"
}

/*:
### Initializing from a Raw Value
*/
do {
    enum Planet: Int {
        case Mercury = 1, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune
    }
    
    let possiblePlanet = Planet(rawValue: 7)
    
    let positionToFind = 11
    if let somePlanet = Planet(rawValue: positionToFind) {
        switch somePlanet {
        case .Earth:
            print("Mostly harmless")
        default:
            print("Not a safe place for humans")
        }
    } else {
        print("There isn't a planet at position \(positionToFind)")
    }
    // Prints "There isn't a planet at position 11"
}

/*:
### Recursive Enumerations
 * A recursive enumeration is an enumeration that has another instance of the enumeration as the associated value for one or more of the enumeration cases.
*/

do {
    enum ArithmeticExpression {
        case Number(Int)
        indirect case Addition(ArithmeticExpression, ArithmeticExpression)
        indirect case Multiplication(ArithmeticExpression, ArithmeticExpression)
    }
}

// You can also write indirect before the beginning of the enumeration
do {
    indirect enum ArithmeticExpression {
        case Number(Int)
        case Addition(ArithmeticExpression, ArithmeticExpression)
        case Multiplication(ArithmeticExpression, ArithmeticExpression)
    }
    
    let five = ArithmeticExpression.Number(5)
    let four = ArithmeticExpression.Number(4)
    let sum = ArithmeticExpression.Addition(five, four)
    let product = ArithmeticExpression.Multiplication(sum, ArithmeticExpression.Number(2))
    
    func evaluate(expression: ArithmeticExpression) -> Int {
        switch expression {
        case let .Number(value):
            return value
        case let .Addition(left, right):
            return evaluate(left) + evaluate(right)
        case let .Multiplication(left, right):
            return evaluate(left) * evaluate(right)
        }
    }
    
    print(evaluate(product))
    // Prints "18"
    // Wow! It's great!
}