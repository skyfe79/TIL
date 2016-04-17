/*:
# Subscripts
*/
import UIKit

/*:
## Subscript Syntax
*/
do {
    
    class ReadWriteSubscript {
        subscript(index: Int) -> Int {
            get {
                // return an appropriate subscript value here
                return index
            }
            set(newValue) {
                // perform a suitable setting action here
            }
        }
    }
    
    class ReadOnlySubscript {
        subscript(index: Int) -> Int {
            // return an appropriate subscript value here
            return index
        }
    }
}

do {
    struct TimesTable {
        let multiplier: Int
        subscript(index: Int) -> Int {
            return multiplier * index
        }
    }
    let threeTimesTable = TimesTable(multiplier: 3)
    print("six times three is \(threeTimesTable[6])")
    // Prints "six times three is 18"
}

/*:
## Subscript Usage
*/
do {
    var numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
    numberOfLegs["bird"] = 2
}

/*:
## Subscript Options
*/
do {
    struct Matrix {
        let rows: Int, columns: Int
        var grid: [Double]
        init(rows: Int, columns: Int) {
            self.rows = rows
            self.columns = columns
            grid = Array(count: rows * columns, repeatedValue: 0.0)
        }
        func indexIsValidForRow(row: Int, column: Int) -> Bool {
            return row >= 0 && row < rows && column >= 0 && column < columns
        }
        subscript(row: Int, column: Int) -> Double {
            get {
                assert(indexIsValidForRow(row, column: column), "Index out of range")
                return grid[(row * columns) + column]
            }
            set {
                assert(indexIsValidForRow(row, column: column), "Index out of range")
                grid[(row * columns) + column] = newValue
            }
        }
    }
    
    var matrix = Matrix(rows: 2, columns: 2)
    matrix[0, 1] = 1.5
    matrix[1, 0] = 3.2
    
    let someValue = matrix[2, 2]
    // this triggers an assert, because [2, 2] is outside of the matrix bounds
}