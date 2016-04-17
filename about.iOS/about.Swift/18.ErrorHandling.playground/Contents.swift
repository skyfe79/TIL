/*:
# Error Handling
*/
import UIKit

/*:
## Representing and Throwing Errors
*/
do {
    enum VendingMachineError: ErrorType {
        case InvalidSelection
        case InsufficientFunds(coinsNeeded: Int)
        case OutOfStock
    }
    //throw VendingMachineError.InsufficientFunds(coinsNeeded: 5)
}

/*:
## Handling Errors
*/

/*:
### Propagating Errors Using Throwing Functions
*/
do {
    func canThrowErrors() throws -> String {
        return ""
    }
    
    func cannotThrowErrors() -> String {
        return ""
    }
}

do {
    
    enum VendingMachineError: ErrorType {
        case InvalidSelection
        case InsufficientFunds(coinsNeeded: Int)
        case OutOfStock
    }
    
    struct Item {
        var price: Int
        var count: Int
    }
    
    class VendingMachine {
        var inventory = [
            "Candy Bar": Item(price: 12, count: 7),
            "Chips": Item(price: 10, count: 4),
            "Pretzels": Item(price: 7, count: 11)
        ]
        var coinsDeposited = 0
        func dispenseSnack(snack: String) {
            print("Dispensing \(snack)")
        }
        
        func vend(itemNamed name: String) throws {
            guard let item = inventory[name] else {
                throw VendingMachineError.InvalidSelection
            }
            
            guard item.count > 0 else {
                throw VendingMachineError.OutOfStock
            }
            
            guard item.price <= coinsDeposited else {
                throw VendingMachineError.InsufficientFunds(coinsNeeded: item.price - coinsDeposited)
            }
            
            coinsDeposited -= item.price
            
            var newItem = item
            newItem.count -= 1
            inventory[name] = newItem
            
            dispenseSnack(name)
        }
    }
    
    let favoriteSnacks = [
        "Alice": "Chips",
        "Bob": "Licorice",
        "Eve": "Pretzels",
    ]
    
    // propagation
    func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
        let snackName = favoriteSnacks[person] ?? "Candy Bar"
        try vendingMachine.vend(itemNamed: snackName)
    }
    
    struct PurchasedSnack {
        let name: String
        // propagation
        init(name: String, vendingMachine: VendingMachine) throws {
            try vendingMachine.vend(itemNamed: name)
            self.name = name
        }
    }
    
    // 예외 처리
    var vendingMachine = VendingMachine()
    vendingMachine.coinsDeposited = 8
    do {
        try buyFavoriteSnack("Alice", vendingMachine: vendingMachine)
    } catch VendingMachineError.InvalidSelection {
        print("Invalid Selection.")
    } catch VendingMachineError.OutOfStock {
        print("Out of Stock.")
    } catch VendingMachineError.InsufficientFunds(let coinsNeeded) {
        print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
    }
    // Prints "Insufficient funds. Please insert an additional 2 coins."
}

/*:
## Converting Errors to Optional Values 
 * You use try? to handle an error by converting it to an optional value
 * If an error is thrown while evaluating the try? expression, the value of the expression is nil.
*/
do {
    func someThrowingFunction() throws -> Int {
        // ...
        return 10
    }
    
    let x = try? someThrowingFunction()
    
    // 아래의 코드를 
    let y: Int?
    do {
        y = try someThrowingFunction()
    } catch {
        y = nil
    }
    
    // 아래처럼 쓸 수 있다.
    /*
    func fetchData() -> Data? {
        if let data = try? fetchDataFromDisk() { return data }
        if let data = try? fetchDataFromServer() { return data }
        return nil
    }
    */
}

/*:
## Disabling Error Propagation
 * sometimes you know a throwing function or method won’t, in fact, throw an error at runtime. 
 * On those occasions, you can write try! before the expression to disable error propagation and wrap the call in a runtime assertion that no error will be thrown.
 * !!! If an error actually is thrown, you’ll get a runtime error.
*/
do {
    // let photo = try! loadImage("./Resources/John Appleseed.jpg")
}

/*:
## Specifying Cleanup Actions
*/
do {
    func processFile(filename: String) throws {
        if exists(filename) {
            let file = open(filename)
            defer {
                close(file)
            }
            while let line = try file.readline() {
                // Work with the file.
            }
            // close(file) is called here, at the end of the scope.
        }
    }
}

