//
//  ViewController.swift
//  OpenCamera
//
//  Created by burt on 2016. 3. 27..
//  Copyright © 2016년 BurtK. All rights reserved.
//

//  @see https://www.invasivecode.com/weblog/AVFoundation-Swift-capture-video/

import UIKit
import AVFoundation

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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraSession()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        view.layer.addSublayer(self.previewLayer)
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
    }
}


















