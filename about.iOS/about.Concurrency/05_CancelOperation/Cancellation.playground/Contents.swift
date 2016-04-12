import Foundation
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
//: # Operation Cancellation
//: If you've got a long-running operation that you decide you no longer want to run, then you can cancel it using the `cancel()` method. But what does that actually do.
//:
//:
//: `ArraySumOperation` take an array of `(Int, Int)` tuples, and uses the `slowAdd()` function provided in __Sources__ to generate an array of the resultant values.
class ArraySumOperation: NSOperation {
  let inputArray: [(Int, Int)]
  var outputArray = [Int]()
  
  init(input: [(Int, Int)]) {
    inputArray = input
    super.init()
  }
  
  // cancel() 메서드를 호출하면 cancelled 속성을 false에서 true로만 변경할 뿐 실제 작업을 취소하진 않는다.
  // 작업을 취소하는 것은 개발자의 구현에 따라 달려 있다. 아래처럼 작성하면 cancel()을 해도 Operation이 cancel
  // 되지 않는다.
//  override func main() {
//    // TODO: Fill this in
//    for pair in inputArray {
//    outputArray.append(slowAdd(pair))
//    }
//  }
    
    // 이렇게 해야 cancel된다.
    override func main() {
        // TODO: Fill this in
        for pair in inputArray {
            if cancelled { return }
            outputArray.append(slowAdd(pair))
        }
    }
    
}

//: `AnotherArraySumOperation` uses the `slowAddArray` function to add
class AnotherArraySumOperation: NSOperation {
  let inputArray: [(Int, Int)]
  var outputArray: [Int]?
  
  init(input: [(Int, Int)]) {
    inputArray = input
    super.init()
  }
  
  override func main() {
    // TODO: Fill in this
    outputArray = slowAddArray(inputArray) {
        progress in
        print("\(progress*100)% of the array processed")
        return self.cancelled != true
    }
  }
}

//: Input array
let numberArray = [(1,2), (3,4), (5,6), (7,8), (9,10)]

//: Operation and queue
let sumOperation = ArraySumOperation(input: numberArray)
let queue = NSOperationQueue()

//: Start the operation and
startClock()
queue.addOperation(sumOperation)

delay(0.5) {
    sumOperation.cancel()
}

sumOperation.completionBlock = {
  stopClock()
  sumOperation.outputArray
  //XCPlaygroundPage.currentPage.finishExecution()
}

//: Operation and queue

let arraySumOperation = AnotherArraySumOperation(input: numberArray)
let queue2 = NSOperationQueue()

//: Start the operation and

startClock()
queue2.addOperation(arraySumOperation)

delay(1.0) {
    arraySumOperation.cancel()
}

arraySumOperation.completionBlock = {
    stopClock()
    arraySumOperation.outputArray
    XCPlaygroundPage.currentPage.finishExecution()
}
