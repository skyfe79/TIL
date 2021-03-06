import Foundation
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

//: # GCD Barriers
//: When you're using asynchronous calls then you need to conside thread safety.
//: Consider the following object:

let nameChangingPerson = Person(firstName: "Alison", lastName: "Anderson")

//: The `Person` class includes a method to change names:

nameChangingPerson.changeName(firstName: "Brian", lastName: "Biggles")
nameChangingPerson.name

//: What happens if you try and use the `changeName(firstName:lastName:)` simulataneously from a concurrent queue?

let workerQueue = dispatch_queue_create("com.raywenderlich.worker", DISPATCH_QUEUE_CONCURRENT)
let nameChangeGroup = dispatch_group_create()

let nameList = [("Charlie", "Cheesecake"), ("Delia", "Dingle"), ("Eva", "Evershed"), ("Freddie", "Frost"), ("Gina", "Gregory")]

for name in nameList {
  dispatch_group_async(nameChangeGroup, workerQueue) {
    nameChangingPerson.changeName(firstName: name.0, lastName: name.1)
    print("Current Name: \(nameChangingPerson.name)")
  }
}

dispatch_group_notify(nameChangeGroup, dispatch_get_main_queue()) {
  print("Final name: \(nameChangingPerson.name)")
  //XCPlaygroundPage.currentPage.finishExecution()
}

dispatch_group_wait(nameChangeGroup, DISPATCH_TIME_FOREVER)

//: __Result:__ `nameChangingPerson` has been left in an inconsistent state.


//: ## Dispatch Barrier
//: A barrier allows you add a task to a concurrent queue that will be run in a serial fashion. i.e. it will wait for the currently queued tasks to complete, and prevent any new ones starting.

// Thread-safe 하지 않은 Person을 Thread-safe하게 변경한다
// 중요!
class ThreadSafePerson: Person {
    // 우선 큐가 필요함
    let isolationQueue = dispatch_queue_create("kr.burt.person.isolation", DISPATCH_QUEUE_CONCURRENT)
    
    override func changeName(firstName firstName: String, lastName: String) {
        dispatch_barrier_async(isolationQueue) {
            super.changeName(firstName: firstName, lastName: lastName)
        }
    }
    
    override var name: String {
        var result = ""
        // 속성이므로 sync이어야 한다.
        dispatch_sync(isolationQueue) {
            result = super.name
        }
        return result
    }
    
}

print("\n=== Threadsafe ===")

let threadSafeNameGroup = dispatch_group_create()

let threadSafePerson = ThreadSafePerson(firstName: "Anna", lastName: "Adams")

for name in nameList {
  dispatch_group_async(threadSafeNameGroup, workerQueue) {
    threadSafePerson.changeName(firstName: name.0, lastName: name.1)
    print("Current threadsafe name: \(threadSafePerson.name)")
  }
}

dispatch_group_notify(threadSafeNameGroup, dispatch_get_main_queue()) {
  print("Final threadsafe name: \(threadSafePerson.name)")
  XCPlaygroundPage.currentPage.finishExecution()
}

