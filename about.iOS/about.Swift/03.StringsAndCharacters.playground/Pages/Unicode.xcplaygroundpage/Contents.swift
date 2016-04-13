//: [Previous](@previous)

import UIKit

/*:
# Unicode
*/

/*:
## Unicode Scalars
 * A Unicode scalar is a unique 21-bit number for a character or modifier, such as U+0061 for LATIN SMALL LETTER A ("a"), or U+1F425 for FRONT-FACING BABY CHICK ("🐥").
*/

/*:
## Special Characters in String Literals
 * The escaped special characters \0 (null character), \\ (backslash), \t (horizontal tab), \n (line feed), \r (carriage return), \" (double quote) and \' (single quote)
 * An arbitrary Unicode scalar, written as \u{n}, where n is a 1–8 digit hexadecimal number with a value equal to a valid Unicode code point
*/

do {
    let wiseWords = "\"Imagination is more important than knowledge\" - Einstein"
    // "Imagination is more important than knowledge" - Einstein
    let dollarSign = "\u{24}"        // $,  Unicode scalar U+0024
    let blackHeart = "\u{2665}"      // ♥,  Unicode scalar U+2665
    let sparklingHeart = "\u{1F496}" // 💖, Unicode scalar U+1F496
}

/*:
## Extended Grapheme Clusters
 * 한문자의 각 모음과 자음의 Unicode scalar를 연결해서 쓰면 한 문자로 조합된다
*/

do {
    // eAcute is é, combinedEAcute is é
    let eAcute: Character = "\u{E9}"                         // é
    let combinedEAcute: Character = "\u{65}\u{301}"          // e followed by ́

    // precomposed is 한, decomposed is 한
    let precomposed: Character = "\u{D55C}"                  // 한
    let decomposed: Character = "\u{1112}\u{1161}\u{11AB}"   // ᄒ, ᅡ, ᆫ
    
    // Extended grapheme clusters enable scalars for enclosing marks (such as COMBINING ENCLOSING CIRCLE, or U+20DD) to enclose other Unicode scalars as part of a single Character value
    let enclosedEAcute: Character = "\u{E9}\u{20DD}"
    
    // Unicode scalars for regional indicator symbols can be combined in pairs to make a single Character value,
    let regionalIndicatorForUS: Character = "\u{1F1FA}\u{1F1F8}"
}

/*:
## Counting Characters
*/
do {
    let unusualMenagerie = "Koala 🐨, Snail 🐌, Penguin 🐧, Dromedary 🐪"
    print("unusualMenagerie has \(unusualMenagerie.characters.count) characters")
}

do {
    
    // Prints "the number of characters in cafe is 4"
    var word = "cafe"
    print("the number of characters in \(word) is \(word.characters.count)")
    

    word += "\u{301}"    // COMBINING ACUTE ACCENT, U+0301

    // Prints "the number of characters in café is 4"
    print("the number of characters in \(word) is \(word.characters.count)")
}

/*:
## Accessing and Modifying a String
 * Each String value has an associated index type, String.Index, which corresponds to the position of each Character in the string.
*/

/*:
### String Indices
 * Use the startIndex property to access the position of the first Character of a String. 
 * !!! The endIndex property is the position after the last character in a String.
 * As a result, the endIndex property isn’t a valid argument to a string’s subscript. 
 * If a String is empty, startIndex and endIndex are equal.
*/

do {
    let greeting = "Guten Tag!"
    
    // G
    greeting[greeting.startIndex]
    
    // !
    greeting[greeting.endIndex.predecessor()]
    
    // u
    greeting[greeting.startIndex.successor()]
    
    // a
    let index = greeting.startIndex.advancedBy(7)
    greeting[index]
    

//    greeting[greeting.endIndex] // error
//    greeting.endIndex.successor() // error
    
    // Use the indices property of the characters property to create a Range of all of the indexes
    for index in greeting.characters.indices {
        print("\(greeting[index]) ", terminator: "")
    }
}

/*:
## Inserting and Removing
*/
do {
    var welcome = "hello"
    
    // welcome now equals "hello!"
    welcome.insert("!", atIndex: welcome.endIndex)
    
    // welcome now equals "hello there!"
    welcome.insertContentsOf(" there".characters, at: welcome.endIndex.predecessor())
    
    // welcome now equals "hello there"
    welcome.removeAtIndex(welcome.endIndex.predecessor())
    welcome
    
    // !!! To remove a substring at a specified range, use the removeRange(_:) method:
    // welcome now equals "hello"
    let range = welcome.endIndex.advancedBy(-6)..<welcome.endIndex
    welcome.removeRange(range)
}

/*:
## Comparing Strings
 * String and character comparisons in Swift are not locale-sensitive.
*/

do {
    let quotation = "We're a lot alike, you and I."
    let sameQuotation = "We're a lot alike, you and I."

    if quotation == sameQuotation {
        print("These two strings are considered equal")
    }
    
    // "Voulez-vous un café?" using LATIN SMALL LETTER E WITH ACUTE
    let eAcuteQuestion = "Voulez-vous un caf\u{E9}?"
    
    // "Voulez-vous un café?" using LATIN SMALL LETTER E and COMBINING ACUTE ACCENT
    let combinedEAcuteQuestion = "Voulez-vous un caf\u{65}\u{301}?"
    
    if eAcuteQuestion == combinedEAcuteQuestion {
        print("These two strings are considered equal")
    }
    
    let latinCapitalLetterA: Character = "\u{41}"
    let cyrillicCapitalLetterA: Character = "\u{0410}"
    if latinCapitalLetterA != cyrillicCapitalLetterA {
        print("These two characters are not equivalent")
    }
}

/*:
## Prefix and Suffix Equality
 * The hasPrefix(_:) and hasSuffix(_:) methods perform a character-by-character canonical equivalence comparison between the extended grapheme clusters in each string
*/

do {
    let romeoAndJuliet = [
        "Act 1 Scene 1: Verona, A public place",
        "Act 1 Scene 2: Capulet's mansion",
        "Act 1 Scene 3: A room in Capulet's mansion",
        "Act 1 Scene 4: A street outside Capulet's mansion",
        "Act 1 Scene 5: The Great Hall in Capulet's mansion",
        "Act 2 Scene 1: Outside Capulet's mansion",
        "Act 2 Scene 2: Capulet's orchard",
        "Act 2 Scene 3: Outside Friar Lawrence's cell",
        "Act 2 Scene 4: A street in Verona",
        "Act 2 Scene 5: Capulet's mansion",
        "Act 2 Scene 6: Friar Lawrence's cell"
    ]
    
    var act1SceneCount = 0
    for scene in romeoAndJuliet {
        if scene.hasPrefix("Act 1 ") {
            act1SceneCount += 1
        }
    }
    print("There are \(act1SceneCount) scenes in Act 1")
}

do {
    let romeoAndJuliet = [
        "Act 1 Scene 1: Verona, A public place",
        "Act 1 Scene 2: Capulet's mansion",
        "Act 1 Scene 3: A room in Capulet's mansion",
        "Act 1 Scene 4: A street outside Capulet's mansion",
        "Act 1 Scene 5: The Great Hall in Capulet's mansion",
        "Act 2 Scene 1: Outside Capulet's mansion",
        "Act 2 Scene 2: Capulet's orchard",
        "Act 2 Scene 3: Outside Friar Lawrence's cell",
        "Act 2 Scene 4: A street in Verona",
        "Act 2 Scene 5: Capulet's mansion",
        "Act 2 Scene 6: Friar Lawrence's cell"
    ]
    
    var mansionCount = 0
    var cellCount = 0
    for scene in romeoAndJuliet {
        if scene.hasSuffix("Capulet's mansion") {
            mansionCount += 1
        } else if scene.hasSuffix("Friar Lawrence's cell") {
            cellCount += 1
        }
    }
    print("\(mansionCount) mansion scenes; \(cellCount) cell scenes")
}

/*:
## Unicode Representations of Strings
 * A collection of UTF-8 code units (accessed with the string’s utf8 property)
 * A collection of UTF-16 code units (accessed with the string’s utf16 property)
 * A collection of 21-bit Unicode scalar values, equivalent to the string’s UTF-32 encoding form (accessed with the string’s unicodeScalars property)
 * 정말 중요한 내용
*/

do {
    let dogString = "Dog‼🐶"
    
    let utf8 = UIImage(named: "UTF8_2x.png")
    for codeUnit in dogString.utf8 {
        print("\(codeUnit) ", terminator: "")
    }
    print("")
    
    
    let utf16 = UIImage(named: "UTF16_2x.png")
    for codeUnit in dogString.utf16 {
        print("\(codeUnit) ", terminator: "")
    }
    print("")
    
    
    let unicodeScalar = UIImage(named: "UnicodeScalar_2x.png")
    for scalar in dogString.unicodeScalars {
        print("\(scalar.value) ", terminator: "")
    }
    print("")
    
    for scalar in dogString.unicodeScalars {
        print("\(scalar) ")
    }
}

