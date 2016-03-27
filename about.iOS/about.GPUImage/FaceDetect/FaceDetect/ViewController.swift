//
//  ViewController.swift
//  FaceDetect
//
//  Created by burt on 3/21/16.
//  Copyright © 2016 burt. All rights reserved.
//

import UIKit
import GPUImage
import YYImage

class ViewController: UIViewController {
    
    var filterView: GPUImageView!
    var videoCamera : GPUImageVideoCamera!
    var uiElement: GPUImageUIElement!
    var filter:GPUImageFilter!
    var blendFilter: GPUImageAlphaBlendFilter!
    var uiElementInput: GPUImageUIElement!
    
    var beardImageView: UIImageView!
    var christmasHatImageView: UIImageView!
    var mustacheImageView: UIImageView!
    var webpImageView: UIImageView!
    var faceDetector : CIDetector!
    var decoder: YYImageDecoder!
    var frameCount : UInt = 0
    var lastTime: Float64 = 0
    var currentIndex : UInt = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = NSBundle.mainBundle().pathForResource("bored_animation", ofType: "webp")
        let data = NSData(contentsOfFile: path!)!
        decoder = YYImageDecoder(data: data, scale: 2.0)
        frameCount = decoder.frameCount
        
        filterView = GPUImageView(frame: self.view.bounds)
        self.view.addSubview(filterView)
        
        videoCamera = GPUImageVideoCamera(
            sessionPreset: AVCaptureSessionPreset640x480,
            cameraPosition: AVCaptureDevicePosition.Front)
        videoCamera.outputImageOrientation = .Portrait
        videoCamera.horizontallyMirrorFrontFacingCamera = true
        videoCamera.horizontallyMirrorRearFacingCamera = false
        videoCamera.delegate = self
        
        filter = GPUImageBilateralFilter()
        blendFilter = GPUImageAlphaBlendFilter()
        blendFilter.mix = 1.0
        
        videoCamera.addTarget(filter)
        
        // 컨텐츠 UIView를 만들어서 렌더링한다.
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
        self.beardImageView = UIImageView(image: UIImage(named: "beard")!)
        self.christmasHatImageView = UIImageView(image: UIImage(named: "christmas_hat"))
        self.mustacheImageView = UIImageView(image: UIImage(named: "mustache"))
        self.mustacheImageView.center = CGPointMake(100,100)
        self.webpImageView = UIImageView(frame: CGRectMake(0, 0, 150, 150))
        
        contentView.addSubview(beardImageView)
        contentView.addSubview(christmasHatImageView)
        contentView.addSubview(mustacheImageView)
        contentView.addSubview(self.webpImageView)
        
        uiElementInput = GPUImageUIElement(view: contentView)
        
        filter.addTarget(blendFilter)
        uiElementInput.addTarget(blendFilter)
        blendFilter.addTarget(filterView)
        
        
        filter.frameProcessingCompletionBlock = { [weak self] filter, time in
            
            guard let this = self else { return }
            
            let elapsed = CMTimeGetSeconds(time) - this.lastTime
            if elapsed > 1500 {
                let image = this.decoder.frameAtIndex(this.currentIndex, decodeForDisplay: true)?.image
                this.currentIndex = this.currentIndex + 1
                this.currentIndex = this.currentIndex % this.frameCount
                this.webpImageView.image = image
            }
            
            this.uiElementInput.update()
        }
        
        videoCamera.startCameraCapture()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.startFaceDetection()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.stopFaceDetection()
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension ViewController : GPUImageVideoCameraDelegate {
    
    func willOutputSampleBuffer(sampleBuffer: CMSampleBuffer!) {
        guard self.faceDetector != nil else { return }
        
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        guard let pb = pixelBuffer else { return }
        
        let ciImage = CIImage(CVPixelBuffer: pb)
        
        // 세로 방향 이미지
        let opt = [ CIDetectorImageOrientation : Int(6) ]
        let faceFeatures = self.faceDetector.featuresInImage(ciImage, options: opt)
        
        for faceFeature in faceFeatures {
            
            let faceRect = faceFeature.bounds
            
            let hat_width : CGFloat = 290.0
            let hat_height  : CGFloat  = 360.0
            let head_start_y  : CGFloat  = 150.0
            let head_start_x  : CGFloat  = 78.0
            
            var width = faceRect.size.width * (hat_width / (hat_width - head_start_x));
            var height = width * hat_height/hat_width;
            var y = faceRect.origin.y - (height * head_start_y) / hat_height;
            var x = faceRect.origin.x - (head_start_x * width/hat_width);
            self.christmasHatImageView.frame = CGRectMake(x, y, width, height)
            
            
            let beard_width : CGFloat = 192.0;
            let beard_height : CGFloat = 171.0;
            width = faceRect.size.width * 0.6;
            height =  width * beard_height/beard_width;
            y = faceRect.origin.y + faceRect.size.height - (80 * height/beard_height);
            x = faceRect.origin.x + (faceRect.size.width - width)/2;
            self.beardImageView.frame = CGRectMake(x, y, width, height)
            
            let mustache_width : CGFloat = 212.0;
            let mustache_height : CGFloat = 58.0;
            width = faceRect.size.width * 0.9;
            height = width * mustache_height/mustache_width;
            y = y - height + 5;
            x = faceRect.origin.x + (faceRect.size.width - width)/2;
            self.mustacheImageView.frame = CGRectMake(x, y, width, height)
            
            self.webpImageView.frame = faceFeature.bounds
        }
        
    }
}

extension ViewController {
    func startFaceDetection() {
        if self.faceDetector == nil {
            
            let options = [CIDetectorAccuracy : CIDetectorAccuracyLow]
            
            self.faceDetector = CIDetector(ofType: CIDetectorTypeFace,
                context: nil, options: options)
        }
    }
    
    func stopFaceDetection() {
        self.faceDetector = nil
    }
}



