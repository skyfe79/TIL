//: Playground - noun: a place where people can play

import UIKit
import YYImage
import XCPlayground


//: Decoding WebP
let path = NSBundle.mainBundle().pathForResource("bored_animation", ofType: "webp")
let data = NSData(contentsOfFile: path!)!

let decoder = YYImageDecoder(data: data, scale: 2.0)
let image = decoder?.frameAtIndex(0, decodeForDisplay: true)?.image
XCPlaygroundPage.currentPage.captureValue(image, withIdentifier: "frame-0-image")

if let decoder = decoder {
    
    for i in 0..<decoder.frameCount {
        
        let image = decoder.frameAtIndex(i, decodeForDisplay: true)?.image
        XCPlaygroundPage.currentPage.captureValue(image, withIdentifier: "frame-\(i)-image")
        
        let frameDuration = decoder.frameDurationAtIndex(i)
        XCPlaygroundPage.currentPage.captureValue(i, withIdentifier: "frame-\(i)-duration")
    }
        
}



