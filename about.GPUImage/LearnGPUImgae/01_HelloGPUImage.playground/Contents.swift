//: Playground - noun: a place where people can play

import Cocoa
import GPUImage
import XCPlayground
//: Open Camera


XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

let resultView = GPUImageView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
let videoCamera = GPUImageVideoCamera(
    sessionPreset: AVCaptureSessionPreset640x480,
    cameraPosition: )
videoCamera.addTarget(resultView)


XCPlaygroundPage.currentPage.liveView = resultView

videoCamera.startCameraCapture()