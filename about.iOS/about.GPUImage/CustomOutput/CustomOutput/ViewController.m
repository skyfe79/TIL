//
//  ViewController.m
//  CustomOutput
//
//  Created by burt on 3/30/16.
//  Copyright © 2016 burt. All rights reserved.
//

#import "ViewController.h"
#import <GPUImage/GPUImage.h>
#import "GPUImageSpriteOverlayOutput.h"

@interface ViewController ()
@property(nonatomic, strong) GPUImageVideoCamera* videoCamera;
@property(nonatomic, strong) GPUImageView* videoOut;
@property(nonatomic, strong) GPUImageAlphaBlendFilter* middle;
@property(nonatomic, strong) GPUImageAlphaBlendFilter* final;
@property(nonatomic, strong) GPUImageMovie* movie;
@property(nonatomic, strong) GPUImageSpriteOverlayOutput* sprite;
@property(nonatomic, strong) GPUImageBilateralFilter *filter;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videoOut = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.videoOut];
    
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.videoCamera.horizontallyMirrorRearFacingCamera = YES;
    
    self.sprite = [[GPUImageSpriteOverlayOutput alloc] initWithSize:CGSizeMake(450, 500)];
    self.middle = [[GPUImageAlphaBlendFilter alloc] init];
    self.middle.mix = 0.5f;
    self.final  = [[GPUImageAlphaBlendFilter alloc] init];
    self.final.mix = 0.5f;
    self.filter = [[GPUImageBilateralFilter alloc] init];
    
    
    [self.sprite addTarget:self.middle];
    [self.videoCamera addTarget:self.middle];
    [self.videoCamera addTarget:self.final];
    
    [self.middle addTarget:self.final];
    
    [self.final addTarget:self.videoOut];
    
    [self.sprite processData];
    [self.videoCamera startCameraCapture];
    
    __weak ViewController *weakSelf = self;
    [self.final setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time) {
        [weakSelf.sprite update:time];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
