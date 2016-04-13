/*:
# Collection Types
*/

import UIKit

/*:
## Arrays
*/

/*:
### Array Type Shorthand Syntax
*/
do {
    let a = Array<Int>()
    let b = [Int]()
}

/*:
### Creating an Empty Array
*/
do {
    var someInts = [Int]()
    print("someInts is of type [Int] with \(someInts.count) items.")
    
    someInts.append(3)
    
    someInts = []
}

/*:
### Creating an Array with a Default Value
*/
do {
    var threeDoubles = [Double](count: 3, repeatedValue: 0.0)
}

/*:
### Creating an Array by Adding Two Arrays Together
*/
do {
    var a = [Double](count: 3, repeatedValue: 0.0)
    var b = [Double](count: 3, repeatedValue: 2.5)
    var c = a + b
}

/*:
### Creating an Array with an Array Literal
*/
do {
    var shoppingList: [String] = ["Eggs", "Milk"]
    var sameShoppingList = ["Eggs", "Milk"]
}


/*:
### Accessing and Modifying an Array
*/
do {
    var shoppingList: [String] = ["Eggs", "Milk"]
    print("The shopping list contains \(shoppingList.count) items")
    
    if shoppingList.isEmpty {
        print("The shopping list is empty.")
    } else {
        print("The shopping list is not empty.")
    }
    
    // append
    shoppingList.append("Flour")
    shoppingList += ["Baking Powder"]
    shoppingList += ["Chocolate Spread", "Cheese", "Butter"]
    
    // accessing
    var firstItem = shoppingList[0]
    shoppingList[0] = "Six eggs"
    shoppingList[4...6] = ["Bananas", "Apples"]
    shoppingList
    
    // insert
    shoppingList.insert("Maple Syrup", atIndex: 0)
    
    // remove
    let mapleSyrup = shoppingList.removeAtIndex(0)
    
    firstItem = shoppingList[0]
    
    let apples = shoppingList.removeLast()
}

/*:
### Iterating Over an Array
*/
do {
    
    var shoppingList: [String] = ["Eggs", "Milk", "Baking Powder"]
    for item in shoppingList {
        print(item)
    }
    
    
    // 인덱스가 필요할 경우
    for (index, value) in shoppingList.enumerate() {
        print("Item \(index + 1): \(value)")
    }
}


//: [Next](@next)
