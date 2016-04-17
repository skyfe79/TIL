/*:
# Advanced Operators
*/
import UIKit

/*:
## Bitwise Operators
 * ~ : Bitwise NOT Operator
 * & : AND
 * | : OR
 * ^ : XOR
 * <<
 * >>
*/
do {
    let initialBits: UInt8 = 0b00001111
    let invertedBits = ~initialBits  // equals 11110000
}

do {
    let firstSixBits: UInt8 = 0b11111100
    let lastSixBits: UInt8  = 0b00111111
    let middleFourBits = firstSixBits & lastSixBits  // equals 00111100
}

do {
    let someBits: UInt8 = 0b10110010
    let moreBits: UInt8 = 0b01011110
    let combinedbits = someBits | moreBits  // equals 11111110

}

do {
    let firstBits: UInt8 = 0b00010100
    let otherBits: UInt8 = 0b00000101
    let outputBits = firstBits ^ otherBits  // equals 00010001

}

do {
    let shiftBits: UInt8 = 4   // 00000100 in binary
    shiftBits << 1             // 00001000
    shiftBits << 2             // 00010000
    shiftBits << 5             // 10000000
    shiftBits << 6             // 00000000
    shiftBits >> 2             // 00000001
}

do {
    let pink: UInt32 = 0xCC6699
    let redComponent = (pink & 0xFF0000) >> 16    // redComponent is 0xCC, or 204
    let greenComponent = (pink & 0x00FF00) >> 8   // greenComponent is 0x66, or 102
    let blueComponent = pink & 0x0000FF           // blueComponent is 0x99, or 153
}


/*:
## 오버플로우 연산자가 있다!
 * Overflow addition (&+)
 * Overflow subtraction (&-)
 * Overflow multiplication (&*)
*/
do {
    var unsignedOverflow = UInt8.max
    // unsignedOverflow equals 255, which is the maximum value a UInt8 can hold
    unsignedOverflow = unsignedOverflow &+ 1
    // unsignedOverflow is now equal to 0
}

do {
    var unsignedOverflow = UInt8.min
    // unsignedOverflow equals 0, which is the minimum value a UInt8 can hold
    unsignedOverflow = unsignedOverflow &- 1
    // unsignedOverflow is now equal to 255
}

do {
    var signedOverflow = Int8.min
    // signedOverflow equals -128, which is the minimum value an Int8 can hold
    signedOverflow = signedOverflow &- 1
    // signedOverflow is now equal to 127
}

2 + 3 % 4 * 5
2 + ((3 % 4) * 5)

/*:
## Operator Functions
!!! 중요
*/
struct Vector2D {
    var x = 0.0, y = 0.0
}

// infix
func + (left: Vector2D, right: Vector2D) -> Vector2D {
    return Vector2D(x: left.x + right.x, y: left.y + right.y)
}

let vector = Vector2D(x: 3.0, y: 1.0)
let anotherVector = Vector2D(x: 2.0, y: 4.0)
let combinedVector = vector + anotherVector
// combinedVector is a Vector2D instance with values of (5.0, 5.0)


/*:
## Prefix and Postfix Operators
*/
prefix func - (vector: Vector2D) -> Vector2D {
    return Vector2D(x: -vector.x, y: -vector.y)
}

let positive = Vector2D(x: 3.0, y: 4.0)
let negative = -positive
// negative is a Vector2D instance with values of (-3.0, -4.0)
let alsoPositive = -negative
// alsoPositive is a Vector2D instance with values of (3.0, 4.0)

/*:
## Compound Assignment Operators
*/
func += (inout left: Vector2D, right: Vector2D) {
    left = left + right
}
var original = Vector2D(x: 1.0, y: 2.0)
let vectorToAdd = Vector2D(x: 3.0, y: 4.0)
original += vectorToAdd
// original now has values of (4.0, 6.0)

/*:
## Equivalence Operators
*/
func == (left: Vector2D, right: Vector2D) -> Bool {
    return (left.x == right.x) && (left.y == right.y)
}
func != (left: Vector2D, right: Vector2D) -> Bool {
    return !(left == right)
}
let twoThree = Vector2D(x: 2.0, y: 3.0)
let anotherTwoThree = Vector2D(x: 2.0, y: 3.0)
if twoThree == anotherTwoThree {
    print("These two vectors are equivalent.")
}
// Prints "These two vectors are equivalent."


/*:
## Custom Operators
 * New operators are declared at a global level using the operator keyword, and are marked with the prefix, infix or postfix modifiers:
*/
prefix operator +++ {}
prefix func +++ (inout vector: Vector2D) -> Vector2D {
    vector += vector
    return vector
}

var toBeDoubled = Vector2D(x: 1.0, y: 4.0)
let afterDoubling = +++toBeDoubled
// toBeDoubled now has values of (2.0, 8.0)
// afterDoubling also has values of (2.0, 8.0)

/*:
## Precedence and Associativity for Custom Infix Operators
 * 커스텀 infix는 연산자 우선순위도 고려해야 한다
 * 커스텀 infix는 왼결합인지 우결합인지 고려해야 한다.
 * https://developer.apple.com/library/ios/documentation/Swift/Reference/Swift_StandardLibrary_Operators/index.html#//apple_ref/doc/uid/TP40016054 
 * 위 링크를 참고하여 연산자의 왼/우결합과 우선순위를 결정한다.
*/
infix operator +- { associativity left precedence 140 }
func +- (left: Vector2D, right: Vector2D) -> Vector2D {
    return Vector2D(x: left.x + right.x, y: left.y - right.y)
}
let firstVector = Vector2D(x: 1.0, y: 2.0)
let secondVector = Vector2D(x: 3.0, y: 4.0)
let plusMinusVector = firstVector +- secondVector
// plusMinusVector is a Vector2D instance with values of (4.0, -2.0)