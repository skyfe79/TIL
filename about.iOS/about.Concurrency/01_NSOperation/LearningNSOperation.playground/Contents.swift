//: # NSOperation
//: ## NSOperation은 일종의 Command Pattern이며 자체 상태를 가지고 있다

import UIKit
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true


var result: Int?

//: ## Creating an NSBlockOperation to add two numbers

let summationOperation = NSBlockOperation {
    result = 2 + 3
    sleep(5)
}

//: 주의할 점은 NSOperation 이 자신이 실행되는 현재 쓰레드를 Blocking 한다는 점이다. 위에서 sleep(5)로 인해 5초후에 경과된 시간값이 출력된다. 
//: 즉, NSOperation은 완벽하게 synchronous 하게 동작한다. 물론 모든 NSOperation이 synchronous한 것은 아니다. 어떤 방식으로 동작할 것인지 
//: 정할 수 있기에 NSOperation이 아주 강력한 것이다.
startClock()
summationOperation.start()
result
stopClock()


//: ## NSBlockOperations can have multiple blocks, that run concurrently

let multiPrinter = NSBlockOperation()

multiPrinter.addExecutionBlock {
    print("Hello")
    sleep(5)
}

multiPrinter.addExecutionBlock {
    print("My")
    sleep(5)
}


multiPrinter.addExecutionBlock {
    print("name")
    sleep(5)
}


multiPrinter.addExecutionBlock {
    print("is")
    sleep(5)
}

multiPrinter.addExecutionBlock {
    print("Burt.K")
    sleep(5)
}

//: 위에서 각 블럭마다 5초씩 sleep했다. 그래서 전체 25초가 걸릴 것이라고 생각하기 쉽지만 각 block들은 concurrent 하게 실행된다. 즉, 동시에 실행되는 것들이 있기에 25초 이내에 실행된다.
//: 콘솔을 보면 출력 결과를 볼 수 있다. 내 경우에는 5초동안 실행되었고 출력은 name is Hello Burt.K My 순으로 출력되었다.
startClock()
multiPrinter.start()
stopClock()

//: ## Subclassing NSOperation
let inputImage = UIImage(named: "dark_road_small.jpg")

//: Creating an operation to add tilt-shift blur to an image

class TiltShiftOperation: NSOperation {
    var inputImage: UIImage?
    var outputImage: UIImage?
    
    override func main() {
        guard let inputImage = inputImage else { return }
        let mask = topAndBottomGradient(inputImage.size)
        outputImage = inputImage.applyBlurWithRadius(4, maskImage: mask)
    }
}

let tiltOperation = TiltShiftOperation()
tiltOperation.inputImage = inputImage

startClock()
tiltOperation.start()
stopClock()

tiltOperation.outputImage


