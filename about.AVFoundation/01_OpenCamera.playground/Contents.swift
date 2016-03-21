//: Playground - noun: a place where people can play

import Cocoa
import AVFoundation
import AVKit
import QuartzCore
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

var view = NSView(frame: NSRect(x: 0, y: 0, width: 640, height: 480))
var session = AVCaptureSession()

session.sessionPreset = AVCaptureSessionPreset640x480
session.beginConfiguration()
session.commitConfiguration()

var input : AVCaptureDeviceInput! = nil
var err : NSError?
var devices : [AVCaptureDevice] = AVCaptureDevice.devices() as! [AVCaptureDevice]

for device in devices {
    
    if device.hasMediaType(AVMediaTypeVideo) && device.supportsAVCaptureSessionPreset(AVCaptureSessionPreset640x480) {
        
        try! input = AVCaptureDeviceInput(device: device)
        
        if session.canAddInput(input) {
            session.addInput(input)
            break
        }
    }
    
}

var settings : [NSObject:AnyObject!] = [kCVPixelBufferPixelFormatTypeKey:Int(kCVPixelFormatType_32BGRA)]
var output = AVCaptureVideoDataOutput()
output.videoSettings = settings
output.alwaysDiscardsLateVideoFrames = true

if session.canAddOutput(output) {
    session.addOutput(output)
}

var captureLayer = AVCaptureVideoPreviewLayer(session: session)
view.wantsLayer = true
view.layer = captureLayer

session.startRunning()

XCPlaygroundPage.currentPage.liveView = view
