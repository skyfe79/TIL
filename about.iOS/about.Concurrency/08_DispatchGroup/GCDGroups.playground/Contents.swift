import UIKit
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

//: # GCD Groups
//: It's often useful to get notifications when a set of tasks has been completed—and that's precisely what GCD groups are for

let workerQueue = dispatch_queue_create("com.raywenderlich.worker", DISPATCH_QUEUE_CONCURRENT)

let numberArray = [(0,1), (2,3), (4,5), (6,7), (8,9)]

//: ## Creating a group
let slowSumGroup = dispatch_group_create()


//: ## Dispatching to a group
//: Very much like traditional `dispatch_async()`
for inValue in numberArray {
    dispatch_group_async(slowSumGroup, workerQueue) {
        let result = slowSum(inValue)
        dispatch_group_async(slowSumGroup, dispatch_get_main_queue()) {
            print("Result = \(result)")
        }
    }
}



//: ## Notification of group completion
//: Will be called only when everything in that dispatch group is completed
dispatch_group_notify(slowSumGroup, dispatch_get_main_queue()) {
    print("SLOW SUM: Completed all operations")
}



//: ## Waiting for a group to complete
//: __DANGER__ This is synchronous and can block
//: This is a synchronous call on the current queue, so will block it. You cannot have anything in the group that wants to use the current queue otherwise you'll block.
//17라인에서 main-queue를 얻어서 결과를 print하고 있다.
//아래의 문장은 slowSumGroup이 끝나길 기다리는데
//내부에서 main-queue를 사용하므로 main-queue가 끝나길 기다리는 것과 같다
//그러나 main-queue는 끝나지 않고 계속해서 이벤트 등을 처리하므로 끝나는 큐가 아니다.
//그래서 아래의 문장은 main-queue를 블럭 시킨다.  DEAD-LOCK
//17라인에서 print출력을 main-queue 없이 하면 블럭되지 않는다.
//dispatch_group_wait(slowSumGroup, DISPATCH_TIME_FOREVER)



//: ## Wrapping an existing Async API
//: All well and good for new APIs, but there are lots of async APIs that don't have group parameters. What can you do with them?
print("\n=== Wrapping an existing Async API ===\n")

let wrappedGroup = dispatch_group_create()

//: Wrap the original function

func asyncSum(input: (Int, Int), completionQueue: dispatch_queue_t, group: dispatch_group_t, completion: (Int)->()) {
    dispatch_group_enter(group)
    asyncSum(input, completionQueue: completionQueue) {
        completion($0)
        dispatch_group_leave(group)
    }
}

for pair in numberArray {
    // TODO: use the new function here to calculate the sums of the array
    asyncSum(pair, completionQueue: workerQueue, group: wrappedGroup) {
        print("Result : \($0)")
    }
}

// TODO: Notify of completion
dispatch_group_notify(wrappedGroup, dispatch_get_main_queue()) {
    print("Wrapped API: Completed all operations")
}

