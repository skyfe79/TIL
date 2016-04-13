//: [Previous](@previous)
/*:
## Set
*/
import UIKit

/*:
### Hash Values for Set Types
 * A type must be hashable in order to be stored in a set
 * A hash value is an Int value that is the same for all objects that compare equally, such that if a == b, it follows that a.hashValue == b.hashValue.
*/

/*:
### Set Type Syntax
*/

do {
    let a = Set<Int>()
}

/*:
### Creating and Initializing an Empty Set
*/
do {
    var letters = Set<Character>()
    print("letters is of type Set<Character> with \(letters.count) items.")
    
    letters.insert("a")
    letters = []
}

/*:
### Creating a Set with an Array Literal
*/
do {
    var favoriteGenres: Set<String> = ["Rock", "Classical", "Hip hop"]
    
    var sameFavoriteGenres: Set = ["Rock", "Classical", "Hip hop"]
}

/*:
### Accessing and Modifying a Set
*/
do {
    var favoriteGenres: Set<String> = ["Rock", "Classical", "Hip hop"]
    print("I have \(favoriteGenres.count) favorite music genres.")
    
    if favoriteGenres.isEmpty {
        print("As far as music goes, I'm not picky.")
    } else {
        print("I have particular music preferences.")
    }
    
    favoriteGenres.insert("Jazz")
    
    if let removedGenre = favoriteGenres.remove("Rock") {
        print("\(removedGenre)? I'm over it.")
    } else {
        print("I never much cared for that.")
    }
    
    
    if favoriteGenres.contains("Funk") {
        print("I get up on the good foot.")
    } else {
        print("It's too funky in here.")
    }
}

/*:
### Iterating Over a Set
*/
do {
    var favoriteGenres: Set<String> = ["Rock", "Classical", "Hip hop"]
    for genre in favoriteGenres {
        print("\(genre)")
    }
}

/*:
### Performing Set Operations
 * intersect
 * exclusiveOr
 * union
 * subtract
*/

do {
    let oddDigits: Set = [1, 3, 5, 7, 9]
    let evenDigits: Set = [0, 2, 4, 6, 8]
    let singleDigitPrimeNumbers: Set = [2, 3, 5, 7]
    
    oddDigits.union(evenDigits).sort()
    
    oddDigits.intersect(evenDigits).sort()
    
    oddDigits.subtract(singleDigitPrimeNumbers).sort()
    
    oddDigits.exclusiveOr(singleDigitPrimeNumbers).sort()
}

/*:
### Set Membership and Equality
 * isDisjointWith method to determine whether two sets have any values in common.
*/

do {
    let houseAnimals: Set = ["🐶", "🐱"]
    let farmAnimals: Set = ["🐮", "🐔", "🐑", "🐶", "🐱"]
    let cityAnimals: Set = ["🐦", "🐭"]
    
    houseAnimals.isSubsetOf(farmAnimals)
    farmAnimals.isSupersetOf(houseAnimals)
    farmAnimals.isDisjointWith(cityAnimals)
}

//: [Next](@next)
