/*:
# Initialization
*/
import UIKit

/*:
## Initializers
*/
do {
    class MyClass {
        init() {
            // perform some initialization here
        }
    }
}

do {
    struct Fahrenheit {
        var temperature: Double
        init() {
            temperature = 32.0
        }
    }
    var f = Fahrenheit()
    print("The default temperature is \(f.temperature)° Fahrenheit")
    // Prints "The default temperature is 32.0° Fahrenheit"
}

/*:
## Default Property Values
*/
do {
    struct Fahrenheit {
        var temperature = 32.0
    }
}

/*:
## Customizing Initialization
### Initialization Parameters
*/
do {
    struct Celsius {
        var temperatureInCelsius: Double
        init(fromFahrenheit fahrenheit: Double) {
            temperatureInCelsius = (fahrenheit - 32.0) / 1.8
        }
        init(fromKelvin kelvin: Double) {
            temperatureInCelsius = kelvin - 273.15
        }
    }
    let boilingPointOfWater = Celsius(fromFahrenheit: 212.0)
    // boilingPointOfWater.temperatureInCelsius is 100.0
    let freezingPointOfWater = Celsius(fromKelvin: 273.15)
    // freezingPointOfWater.temperatureInCelsius is 0.0
}

/*:
### Local and External Parameter Names
*/
do {
    struct Color {
        let red, green, blue: Double
        init(red: Double, green: Double, blue: Double) {
            self.red   = red
            self.green = green
            self.blue  = blue
        }
        init(white: Double) {
            red   = white
            green = white
            blue  = white
        }
    }
    
    let magenta = Color(red: 1.0, green: 0.0, blue: 1.0)
    let halfGray = Color(white: 0.5)
    
    // let veryGreen = Color(0.0, 1.0, 0.0)
    // this reports a compile-time error - external names are required
}

/*:
### Initializer Parameters Without External Names
*/
do {
    struct Celsius {
        var temperatureInCelsius: Double
        init(fromFahrenheit fahrenheit: Double) {
            temperatureInCelsius = (fahrenheit - 32.0) / 1.8
        }
        init(fromKelvin kelvin: Double) {
            temperatureInCelsius = kelvin - 273.15
        }
        init(_ celsius: Double) {
            temperatureInCelsius = celsius
        }
    }
    let bodyTemperature = Celsius(37.0)
    // bodyTemperature.temperatureInCelsius is 37.0
}

/*:
### Optional Property Types
*/
do {
    class SurveyQuestion {
        var text: String
        var response: String?
        init(text: String) {
            self.text = text
        }
        func ask() {
            print(text)
        }
    }
    let cheeseQuestion = SurveyQuestion(text: "Do you like cheese?")
    cheeseQuestion.ask()
    // Prints "Do you like cheese?"
    cheeseQuestion.response = "Yes, I do like cheese."
}

/*:
### Assigning Constant Properties During Initialization
*/
do {
    class SurveyQuestion {
        let text: String
        var response: String?
        init(text: String) {
            self.text = text
        }
        func ask() {
            print(text)
        }
    }
    let beetsQuestion = SurveyQuestion(text: "How about beets?")
    beetsQuestion.ask()
    // Prints "How about beets?"
    beetsQuestion.response = "I also like beets. (But not with cheese.)"
}

/*:
## Default Initializers
*/
do {
    class ShoppingListItem {
        var name: String?
        var quantity = 1
        var purchased = false
    }
    var item = ShoppingListItem()
}

/*:
### Memberwise Initializers for Structure Types
*/
do {
    struct Size {
        var width = 0.0, height = 0.0
    }
    let twoByTwo = Size(width: 2.0, height: 2.0)
}

/*:
## Initializer Delegation for Value Types
*/
do {
    struct Size {
        var width = 0.0, height = 0.0
    }
    struct Point {
        var x = 0.0, y = 0.0
    }
    
    struct Rect {
        var origin = Point()
        var size = Size()
        init() {}
        init(origin: Point, size: Size) {
            self.origin = origin
            self.size = size
        }
        init(center: Point, size: Size) {
            let originX = center.x - (size.width / 2)
            let originY = center.y - (size.height / 2)
            self.init(origin: Point(x: originX, y: originY), size: size)
        }
    }
    
    let basicRect = Rect()
    // basicRect's origin is (0.0, 0.0) and its size is (0.0, 0.0)
    
    let originRect = Rect(origin: Point(x: 2.0, y: 2.0),
        size: Size(width: 5.0, height: 5.0))
    // originRect's origin is (2.0, 2.0) and its size is (5.0, 5.0)
    
    let centerRect = Rect(center: Point(x: 4.0, y: 4.0),
        size: Size(width: 3.0, height: 3.0))
    // centerRect's origin is (2.5, 2.5) and its size is (3.0, 3.0)
}

/*:
## Class Inheritance and Initialization
### Designated Initializers and Convenience Initializers
 * Designated initializers are the primary initializers for a class.
 * A designated initializer fully initializes all properties introduced by that class and calls an appropriate superclass initializer to continue the initialization process up the superclass chain.
 * Convenience initializers are secondary, supporting initializers for a class.
 * You can define a convenience initializer to call a designated initializer from the same class as the convenience initializer with some of the designated initializer’s parameters set to default values. 
*/
do {
let img = UIImage(named: "initializerDelegation01_2x")
}

do {
let img = UIImage(named: "initializerDelegation02_2x")
}

do {
    class Vehicle {
        var numberOfWheels = 0
        var description: String {
            return "\(numberOfWheels) wheel(s)"
        }
    }
    
    let vehicle = Vehicle()
    print("Vehicle: \(vehicle.description)")
    // Vehicle: 0 wheel(s)
    
    class Bicycle: Vehicle {
        override init() {
            super.init()
            numberOfWheels = 2
        }
    }
    
    let bicycle = Bicycle()
    print("Bicycle: \(bicycle.description)")
    // Bicycle: 2 wheel(s)
}

/*:
## Designated and Convenience Initializers in Action
*/
do {
    
    class Food {
        var name: String
        init(name: String) {
            self.name = name
        }
        convenience init() {
            self.init(name: "[Unnamed]")
        }
    }
    
    let namedMeat = Food(name: "Bacon")
    // namedMeat's name is "Bacon"
    
    let mysteryMeat = Food()
    // mysteryMeat's name is "[Unnamed]"
    
    class RecipeIngredient: Food {
        var quantity: Int
        init(name: String, quantity: Int) {
            self.quantity = quantity
            super.init(name: name)
        }
        override convenience init(name: String) {
            self.init(name: name, quantity: 1)
        }
    }
    
    let oneMysteryItem = RecipeIngredient()
    let oneBacon = RecipeIngredient(name: "Bacon")
    let sixEggs = RecipeIngredient(name: "Eggs", quantity: 6)
    
    class ShoppingListItem: RecipeIngredient {
        var purchased = false
        var description: String {
            var output = "\(quantity) x \(name)"
            output += purchased ? " ✔" : " ✘"
            return output
        }
    }
    
    var breakfastList = [
        ShoppingListItem(),
        ShoppingListItem(name: "Bacon"),
        ShoppingListItem(name: "Eggs", quantity: 6),
    ]
    breakfastList[0].name = "Orange juice"
    breakfastList[0].purchased = true
    for item in breakfastList {
        print(item.description)
    }
    // 1 x Orange juice ✔
    // 1 x Bacon ✘
    // 6 x Eggs ✘
}

do {
let img = UIImage(named: "initializersExample03_2x")
}

/*:
## Failable Initializers
*/
do {
    struct Animal {
        let species: String
        init?(species: String) {
            if species.isEmpty { return nil }
            self.species = species
        }
    }
    
    let someCreature = Animal(species: "Giraffe")
    // someCreature is of type Animal?, not Animal
    
    if let giraffe = someCreature {
        print("An animal was initialized with a species of \(giraffe.species)")
    }
    // Prints "An animal was initialized with a species of Giraffe"
    
    let anonymousCreature = Animal(species: "")
    // anonymousCreature is of type Animal?, not Animal
    
    if anonymousCreature == nil {
        print("The anonymous creature could not be initialized")
    }
    // Prints "The anonymous creature could not be initialized"
}

/*:
## Failable Initializers for Enumerations
*/
do {
    enum TemperatureUnit {
        case Kelvin, Celsius, Fahrenheit
        init?(symbol: Character) {
            switch symbol {
            case "K":
                self = .Kelvin
            case "C":
                self = .Celsius
            case "F":
                self = .Fahrenheit
            default:
                return nil
            }
        }
    }
    
    let fahrenheitUnit = TemperatureUnit(symbol: "F")
    if fahrenheitUnit != nil {
        print("This is a defined temperature unit, so initialization succeeded.")
    }
    // Prints "This is a defined temperature unit, so initialization succeeded."
    
    let unknownUnit = TemperatureUnit(symbol: "X")
    if unknownUnit == nil {
        print("This is not a defined temperature unit, so initialization failed.")
    }
    // Prints "This is not a defined temperature unit, so initialization failed."
}

/*:
## Failable Initializers for Enumerations with Raw Values
*/
do {
    enum TemperatureUnit: Character {
        case Kelvin = "K", Celsius = "C", Fahrenheit = "F"
    }
    
    let fahrenheitUnit = TemperatureUnit(rawValue: "F")
    if fahrenheitUnit != nil {
        print("This is a defined temperature unit, so initialization succeeded.")
    }
    // Prints "This is a defined temperature unit, so initialization succeeded."
    
    let unknownUnit = TemperatureUnit(rawValue: "X")
    if unknownUnit == nil {
        print("This is not a defined temperature unit, so initialization failed.")
    }
    // Prints "This is not a defined temperature unit, so initialization failed."
}

/*:
## Propagation of Initialization Failure
*/
do {
    class Product {
        let name: String
        init?(name: String) {
            self.name = name
            if name.isEmpty { return nil }
        }
    }
    
    class CartItem: Product {
        let quantity: Int
        init?(name: String, quantity: Int) {
            self.quantity = quantity
            super.init(name: name)
            if quantity < 1 { return nil }
        }
    }
    
    if let twoSocks = CartItem(name: "sock", quantity: 2) {
        print("Item: \(twoSocks.name), quantity: \(twoSocks.quantity)")
    }
    // Prints "Item: sock, quantity: 2"
    
    if let zeroShirts = CartItem(name: "shirt", quantity: 0) {
        print("Item: \(zeroShirts.name), quantity: \(zeroShirts.quantity)")
    } else {
        print("Unable to initialize zero shirts")
    }
    // Prints "Unable to initialize zero shirts"
    
    if let oneUnnamed = CartItem(name: "", quantity: 1) {
        print("Item: \(oneUnnamed.name), quantity: \(oneUnnamed.quantity)")
    } else {
        print("Unable to initialize one unnamed product")
    }
    // Prints "Unable to initialize one unnamed product"
}

/*:
## Overriding a Failable Initializer
*/
do {
    class Document {
        var name: String?
        // this initializer creates a document with a nil name value
        init() {}
        // this initializer creates a document with a nonempty name value
        init?(name: String) {
            if name.isEmpty { return nil }
            self.name = name
        }
    }
    
    class AutomaticallyNamedDocument: Document {
        override init() {
            super.init()
            self.name = "[Untitled]"
        }
        override init(name: String) {
            super.init()
            if name.isEmpty {
                self.name = "[Untitled]"
            } else {
                self.name = name
            }
        }
    }
    
    class UntitledDocument: Document {
        override init() {
            super.init(name: "[Untitled]")!
        }
    }
}

/*:
## Required Initializers
 * Write the required modifier before the definition of a class initializer to indicate that every subclass of the class must implement that initializer:
*/
do {
    class SomeClass {
        required init() {
            // initializer implementation goes here
        }
    }
    
    class SomeSubclass: SomeClass {
        required init() {
            // subclass implementation of the required initializer goes here
        }
    }
}

/*:
## Setting a Default Property Value with a Closure or Function
*/
do {
    class SomeClass {
        let someProperty: Int = {
            // create a default value for someProperty inside this closure
            // someValue must be of the same type as SomeType
            return 0
        }()
    }
}

do {
    struct Chessboard {
        let boardColors: [Bool] = {
            var temporaryBoard = [Bool]()
            var isBlack = false
            for i in 1...8 {
                for j in 1...8 {
                    temporaryBoard.append(isBlack)
                    isBlack = !isBlack
                }
                isBlack = !isBlack
            }
            return temporaryBoard
        }()
        func squareIsBlackAtRow(row: Int, column: Int) -> Bool {
            return boardColors[(row * 8) + column]
        }
    }
    
    let board = Chessboard()
    print(board.squareIsBlackAtRow(0, column: 1))
    // Prints "true"
    print(board.squareIsBlackAtRow(7, column: 7))
    // Prints "false"
}