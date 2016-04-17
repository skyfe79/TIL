/*:
# Inheritance
*/
import UIKit

/*:
## Defining a Base Class
*/
do {
    class Vehicle {
        var currentSpeed = 0.0
        var description: String {
            return "traveling at \(currentSpeed) miles per hour"
        }
        func makeNoise() {
            // do nothing - an arbitrary vehicle doesn't necessarily make a noise
        }
    }
    
    let someVehicle = Vehicle()
    print("Vehicle: \(someVehicle.description)")
    // Vehicle: traveling at 0.0 miles per hour
}

/*:
## Subclassing
*/
do {
    class SomeSuperclass {
        
    }
    class SomeSubclass: SomeSuperclass {
        // subclass definition goes here
    }
    
    class Vehicle {
        var currentSpeed = 0.0
        var description: String {
            return "traveling at \(currentSpeed) miles per hour"
        }
        func makeNoise() {
            // do nothing - an arbitrary vehicle doesn't necessarily make a noise
        }
    }
    
    class Bicycle: Vehicle {
        var hasBasket = false
    }
    
    let bicycle = Bicycle()
    bicycle.hasBasket = true

    bicycle.currentSpeed = 15.0
    print("Bicycle: \(bicycle.description)")
    // Bicycle: traveling at 15.0 miles per hour
    
    class Tandem: Bicycle {
        var currentNumberOfPassengers = 0
    }

    let tandem = Tandem()
    tandem.hasBasket = true
    tandem.currentNumberOfPassengers = 2
    tandem.currentSpeed = 22.0
    print("Tandem: \(tandem.description)")
    // Tandem: traveling at 22.0 miles per hour

}

/*:
## Overriding
 * Overriding Methods
 * Overriding Properties
 * Overriding Subscription
*/

/*:
###  Overriding Methods
*/
do {
    class Vehicle {
        var currentSpeed = 0.0
        var description: String {
            return "traveling at \(currentSpeed) miles per hour"
        }
        func makeNoise() {
            // do nothing - an arbitrary vehicle doesn't necessarily make a noise
        }
    }
    
    class Train: Vehicle {
        override func makeNoise() {
            print("Choo Choo")
        }
    }
    
    let train = Train()
    train.makeNoise()
    // Prints "Choo Choo"
}


/*:
### Overriding Properties
*/
do {
    class Vehicle {
        var currentSpeed = 0.0
        var description: String {
            return "traveling at \(currentSpeed) miles per hour"
        }
        func makeNoise() {
            // do nothing - an arbitrary vehicle doesn't necessarily make a noise
        }
    }
    
    class Car: Vehicle {
        var gear = 1
        override var description: String {
            return super.description + " in gear \(gear)"
        }
    }
    
    let car = Car()
    car.currentSpeed = 25.0
    car.gear = 3
    print("Car: \(car.description)")
    // Car: traveling at 25.0 miles per hour in gear 3

    
    //Overriding Property Observers
    class AutomaticCar: Car {
        override var currentSpeed: Double {
            didSet {
                gear = Int(currentSpeed / 10.0) + 1
            }
        }
    }
    
    let automatic = AutomaticCar()
    automatic.currentSpeed = 35.0
    print("AutomaticCar: \(automatic.description)")
    // AutomaticCar: traveling at 35.0 miles per hour in gear 4
}

/*:
## Preventing Overrides
 * final var
 * final func
 * final class func
 * final subscript
 * final class
*/
do {
    
}