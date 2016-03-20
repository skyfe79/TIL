//: Playground - noun: a place where people can play

import UIKit
import Alamofire
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

Alamofire.request(Method.GET, "http://www.google.com")
    .responseString { response in
        if let value = response.result.value {
            print(value)
        }
    }
