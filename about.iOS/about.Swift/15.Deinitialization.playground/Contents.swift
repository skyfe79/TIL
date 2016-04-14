/*:
# Deinitialization
 * 컴퓨터의 자원이 유한하기 때문에 이 모든 것이 필요한 것이다.
*/
import UIKit

/*:
## How Deinitialization Works
*/
do {
    class SomeClass {
        deinit {
            // perform the deinitialization
        }
    }
}

/*:
## Deinitializers in Action
*/
do {
    class Bank {
        static var coinsInBank = 10_000
        static func vendCoins(numberOfCoinsRequested: Int) -> Int {
            let numberOfCoinsToVend = min(numberOfCoinsRequested, coinsInBank)
            coinsInBank -= numberOfCoinsToVend
            return numberOfCoinsToVend
        }
        static func receiveCoins(coins: Int) {
            coinsInBank += coins
        }
    }
    
    class Player {
        var coinsInPurse: Int
        init(coins: Int) {
            coinsInPurse = Bank.vendCoins(coins)
        }
        func winCoins(coins: Int) {
            coinsInPurse += Bank.vendCoins(coins)
        }
        deinit {
            Bank.receiveCoins(coinsInPurse)
        }
    }
    
    var playerOne: Player? = Player(coins: 100)
    print("A new player has joined the game with \(playerOne!.coinsInPurse) coins")
    // Prints "A new player has joined the game with 100 coins"
    print("There are now \(Bank.coinsInBank) coins left in the bank")
    // Prints "There are now 9900 coins left in the bank"
    
    playerOne!.winCoins(2_000)
    print("PlayerOne won 2000 coins & now has \(playerOne!.coinsInPurse) coins")
    // Prints "PlayerOne won 2000 coins & now has 2100 coins"
    print("The bank now only has \(Bank.coinsInBank) coins left")
    // Prints "The bank now only has 7900 coins left"
    
    playerOne = nil
    print("PlayerOne has left the game")
    // Prints "PlayerOne has left the game"
    print("The bank now has \(Bank.coinsInBank) coins")
    // Prints "The bank now has 10000 coins"
}