//
//  ViewController.swift
//  LearnGPUImgae
//
//  Created by burt on 3/21/16.
//  Copyright © 2016 burt. All rights reserved.
//

import UIKit
import GPUImage

class ViewController: UIViewController {

    var videoCamera: GPUImageVideoCamera!
    var videoOut: GPUImageView!
    
    
    var picture : GPUImagePicture!
    var normalBlendFilter: GPUImageNormalBlendFilter!
    var blendFilter: GPUImageAlphaBlendFilter!
    
    var grayFilter: GPUImageGrayscaleFilter!
    var transform: GPUImageTransformFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ok6()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    /**
            camera ->
                        + blendFilter -> transform
            picture->
    */
    private func ok1() {
        
        videoOut = GPUImageView(frame: self.view.bounds)
        self.view.addSubview(videoOut)
        
        
        videoCamera = GPUImageVideoCamera(
            sessionPreset: AVCaptureSessionPreset640x480,
            cameraPosition: AVCaptureDevicePosition.Front)
        videoCamera.outputImageOrientation = .Portrait
        videoCamera.horizontallyMirrorFrontFacingCamera = true
        
        
        picture = GPUImagePicture(image: UIImage(named: "heart")!)
        blendFilter = GPUImageAlphaBlendFilter()
        
        
        transform = GPUImageTransformFilter()
        transform.affineTransform = CGAffineTransformMakeScale(0.5, 0.5)
        picture.processImage()
        
        
        videoCamera.addTarget(blendFilter)
        picture.addTarget(blendFilter)
        
        
        blendFilter.addTarget(transform)
        transform.addTarget(videoOut)
        
        videoCamera.startCameraCapture()
    }
    
    
    /**
     
     GPUImageView
     |
     |
     GPUImageTransformFilter
     |
     |
     GPUImageAlaphaBlendFilter
     |                 |
     |                 |
     |    GPUImageGrayFilter
     |                 |
     |                 |
     |     GPUImageNormalBlendFilter
     |       |                   |
     |       |(*)                |
     |       |                   |
     GPUImageVideoCamera    GPUImagePicture
     
     (*) this path is just to distribute the pulse, but the GPUImageNormalBlendFilter will output only GPUImagePicture
     
    */
    private func ok2() {
        videoOut = GPUImageView(frame: self.view.bounds)
        self.view.addSubview(videoOut)
        
        
        videoCamera = GPUImageVideoCamera(
            sessionPreset: AVCaptureSessionPreset640x480,
            cameraPosition: AVCaptureDevicePosition.Front)
        videoCamera.outputImageOrientation = .Portrait
        videoCamera.horizontallyMirrorFrontFacingCamera = true
        
        
        picture = GPUImagePicture(image: UIImage(named: "heart")!)
        
        normalBlendFilter = GPUImageNormalBlendFilter()
        blendFilter = GPUImageAlphaBlendFilter()
        grayFilter = GPUImageGrayscaleFilter()
        transform = GPUImageTransformFilter()
        transform.affineTransform = CGAffineTransformMakeScale(0.5, 0.5)
        
        
        videoCamera.addTarget(blendFilter)
        videoCamera.addTarget(normalBlendFilter)
        picture.addTarget(normalBlendFilter)
        normalBlendFilter.addTarget(grayFilter)
        
        grayFilter.addTarget(blendFilter)
        picture.processImage()
        
        
        blendFilter.addTarget(transform)
        transform.addTarget(videoOut)
        
        videoCamera.startCameraCapture()
    }
    
    /**
     GPUImageView
     |
     |
     GPUImageAlaphaBlendFilter
     |                 |
     |                 |
     |                 |
     |                 |
     |                 |
     |     GPUImageNormalBlendFilter
     |       |                   |TransformFilter
     |       |(*)                | Gray
     |       |                   |
     |       |                   |
     |       |                   |
     GPUImageVideoCamera    GPUImagePicture
     */
    private func ok3() {
        videoOut = GPUImageView(frame: self.view.bounds)
        self.view.addSubview(videoOut)
        
        
        videoCamera = GPUImageVideoCamera(
            sessionPreset: AVCaptureSessionPreset640x480,
            cameraPosition: AVCaptureDevicePosition.Front)
        videoCamera.outputImageOrientation = .Portrait
        videoCamera.horizontallyMirrorFrontFacingCamera = true
        
        
        picture = GPUImagePicture(image: UIImage(named: "heart")!)
        
        normalBlendFilter = GPUImageNormalBlendFilter()
        blendFilter = GPUImageAlphaBlendFilter()
        grayFilter = GPUImageGrayscaleFilter()
        transform = GPUImageTransformFilter()
        transform.affineTransform = CGAffineTransformMakeScale(0.5, 0.5)
        
        
        videoCamera.addTarget(blendFilter)
        videoCamera.addTarget(normalBlendFilter)
        
        picture.addTarget(grayFilter)
        grayFilter.addTarget(transform)
        transform.addTarget(normalBlendFilter)
        
        normalBlendFilter.addTarget(blendFilter)
       picture.processImage()

        
        
        blendFilter.addTarget(videoOut)

        videoCamera.startCameraCapture()
    }
    
    /**
 
     GPUImageView
     ...... |
     GPUImageNormalBlendFilter2
     ...... | ...... |
     ...... | ......GPUImageTransformFilter (shrink to 0.5 size)
     ...... | ...... |
     ...... | ......GPUImageNormalBlendFilter1
     ...... | .......|(*)..............|
     ...... GPUImageMovie ...... GPUImagePicture
     
     
    */
    
    var normalBlend1 : GPUImageNormalBlendFilter!
    var normalBlend2 : GPUImageNormalBlendFilter!
    
    private func ok4() {
        videoOut = GPUImageView(frame: self.view.bounds)
        self.view.addSubview(videoOut)
        
        
        videoCamera = GPUImageVideoCamera(
            sessionPreset: AVCaptureSessionPreset640x480,
            cameraPosition: AVCaptureDevicePosition.Front)
        videoCamera.outputImageOrientation = .Portrait
        videoCamera.horizontallyMirrorFrontFacingCamera = true
        
        
        picture = GPUImagePicture(image: UIImage(named: "heart")!)
        
        normalBlend1 = GPUImageNormalBlendFilter()
        normalBlend2 = GPUImageNormalBlendFilter()
        transform = GPUImageTransformFilter()
        transform.affineTransform = CGAffineTransformMakeScale(0.5, 0.5)
        
        
        videoCamera.addTarget(normalBlend2)
        videoCamera.addTarget(normalBlend1)
        
        picture.addTarget(normalBlend1)
        normalBlend1.addTarget(transform)
        picture.processImage()
        transform.addTarget(normalBlend2)
        
        normalBlend2.addTarget(videoOut)
        
        videoCamera.startCameraCapture()
    }
    
    private func ok5() {
        videoOut = GPUImageView(frame: self.view.bounds)
        self.view.addSubview(videoOut)
        
        
        videoCamera = GPUImageVideoCamera(
            sessionPreset: AVCaptureSessionPreset640x480,
            cameraPosition: AVCaptureDevicePosition.Front)
        videoCamera.outputImageOrientation = .Portrait
        videoCamera.horizontallyMirrorFrontFacingCamera = true
        
        
        picture = GPUImagePicture(image: UIImage(named: "heart")!)

        blendFilter = GPUImageAlphaBlendFilter()
        
        transform = GPUImageTransformFilter()
        transform.affineTransform = CGAffineTransformMakeScale(0.1, 0.1)
        
        
//        let affine = CGAffineTransformMakeScale(0.5, 0.5)
//        CGAffineTransformTranslate(affine, , 0.5)
//        transform.affineTransform = affine
        
        
        videoCamera.addTarget(blendFilter)
        picture.addTarget(transform)
        transform.addTarget(blendFilter)
        
        picture.processImage()
        blendFilter.addTarget(videoOut)
        
        transform.frameProcessingCompletionBlock = { [weak self] output, time in
            self?.transform.affineTransform = CGAffineTransformMakeScale(sin(CGFloat(CMTimeGetSeconds(time))), 0.5)
        }
        videoCamera.startCameraCapture()
    }
    
    
    /**
     GPUImageView
     |
     |
     GPUImageAlaphaBlendFilter ( blendFilter )
     |                 |
     |                 |
     |                 |
     |                 |
     |                 |
     |     GPUImageAlphaBlendFilter ( alphaBlend2 )
     |       |                   |
     |       |(*)                |
     |       |               TransformFilter
     |       |                   |
     |       |                   |
     GPUImageVideoCamera    GPUImagePicture
     */
    var alphaBlend2 : GPUImageAlphaBlendFilter!
    private func ok6() {
        videoOut = GPUImageView(frame: self.view.bounds)
        self.view.addSubview(videoOut)
        
        videoCamera = GPUImageVideoCamera(
            sessionPreset: AVCaptureSessionPreset640x480,
            cameraPosition: AVCaptureDevicePosition.Front)
        videoCamera.outputImageOrientation = .Portrait
        videoCamera.horizontallyMirrorFrontFacingCamera = true
        
        
        picture = GPUImagePicture(image: UIImage(named: "heart")!)
        
        alphaBlend2 = GPUImageAlphaBlendFilter()
        blendFilter = GPUImageAlphaBlendFilter()
        alphaBlend2.mix = 1.0
        blendFilter.mix = 1.0
        
        transform = GPUImageTransformFilter()
        
//      초기 설정 - 필요 없으면 안 해도 됨
//        transform.affineTransform = CGAffineTransformMakeScale(0.5, 0.5)
        
        videoCamera.addTarget(blendFilter)
        videoCamera.addTarget(alphaBlend2)
        
        picture.addTarget(transform)
        transform.addTarget(alphaBlend2)
        alphaBlend2.addTarget(blendFilter)
        picture.processImage()
        
        blendFilter.frameProcessingCompletionBlock = { [weak self] output, time in
            self?.picture.removeAllTargets()
            self?.transform.removeAllTargets()
            self?.alphaBlend2.removeAllTargets()
            
//            필요가 없음
//            self?.picture = GPUImagePicture(image: UIImage(named: "heart")!)
//            self?.transform = GPUImageTransformFilter()
            
            var t = CGAffineTransformMakeScale(sin(CGFloat(CMTimeGetSeconds(time))), 0.5)
            t = CGAffineTransformTranslate(t, sin(CGFloat(CMTimeGetSeconds(time))), sin(CGFloat(CMTimeGetSeconds(time))))
            self?.transform.affineTransform = t
            
            
            self?.picture.addTarget(self?.transform)
            self?.transform.addTarget(self?.alphaBlend2)
            self?.alphaBlend2.addTarget(self?.blendFilter)
            self?.picture.processImage()
            
        }
        
        blendFilter.addTarget(videoOut)
        
        videoCamera.startCameraCapture()
    }
}




















