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
    if (self.preventRendering)
    {
        [firstInputFramebuffer unlock];
        return;
    }
    
    [GPUImageContext setActiveShaderProgram:filterProgram];
    
    outputFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:[self sizeOfFBO] textureOptions:self.outputTextureOptions onlyTexture:NO];
    [outputFramebuffer activateFramebuffer];
    if (usingNextFrameForImageCapture)
    {
        [outputFramebuffer lock];
    }
    
    
    [self setUniformsForProgramAtIndex:0];
    
    glClearColor(backgroundColorRed, backgroundColorGreen, backgroundColorBlue, backgroundColorAlpha);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, [firstInputFramebuffer texture]);
    
    glUniform1i(filterInputTextureUniform, 2);
    glVertexAttribPointer(filterPositionAttribute, 2, GL_FLOAT, 0, 0, vertices);
    glVertexAttribPointer(filterTextureCoordinateAttribute, 2, GL_FLOAT, 0, 0, textureCoordinates);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    glActiveTexture(GL_TEXTURE2);
    
    if(self.contextUpdateBlock) {
        self.contextUpdateBlock(filterPositionAttribute, filterTextureCoordinateAttribute, filterInputTextureUniform);
    }
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glDisable(GL_BLEND);
    
    [firstInputFramebuffer unlock];
    
    if (usingNextFrameForImageCapture)
    {
        dispatch_semaphore_signal(imageCaptureSemaphore);
    }
}

@end
