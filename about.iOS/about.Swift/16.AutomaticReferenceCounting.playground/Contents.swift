/*:
# ARC
*/
import UIKit

/*:
## ARC in Action
*/
do {
    class Person {
        let name: String
        init(name: String) {
            self.name = name
            print("\(name) is being initialized")
        }
        deinit {
            print("\(name) is being deinitialized")
        }
    }
    
    var reference1: Person?
    var reference2: Person?
    var reference3: Person?
    
    reference1 = Person(name: "John Appleseed")
    // Prints "John Appleseed is being initialized"
    
    reference2 = reference1
    reference3 = reference1
    
    reference1 = nil
    reference2 = nil
    
    // do block때문에 무조건 deinit가 호출된다.
    // do block을 지우면 reference3을 nil로 셋트할 때 deinit이 호출된다.
    reference3 = nil
    // Prints "John Appleseed is being deinitialized"
}


/*:
## Strong Reference Cycles Between Class Instances
*/
do {
    class Person {
        let name: String
        init(name: String) { self.name = name }
        var apartment: Apartment?
        deinit { print("\(name) is being deinitialized") }
    }
    
    class Apartment {
        let unit: String
        init(unit: String) { self.unit = unit }
        var tenant: Person?
        deinit { print("Apartment \(unit) is being deinitialized") }
    }
    
    var john: Person?
    var unit4A: Apartment?
    
    john = Person(name: "John Appleseed")
    unit4A = Apartment(unit: "4A")
    
    john = nil
    unit4A = nil
}

/*:
## Weak References
 * 레퍼런스 카운팅을 하지 않는 레퍼런스
*/
do {
    class Person {
        let name: String
        init(name: String) { self.name = name }
        var apartment: Apartment?
        deinit { print("\(name) is being deinitialized") }
    }
    
    class Apartment {
        let unit: String
        init(unit: String) { self.unit = unit }
        weak var tenant: Person?
        deinit { print("Apartment \(unit) is being deinitialized") }
    }
    
    var john: Person?
    var unit4A: Apartment?
    
    john = Person(name: "John Appleseed")
    unit4A = Apartment(unit: "4A")
    
    john!.apartment = unit4A
    unit4A!.tenant = john
    
    john = nil
    // Prints "John Appleseed is being deinitialized"
    unit4A = nil
    // Prints "Apartment 4A is being deinitialized"
}

/*:
## Unowned References
 * Like weak references, an unowned reference does not keep a strong hold on the instance it refers to.
 * Unlike a weak reference, however, an unowned reference is assumed to always have a value.
*/
do {
    class Customer {
        let name: String
        var card: CreditCard?
        init(name: String) {
            self.name = name
        }
        deinit { print("\(name) is being deinitialized") }
    }
    
    class CreditCard {
        let number: UInt64
        unowned let customer: Customer
        init(number: UInt64, customer: Customer) {
            self.number = number
            self.customer = customer
        }
        deinit { print("Card #\(number) is being deinitialized") }
    }
    
    var john: Customer?
    john = Customer(name: "John Appleseed")
    john!.card = CreditCard(number: 1234_5678_9012_3456, customer: john!)
    
    john = nil
    // Prints "John Appleseed is being deinitialized"
    // Prints "Card #1234567890123456 is being deinitialized"
    //Because there are no more strong references to the Customer instance, it is deallocated. After this happens, there are no more strong references to the CreditCard instance, and it too is deallocated:
}

/*:
## Unowned References and Implicitly Unwrapped Optional Properties
*/
do {
    class Country {
        let name: String
        var capitalCity: City!
        init(name: String, capitalName: String) {
            self.name = name
            self.capitalCity = City(name: capitalName, country: self)
        }
    }
    
    class City {
        let name: String
        unowned let country: Country
        init(name: String, country: Country) {
            self.name = name
            self.country = country
        }
    }
    
    var country = Country(name: "Canada", capitalName: "Ottawa")
    print("\(country.name)'s capital city is called \(country.capitalCity.name)")
    // Prints "Canada's capital city is called Ottawa"
}

/*:
## Strong Reference Cycles for Closures
*/
do {
    class HTMLElement {
        
        let name: String
        let text: String?
        
        lazy var asHTML: () -> String = { [unowned self] in
            if let text = self.text {
                return "<\(self.name)>\(text)</\(self.name)>"
            } else {
                return "<\(self.name) />"
            }
        }
        
        init(name: String, text: String? = nil) {
            self.name = name
            self.text = text
        }
        
        deinit {
            print("\(name) is being deinitialized")
        }
        
    }
    
    let heading = HTMLElement(name: "h1")
    let defaultText = "some default text"
    heading.asHTML = {
        return "<\(heading.name)>\(heading.text ?? defaultText)</\(heading.name)>"
    }
    print(heading.asHTML())
    // Prints "<h1>some default text</h1>"
    
    var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
    print(paragraph!.asHTML())
    // Prints "<p>hello, world</p>"
    
    paragraph = nil
}

/*:
## Resolving Strong Reference Cycles for Closures
*/
do {
    // Defining a Capture List
    /*
    class Some {
        lazy var someClosure: (Int, String) -> String = {
            [unowned self, weak delegate = self.delegate!] (index: Int, stringToProcess: String) -> String in
            // closure body goes here
        }
    
        lazy var someClosure: () -> String = {
        [unowned self, weak delegate = self.delegate!] in
        // closure body goes here
        }

    }
    
    
    */
}

/*:
## Weak and Unowned References
*/
do {
    class HTMLElement {
        
        let name: String
        let text: String?
        
        lazy var asHTML: () -> String = {
            [unowned self] in
            if let text = self.text {
                return "<\(self.name)>\(text)</\(self.name)>"
            } else {
                return "<\(self.name) />"
            }
        }
        
        init(name: String, text: String? = nil) {
            self.name = name
            self.text = text
        }
        
        deinit {
            print("\(name) is being deinitialized")
        }
        
    }
    
    var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
    print(paragraph!.asHTML())
    // Prints "<p>hello, world</p>"
    
    paragraph = nil
    // Prints "p is being deinitialized"
}