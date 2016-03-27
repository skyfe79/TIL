//
//  ViewController.swift
//  CustomVideoProcessing
//
//  Created by burt on 2016. 3. 27..
//  Copyright © 2016년 BurtK. All rights reserved.
//
//  @see https://www.invasivecode.com/weblog/a-quasi-real-time-video-processing-on-ios-in/

/**

To appreciate what we are going to do, we need to build a custom camera preview. 
If we want to process a video buffer and show the result in real-time, we cannot use the
AVCaptureVideoPreviewLayer as shown in this post, 
because that camera preview renders the signal directly and does not offer any way to process it, before the rendering.
To make this possible, you need to take the video buffer, process it and then render it on a custom CALayer. 
Let’s see how to do that.

*/
import UIKit
import AVFoundation
import Accelerate

class ViewController: UIViewController {
    
    lazy var cameraSession : AVCaptureSession = {
        let s = AVCaptureSession()
        if s.canSetSessionPreset(AVCaptureSessionPreset1280x720) {
            s.sessionPreset = AVCaptureSessionPreset1280x720
        } else if s.canSetSessionPreset(AVCaptureSessionPreset640x480) {
            s.sessionPreset = AVCaptureSessionPreset640x480
        } else {
            s.sessionPreset = AVCaptureSessionPresetLow
        }
        return s
    }()
    
    lazy var previewLayer : AVCaptureVideoPreviewLayer = {
        let preview = AVCaptureVideoPreviewLayer(session: self.cameraSession)
        preview.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        // position을 설정해 주는 것. 중요하다. 아랫줄을 주석처리하고 실행해 보라.
        preview.position = CGPoint(x: CGRectGetMidX(self.view.bounds), y: CGRectGetMidY(self.view.bounds))
        preview.videoGravity = AVLayerVideoGravityResize
        return preview
    }()
    
    lazy var customPreviewLayer: CALayer = {
        let preview = CALayer()
        // 중요! portrait 설정을 하는 방법을 보라
        preview.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.height, height: self.view.bounds.width)
        // position을 설정해 주는 것. 중요하다. 아랫줄을 주석처리하고 실행해 보라.
        preview.position = CGPoint(x: CGRectGetMidX(self.view.bounds), y: CGRectGetMidY(self.view.bounds))
        preview.setAffineTransform(CGAffineTransformMakeRotation(CGFloat(M_PI_2)))
        return preview
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraSession()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //view.layer.addSublayer(self.previewLayer)
        view.layer.addSublayer(self.customPreviewLayer)
        cameraSession.startRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController {
    func setupCameraSession() {
        
        // 비디오를 캡쳐하는 기본 장치를 얻는다.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo) as AVCaptureDevice
        
        do {
            // 위에서 얻은 장치를 input 으로 만든다. 즉, 비디오 스트림을 방출하도록 만든다.
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            
            // 세션 설정 시작
            cameraSession.beginConfiguration()
            
            if cameraSession.canAddInput(deviceInput) {
                cameraSession.addInput(deviceInput)
            }
            
            // 비디오 데이터의 출력 부분을 만든다.
            // 출력이므로 픽셀포멧에 관한 설정이 필요하다
            // 여기서는 YCbCr을 사용한다.
            // @see https://en.wikipedia.org/wiki/YCbCr
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [ kCVPixelBufferPixelFormatTypeKey : UInt(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange) ]
            // 아주 중요한 설정이다.
            // 간혹 비디오 프레임이 아주 느리게 나올 때가 있는데 그 때는 해당 프레임을 그냥 버리도록한다.
            // 왜냐하면 그 프레임을 기다리면서 UI를 멈춰야 하기 때문이다.
            dataOutput.alwaysDiscardsLateVideoFrames = true
            
            if cameraSession.canAddOutput(dataOutput) == true {
                cameraSession.addOutput(dataOutput)
            }
            
            // 세션 설정 종료
            cameraSession.commitConfiguration()
            
            // 카메라 프레임을 처리할 큐 설정
            let queue = dispatch_queue_create("kr.pe.burt.videoQueue", DISPATCH_QUEUE_SERIAL)
            dataOutput.setSampleBufferDelegate(self, queue: queue)
        }
        catch let error as NSError {
            print("\(error), \(error.localizedDescription)")
        }
    }
}

extension ViewController : AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(captureOutput: AVCaptureOutput!, didDropSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        // discard되어 드롭된 프레임이 발생할 경우 호출된다.
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        // 비디오 영상의 각 프레임을 여기서 처리할 수 있다.
        // 효과나 얼굴추출 그런 것들
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // 이미지 버퍼 수정을 위해 Lock한다.
        CVPixelBufferLockBaseAddress(imageBuffer, 0)
        
        let width = CVPixelBufferGetWidthOfPlane(imageBuffer, 0)
        let height = CVPixelBufferGetHeightOfPlane(imageBuffer, 0)
        let bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0)
        
        // Remember the video buffer is in YUV format, so I extract the luma component from the buffer in this way:
        let lumaBuffer = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0)
        
        let (processedBuffer, toReleaseData) = imageProcessing(lumaBuffer, width: width, height: height, bytesPerRow: bytesPerRow)
        
        /**
            Now, let’s render this buffer on the layer. 
            To do so, we need to use Core Graphics: 
                create a color space, 
                create a graphic context and render the buffer onto the graphic context using the created color space:
        */
        let grayColorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGBitmapContextCreate(processedBuffer, width, height, 8, bytesPerRow, grayColorSpace, CGImageAlphaInfo.None.rawValue)
        let dstImage = CGBitmapContextCreateImage(context)
        
        /**
            So, the dstImage is a Core Graphics image (CGImage), created from the captured buffer. 
            Finally, we render this image on the layer, changing its contents. We do that on the main queue:
        */
        dispatch_sync(dispatch_get_main_queue()) { [weak self] in
            self?.customPreviewLayer.contents = dstImage
        }
        
        free(toReleaseData)
    }
}

extension ViewController {
    
    func imageProcessing(lumaBuffer : UnsafeMutablePointer<Void>, width : Int, height : Int, bytesPerRow: Int) -> (UnsafeMutablePointer<Void>, UnsafeMutablePointer<Void>) {
        var inImage = vImage_Buffer(data: lumaBuffer, height: vImagePixelCount(height), width: vImagePixelCount(width), rowBytes: bytesPerRow)
        let outBuffer : UnsafeMutablePointer<Void> = calloc(width * height, sizeof(Pixel_8))
        var outImage = vImage_Buffer(data: outBuffer, height: vImagePixelCount(height), width: vImagePixelCount(width), rowBytes: bytesPerRow)
        
        let kernelSize = 7
        vImageMin_Planar8(&inImage, &outImage, nil, 0, 0, vImagePixelCount(kernelSize), vImagePixelCount(kernelSize), vImage_Flags(kvImageDoNotTile))
        
        return (outImage.data, outBuffer)
    }
}


