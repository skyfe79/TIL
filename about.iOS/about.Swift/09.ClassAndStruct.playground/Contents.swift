/*:
# Classes and Structures
*/
import UIKit

/*:
## Comparing Classes and Structures

Classes and structures in Swift have many things in common. Both can:

 * Define properties to store values
 * Define methods to provide functionality
 * Define subscripts to provide access to their values using subscript syntax
 * Define initializers to set up their initial state
 * Be extended to expand their functionality beyond a default implementation
 * Conform to protocols to provide standard functionality of a certain kind

Classes have additional capabilities that structures do not:

 * Inheritance enables one class to inherit the characteristics of another.
 * Type casting enables you to check and interpret the type of a class instance at runtime.
 * Deinitializers enable an instance of a class to free up any resources it has assigned.
 * Reference counting allows more than one reference to a class instance.
*/

/*:
## Definition Syntax
*/

do {
    class SomeClass {
        // class definition goes here
    }
    struct SomeStructure {
        // structure definition goes here
    }
}

do {
    struct Resolution {
        var width = 0
        var height = 0
    }
    
    class VideoMode {
        var resolution = Resolution()
        var interlaced = false
        var frameRate = 0.0
        var name: String?
    }
}

/*:
### Class and Structure Instances
*/
do {
    struct Resolution {
        var width = 0
        var height = 0
    }
    
    class VideoMode {
        var resolution = Resolution()
        var interlaced = false
        var frameRate = 0.0
        var name: String?
    }
    
    let someResolution = Resolution()
    let someVideoMode = VideoMode()
}

/*:
### Accessing Properties
*/
do {
    struct Resolution {
        var width = 0
        var height = 0
    }
    
    class VideoMode {
        var resolution = Resolution()
        var interlaced = false
        var frameRate = 0.0
        var name: String?
    }
    
    let someResolution = Resolution()
    let someVideoMode = VideoMode()
    
    print("The width of someResolution is \(someResolution.width)")
    print("The width of someVideoMode is \(someVideoMode.resolution.width)")
    
    
    //Unlike Objective-C, Swift enables you to set sub-properties of a structure property directly. In the last example above, the width property of the resolution property of someVideoMode is set directly, without your needing to set the entire resolution property to a new value.
    
    someVideoMode.resolution.width = 1280
    print("The width of someVideoMode is now \(someVideoMode.resolution.width)")
}

/*:
### Memberwise Initializers for Structure Types
*/

do {
    struct Resolution {
        var width = 0
        var height = 0
    }
    
    let vga = Resolution(width: 640, height: 480)
    print("The width of vga is \(vga.width)")
}

/*:
## Structures and Enumerations Are Value Types
*/
do {
    struct Resolution {
        var width = 0
        var height = 0
    }
    
    let hd = Resolution(width: 1920, height: 1080)
    var cinema = hd //copied
    cinema.width = 2048
    
    print("cinema is now \(cinema.width) pixels wide")
    // Prints "cinema is now 2048 pixels wide"
    
    
    print("hd is still \(hd.width) pixels wide")
    // Prints "hd is still 1920 pixels wide"
}

do {
    enum CompassPoint {
        case North, South, East, West
    }
    var currentDirection = CompassPoint.West
    let rememberedDirection = currentDirection
    currentDirection = .East
    if rememberedDirection == .West {
        print("The remembered direction is still .West")
    }
    // Prints "The remembered direction is still .West"
}

/*:
## Classes Are Reference Types
*/
do {
    struct Resolution {
        var width = 0
        var height = 0
    }
    
    class VideoMode {
        var resolution = Resolution()
        var interlaced = false
        var frameRate = 0.0
        var name: String?
    }
    
    let hd = Resolution(width: 1920, height: 1080)

    let tenEighty = VideoMode()
    tenEighty.resolution = hd
    tenEighty.interlaced = true
    tenEighty.name = "1080i"
    tenEighty.frameRate = 25.0
    
    let alsoTenEighty = tenEighty
    alsoTenEighty.frameRate = 30.0
    
    print("The frameRate property of tenEighty is now \(tenEighty.frameRate)")
    // Prints "The frameRate property of tenEighty is now 30.0"
}

/*:
### Identity Operators
 * Identical to (===)
 * Not identical to (!==)
*/
do {
    struct Resolution {
        var width = 0
        var height = 0
    }
    
    class VideoMode {
        var resolution = Resolution()
        var interlaced = false
        var frameRate = 0.0
        var name: String?
    }
    
    let hd = Resolution(width: 1920, height: 1080)
    
    let tenEighty = VideoMode()
    tenEighty.resolution = hd
    tenEighty.interlaced = true
    tenEighty.name = "1080i"
    tenEighty.frameRate = 25.0
    
    let alsoTenEighty = tenEighty
    alsoTenEighty.frameRate = 30.0
    
    print("The frameRate property of tenEighty is now \(tenEighty.frameRate)")
    // Prints "The frameRate property of tenEighty is now 30.0"
    
    if tenEighty === alsoTenEighty {
        print("tenEighty and alsoTenEighty refer to the same VideoMode instance.")
    }
}

/*:
### Pointers

If you have experience with C, C++, or Objective-C, you may know that these languages use pointers to refer to addresses in memory. A Swift constant or variable that refers to an instance of some reference type is similar to a pointer in C, but is not a direct pointer to an address in memory, and does not require you to write an asterisk (*) to indicate that you are creating a reference. Instead, these references are defined like any other constant or variable in Swift.
*/

/*:
## Choosing Between Classes and Structures

As a general guideline, consider creating a structure when one or more of these conditions apply:

 * The structure’s primary purpose is to encapsulate a few relatively simple data values.
 * It is reasonable to expect that the encapsulated values will be copied rather than referenced when you assign or pass around an instance of that structure.
 * Any properties stored by the structure are themselves value types, which would also be expected to be copied rather than referenced.
 * The structure does not need to inherit properties or behavior from another existing type.
*/


/*:
## Assignment and Copy Behavior for Strings, Arrays, and Dictionaries

In Swift, many basic data types such as String, Array, and Dictionary are implemented as structures. This means that data such as strings, arrays, and dictionaries are copied when they are assigned to a new constant or variable, or when they are passed to a function or method.

This behavior is different from Foundation: NSString, NSArray, and NSDictionary are implemented as classes, not structures. Strings, arrays, and dictionaries in Foundation are always assigned and passed around as a reference to an existing instance, rather than as a copy.

!!! The description above refers to the “copying” of strings, arrays, and dictionaries. The behavior you see in your code will always be as if a copy took place. However, Swift only performs an actual copy behind the scenes when it is absolutely necessary to do so. Swift manages all value copying to ensure optimal performance, and you should not avoid assignment to try to preempt this optimization.
*/
