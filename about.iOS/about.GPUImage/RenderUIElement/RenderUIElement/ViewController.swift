//
//  ViewController.swift
//  RenderUIElement
//
//  Created by burt on 3/21/16.
//  Copyright © 2016 burt. All rights reserved.
//

import UIKit
import GPUImage

class ViewController: UIViewController {
    
    var filterView: GPUImageView!
    var videoCamera : GPUImageVideoCamera!
    var uiElement: GPUImageUIElement!
    var filter:GPUImageBrightnessFilter!
    var blendFilter: GPUImageAlphaBlendFilter!
    var uiElementInput: GPUImageUIElement!
    
    var beardImageView: UIImageView!
    var christmasHatImageView: UIImageView!
    var mustacheImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterView = GPUImageView(frame: self.view.bounds)
        self.view.addSubview(filterView)
        
        videoCamera = GPUImageVideoCamera(
            sessionPreset: AVCaptureSessionPreset640x480,
            cameraPosition: AVCaptureDevicePosition.Back)
        videoCamera.outputImageOrientation = .Portrait
        videoCamera.horizontallyMirrorFrontFacingCamera = false
        videoCamera.horizontallyMirrorRearFacingCamera = false
        
        filter = GPUImageBrightnessFilter()
        blendFilter = GPUImageAlphaBlendFilter()
        blendFilter.mix = 1.0
        
        videoCamera.addTarget(filter)
        
        // here I try to add a label as UIElement
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
        self.beardImageView = UIImageView(image: UIImage(named: "beard")!)
        self.christmasHatImageView = UIImageView(image: UIImage(named: "christmas_hat"))
        self.mustacheImageView = UIImageView(image: UIImage(named: "mustache"))
        self.mustacheImageView.center = CGPointMake(100,100)
        
        contentView.addSubview(beardImageView)
        contentView.addSubview(christmasHatImageView)
        contentView.addSubview(mustacheImageView)
        
        uiElementInput = GPUImageUIElement(view: contentView)
        
        filter.addTarget(blendFilter)
        uiElementInput.addTarget(blendFilter)
        blendFilter.addTarget(filterView)
        
        filter.frameProcessingCompletionBlock = { filter, time in
            self.uiElementInput.update()
        }
        
        videoCamera.startCameraCapture()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

