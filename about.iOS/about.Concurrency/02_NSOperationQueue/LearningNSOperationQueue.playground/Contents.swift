import UIKit
import XCPlayground

//: # NSOperationQueue
//: NSOperationQueue is responsible for scheduling and running a set of operations, somewhere in the background. 

//: To prevent the playground from killing background tasks when the main thread has completed, need to specify indefinite execution
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true


//: ## Creating a queue
//: Operations can be added to queues directly as closures

let printerQueue = NSOperationQueue()
printerQueue.maxConcurrentOperationCount = 2

startClock()
printerQueue.addOperationWithBlock { sleep(5); print("Hello") }
printerQueue.addOperationWithBlock { sleep(5); print("my") }
printerQueue.addOperationWithBlock { sleep(5); print("name") }
printerQueue.addOperationWithBlock { sleep(5); print("is") }
printerQueue.addOperationWithBlock { sleep(5); print("Sungcheol") }
stopClock()

startClock()
printerQueue.waitUntilAllOperationsAreFinished()
stopClock()





//: ## Adding NSOperations to queues
let images = ["city", "dark_road", "train_day", "train_dusk", "train_night"].map { UIImage(named: "\($0).jpg") }
var filteredImages = [UIImage]()

//: Create the queue with the default constructor
let filterQueue = NSOperationQueue()

let appendQueue = NSOperationQueue()
appendQueue.maxConcurrentOperationCount = 1
//: Create a filter operations for each of the iamges, adding a completionBlock
for image in images {
    let filterOperation = TiltShiftOperation()
    filterOperation.inputImage = image
    filterOperation.completionBlock = {
        guard let output = filterOperation.outputImage else { return }
        
        appendQueue.addOperationWithBlock {
            filteredImages.append(output)
        }
    }
    filterQueue.addOperation(filterOperation)
}

//: Need to wait for the queue to finish before checking the results

filterQueue.waitUntilAllOperationsAreFinished()

//: Inspect the filtered images
filteredImages


/*
The problem comes from two separate threads attempting to append images to the array at the same time, 
and the solution is to prevent that from happening. 
To that end add a new serial NSOperationQueue whose sole responsibility is to manage additions to the images array.

let appendQueue = NSOperationQueue()
appendQueue.maxConcurrentOperationCount = 1

Then push the append() calls onto this serial queue:

appendQueue.addOperationWithBlock {
    filteredImages.append(output)
}

The fact that appendQueue is serial means that only one append() can occur at once, 
making it impossible for the race condition to occur.

*/






