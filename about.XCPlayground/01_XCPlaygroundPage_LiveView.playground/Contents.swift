//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

//: UIView가 실시간으로 렌더링 되는 것을 볼 수 있다.


let someView = UIView(frame: CGRectMake(0, 0, 100, 100))
someView.backgroundColor = UIColor.redColor()

//: Timeline Assistant를 켜야 한다.
XCPlaygroundPage.currentPage.liveView = someView


let outerRect = CGRectInset(someView.frame, -10, -10)
let toPath = UIBezierPath(ovalInRect: outerRect)

let shape = CAShapeLayer()
shape.path = toPath.CGPath

someView.layer.mask = shape


