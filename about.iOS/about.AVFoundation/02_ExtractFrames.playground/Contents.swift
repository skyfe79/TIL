//: Playground - noun: a place where people can play
//: @see http://pinkstone.co.uk/how-to-extract-a-uiimage-from-a-video-in-ios-9/
import UIKit
import AVFoundation
import XCPlayground

if let url = NSBundle.mainBundle().URLForResource("video", withExtension: "mp4") {
    let frame = AVFrameUtils.firstFrame(url)
    XCPlaygroundPage.currentPage.captureValue(frame, withIdentifier: "frame")
}


if let url = NSBundle.mainBundle().URLForResource("video", withExtension: "mp4") {
    let frameList = AVFrameUtils.extractAllFrameList(url, countPerSecond: 2)
    for (i,frame) in frameList.enumerate() {
        XCPlaygroundPage.currentPage.captureValue(frame, withIdentifier: "frame-\(i)")
    }
}

