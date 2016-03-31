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
#import "GPUImageTempFilter.h"
#import <YYImage/YYImage.h>
@import GLKit;

@interface ViewController ()
@property(nonatomic, strong) GPUImageVideoCamera* videoCamera;
@property(nonatomic, strong) GPUImageView* videoOut;
@property(nonatomic, strong) GPUImageAlphaBlendFilter* middle;
@property(nonatomic, strong) GPUImageAlphaBlendFilter* final;
@property(nonatomic, strong) GPUImageMovie* movie;
@property(nonatomic, strong) GPUImageSpriteOverlayOutput* sprite;
@property(nonatomic, strong) GPUImageTempFilter *filter;

@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) GLKTextureInfo *textureInfo;

@end

@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];


    static const GLfloat squareVertices[] = {
        -0.5f, -0.5f,
        0.5f, -0.5f,
        -0.5f,  0.5f,
        0.5f,  0.5f,
    };
    
    static const GLfloat spriteTextureCoordinates[] = {
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
    };
    
    [[GPUImageContext sharedImageProcessingContext] useAsCurrentContext];
    self.image = [UIImage imageNamed:@"heart.png"];
    CGImageRef cgImage = self.image.CGImage;
    NSError *err;
    
    self.textureInfo = [GLKTextureLoader textureWithCGImage:cgImage
                                                    options:nil
                                                      error:&err];
    
    self.videoOut = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.videoOut];
    
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.videoCamera.horizontallyMirrorRearFacingCamera = YES;
    self.filter = [[GPUImageTempFilter alloc] init];
    
    __weak ViewController *weakSelf = self;
    self.filter.contextUpdateBlock = ^(GLint positionAttribute, GLint textureCoordinateAttribute, GLint inputTextureUniform) {
        glBindTexture(weakSelf.textureInfo.target, weakSelf.textureInfo.name);
        glUniform1i(inputTextureUniform, 2);
        glVertexAttribPointer(positionAttribute, 2, GL_FLOAT, 0, 0, squareVertices);
        glVertexAttribPointer(textureCoordinateAttribute, 2, GL_FLOAT, 0, 0, spriteTextureCoordinates);
    };
    
    [self.videoCamera addTarget:self.filter];
    [self.filter addTarget:self.videoOut];
    
    [self.videoCamera startCameraCapture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
