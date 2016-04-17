/*:
# Access Control
*/
import UIKit

/*:
## Modules and Source Files
 * A module is a single unit of code distribution - a framework or application that is built and shipped as a single unit and that can be imported by another module with Swift’s import keyword.
 * A source file is a single Swift source code file within a module
*/

/*:
## Access Levels
 * 'Public' access enables entities to be used within any source file from their defining module, and also in a source file from another module that imports the defining module.
  * 서로 다른 모듈과 모듈간에도 파일간 참조 가능
 * 'Internal' access enables entities to be used within any source file from their defining module, but not in any source file outside of that module.
  * 한 모듈에서만 파일간 참조 가능
 * 'Private' access restricts the use of an entity to its own defining source file.
  * 한 모듈, 한 파일에서만 사용 가능
*/

/*:
## Guiding Principle of Access Levels
 * A public variable cannot be defined as having an internal or private type, because the type might not be available everywhere that the public variable is used.
 * !!! A function cannot have a higher access level than its parameter types and return type, because the function could be used in situations where its constituent types are not available to the surrounding code.
*/

/*:
## Default Access Levels == internal
*/
public class SomePublicClass {          // explicitly public class
    public var somePublicProperty = 0    // explicitly public class member
    var someInternalProperty = 0         // implicitly internal class member
    private func somePrivateMethod() {}  // explicitly private class member
}

class SomeInternalClass {               // implicitly internal class
    var someInternalProperty = 0         // implicitly internal class member
    private func somePrivateMethod() {}  // explicitly private class member
}

private class SomePrivateClass {        // explicitly private class
    var somePrivateProperty = 0          // implicitly private class member
    func somePrivateMethod() {}          // implicitly private class member
}

//An override can make an inherited class member more accessible than its superclass version.
public class AA {
    private func someMethod() {}
}

internal class BB: AA {
    override internal func someMethod() {}
}

//It is even valid for a subclass member to call a superclass member that has lower access permissions than the subclass member,
public class A {
    private func someMethod() {}
}

internal class B: A {
    override internal func someMethod() {
        super.someMethod()
    }
}

/*:
## Getter and Setter
 * You can give a setter a lower access level than its corresponding getter, to restrict the read-write scope of that variable, property, or subscript.
 * You assign a lower access level by writing private(set) or internal(set) before the var or subscript introducer.
*/
struct TrackedString {
    private(set) var numberOfEdits = 0
    var value: String = "" {
        didSet {
            numberOfEdits += 1
        }
    }
}

var stringToEdit = TrackedString()
stringToEdit.value = "This string will be tracked."
stringToEdit.value += " This edit will increment numberOfEdits."
stringToEdit.value += " So will this one."
print("The number of edits is \(stringToEdit.numberOfEdits)")
// Prints "The number of edits is 3"

public struct TrackedString2 {
    public private(set) var numberOfEdits = 0
    public var value: String = "" {
        didSet {
            numberOfEdits += 1
        }
    }
    public init() {}
}




