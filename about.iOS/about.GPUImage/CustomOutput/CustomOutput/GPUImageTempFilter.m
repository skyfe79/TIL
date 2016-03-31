//
//  GPUImageTempFilter.m
//  CustomOutput
//
//  Created by burt on 3/31/16.
//  Copyright © 2016 burt. All rights reserved.
//

#import "GPUImageTempFilter.h"
@import GLKit;

@interface GPUImageTempFilter()
//@property(nonatomic, strong) UIImage *image;
//@property(nonatomic, strong) GLKTextureInfo *textureInfo;
@end


@implementation GPUImageTempFilter
- (id) init {
    self = [super initWithFragmentShaderFromString:kGPUImagePassthroughFragmentShaderString];
    if(self) {
//        self.image = [UIImage imageNamed:@"heart.png"];
//        CGImageRef cgImage = self.image.CGImage;
//        NSError *err;
//        self.textureInfo = [GLKTextureLoader textureWithCGImage:cgImage
//                                                        options:nil
//                                                          error:&err];

    }
    return self;
}

- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates {
    
//    static const GLfloat squareVertices[] = {
//        -0.5f, -0.5f,
//        0.5f, -0.5f,
//        -0.5f,  0.5f,
//        0.5f,  0.5f,
//    };
//    
//    static const GLfloat spriteTextureCoordinates[] = {
//        0.0f, 0.0f,
//        1.0f, 0.0f,
//        0.0f, 1.0f,
//        1.0f, 1.0f,
//    };
//
    
    
    
    
    
    
}
@end
