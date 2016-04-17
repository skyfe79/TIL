/*:
# Methods
*/
import UIKit

/*:
## Instance Methods
*/
do {
    class Counter {
        var count = 0
        func increment() {
            count += 1
        }
        func incrementBy(amount: Int) {
            count += amount
        }
        func reset() {
            count = 0
        }
    }
    
    let counter = Counter()
    // the initial counter value is 0
    counter.increment()
    // the counter's value is now 1
    counter.incrementBy(5)
    // the counter's value is now 6
    counter.reset()
    // the counter's value is now 0
}

/*:
### Local and External Parameter Names for Methods
*/
do {
    class Counter {
        var count: Int = 0
        func incrementBy(amount: Int, numberOfTimes: Int) {
            count += amount * numberOfTimes
        }
    }
    
    let counter = Counter()
    counter.incrementBy(5, numberOfTimes: 3)
    // counter value is now 15
}

/*:
### The self Property
*/
do {
    class Counter {
        var count = 0
        func increment() {
            self.count += 1
        }
        func incrementBy(amount: Int) {
            count += amount
        }
        func reset() {
            count = 0
        }
    }
}

do {
    struct Point {
        var x = 0.0, y = 0.0
        func isToTheRightOfX(x: Double) -> Bool {
            return self.x > x
        }
    }
    let somePoint = Point(x: 4.0, y: 5.0)
    if somePoint.isToTheRightOfX(1.0) {
        print("This point is to the right of the line where x == 1.0")
    }
    // Prints "This point is to the right of the line where x == 1.0"
}

/*:
### Modifying Value Types from Within Instance Methods
*/
do {
    struct Point {
        var x = 0.0, y = 0.0
        mutating func moveByX(deltaX: Double, y deltaY: Double) {
            x += deltaX
            y += deltaY
        }
    }
    var somePoint = Point(x: 1.0, y: 1.0)
    somePoint.moveByX(2.0, y: 3.0)
    print("The point is now at (\(somePoint.x), \(somePoint.y))")
    // Prints "The point is now at (3.0, 4.0)"
    
    // error
//    let fixedPoint = Point(x: 3.0, y: 3.0)
//    fixedPoint.moveByX(2.0, y: 3.0)
    // this will report an error
}

/*:
### Assigning to self Within a Mutating Method
 * Mutating methods can assign an entirely new instance to the implicit self property.
*/
do {
    struct Point {
        var x = 0.0, y = 0.0
        mutating func moveByX(deltaX: Double, y deltaY: Double) {
            self = Point(x: x + deltaX, y: y + deltaY)
        }
    }
}

do {
    enum TriStateSwitch {
        case Off, Low, High
        mutating func next() {
            switch self {
            case Off:
                self = Low
            case Low:
                self = High
            case High:
                self = Off
            }
        }
    }
    var ovenLight = TriStateSwitch.Low
    ovenLight.next()
    // ovenLight is now equal to .High
    ovenLight.next()
    // ovenLight is now equal to .Off
}

/*:
## Type(Class) Methods
*/
do {
    class SomeClass {
        class func someTypeMethod() {
            // type method implementation goes here
        }
    }
    SomeClass.someTypeMethod()
}

do {
    struct LevelTracker {
        static var highestUnlockedLevel = 1
        static func unlockLevel(level: Int) {
            if level > highestUnlockedLevel { highestUnlockedLevel = level }
        }
        static func levelIsUnlocked(level: Int) -> Bool {
            return level <= highestUnlockedLevel
        }
        var currentLevel = 1
        mutating func advanceToLevel(level: Int) -> Bool {
            if LevelTracker.levelIsUnlocked(level) {
                currentLevel = level
                return true
            } else {
                return false
            }
        }
    }
    
    class Player {
        var tracker = LevelTracker()
        let playerName: String
        func completedLevel(level: Int) {
            LevelTracker.unlockLevel(level + 1)
            tracker.advanceToLevel(level + 1)
        }
        init(name: String) {
            playerName = name
        }
    }
    
    var player = Player(name: "Argyrios")
    player.completedLevel(1)
    print("highest unlocked level is now \(LevelTracker.highestUnlockedLevel)")
    // Prints "highest unlocked level is now 2"
    
    player = Player(name: "Beto")
    if player.tracker.advanceToLevel(6) {
        print("player is now on level 6")
    } else {
        print("level 6 has not yet been unlocked")
    }
    // Prints "level 6 has not yet been unlocked"
}

