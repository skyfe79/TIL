//
//  GPUImageSpriteOverlayOutput.m
//  CustomOutput
//
//  Created by burt on 3/30/16.
//  Copyright © 2016 burt. All rights reserved.
//

#import "GPUImageSpriteOverlayOutput.h"
#import <YYImage/YYImage.h>

@import GLKit;

@interface GPUImageSpriteOverlayOutput()
{
    
    CGSize imageBufferSize;
    BOOL hasProcessedData;
    GLuint texture;
    dispatch_semaphore_t dataUpdateSemaphore;
    int index;
    NSTimeInterval lastTime;
    CVPixelBufferRef pixelBuffer;
    CVOpenGLESTextureCacheRef textureCache;
}
@property(nonatomic, strong) GLProgram* spriteProgram;
@property(nonatomic, readwrite) GLuint positionAttribute;
@property(nonatomic, readwrite) GLuint inputTextureCoordinateAttribute;
@property(nonatomic, readwrite) GLuint inputImageTextureUniform;
@property(nonatomic, strong) GLKTextureInfo *textureInfo;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) YYImageDecoder* decoder;

@end


@implementation GPUImageSpriteOverlayOutput
- (instancetype) initWithSize:(CGSize) size {
    self = [super init];
    if( self ) {
        imageBufferSize = size;
        hasProcessedData = NO;
        dataUpdateSemaphore = dispatch_semaphore_create(1);
        index = 0;
        lastTime = 0;
        
//        UIImage *image = [UIImage imageNamed:@"heart.png"];
//        CVImageBufferRef cvImageBufferRef = [self pixelBufferFromCGImage:image.CGImage];
//        
//        glActiveTexture(GL_TEXTURE4);
//        CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, [[GPUImageContext sharedImageProcessingContext], cvImageBufferRef, cvImageBufferRef, GL_TEXTURE_2D, GL_LUMINANCE, image.size.width, image.size.height, GL_BGRA, GL_UNSIGNED_BYTE, 0, &luminanceTextureRef);
        
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"a_dizzy" withExtension:@"webp"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        self.decoder = [YYImageDecoder decoderWithData:data scale:2.0];
        self.image = [UIImage imageNamed:@"heart.png"];
//        NSError *err = NULL;
//        CGImageRef cgImage = [[[self.decoder frameAtIndex:index decodeForDisplay:true] image] CGImage];
//        self.textureInfo = [GLKTextureLoader textureWithCGImage:cgImage
//                                                        options:nil
//                                                          error:&err];
//        glBindTexture(_textureInfo.target, _textureInfo.name);
    
        CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, [[GPUImageContext sharedImageProcessingContext] context], NULL, &textureCache);
        
        [self setupSpriteProgram];
        [self initFramebuffer];
        [self loadTexture:0];
    }
    return self;
}

- (void)setupSpriteProgram {

    GLProgram *program = [[GPUImageContext sharedImageProcessingContext] programForVertexShaderString:kGPUImageVertexShaderString fragmentShaderString:kGPUImagePassthroughFragmentShaderString];

    if ( program.initialized == NO ) {
        [program addAttribute:@"position"];
        [program addAttribute:@"inputTextureCoordinate"];
        
        if([program link] == NO) {
            NSString *progLog = [program programLog];
            NSLog(@"Program link log: %@", progLog);
            NSString *fragLog = [program fragmentShaderLog];
            NSLog(@"Fragment shader compile log: %@", fragLog);
            NSString *vertLog = [program vertexShaderLog];
            NSLog(@"Vertex shader compile log: %@", vertLog);
            program = nil;
            NSAssert(NO, @"Filter shader link failed");
        }
    }
    
    self.positionAttribute = [program attributeIndex:@"position"];
    self.inputTextureCoordinateAttribute = [program attributeIndex:@"inputTextureCoordinate"];
    self.inputImageTextureUniform = [program uniformIndex:@"inputImageTexture"];
    
    [GPUImageContext setActiveShaderProgram:program];
    
    glEnableVertexAttribArray(self.positionAttribute);
    glEnableVertexAttribArray(self.inputTextureCoordinateAttribute);
    
    self.spriteProgram = program;
}

-(void) initFramebuffer
{
    [GPUImageContext useImageProcessingContext];
    
    outputFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:imageBufferSize textureOptions:self.outputTextureOptions onlyTexture:YES];
    
    [outputFramebuffer disableReferenceCounting];
}

- (void)loadTexture:(int)frameIndex {
    
    //CGImageRef cgImage = [[[self.decoder frameAtIndex:frameIndex decodeForDisplay:YES] image] CGImage];
    CGImageRef cgImage = self.image.CGImage;
    pixelBuffer = [self pixelBufferFaster:cgImage];
    [self processNextFrame:pixelBuffer];
    
//    NSError *err = NULL;
//    
//    if(self.textureInfo != nil) {
//        GLuint name = self.textureInfo.name;
//        glDeleteTextures(1, &name);
//        self.textureInfo = nil;
//    }
//    CGImageRef cgImage = [[[self.decoder frameAtIndex:index decodeForDisplay:true] image] CGImage];
//    self.textureInfo = [GLKTextureLoader textureWithCGImage:cgImage
//                                                    options:nil
//                                                      error:&err];
//    glBindTexture(_textureInfo.target, _textureInfo.name);
//    [self drawImage];
//    index++;
//    if(index >= self.decoder.frameCount) {
//        index = 0;
//    }

    
}


- (void)processData {
    
    if( dispatch_semaphore_wait(dataUpdateSemaphore, DISPATCH_TIME_NOW) != 0) {
        return ;
    }
    
    hasProcessedData = YES;
    
    runAsynchronouslyOnVideoProcessingQueue(^{
        
        for(id<GPUImageInput> currentTarget in targets) {
            NSInteger indexOfObject = [targets indexOfObject:currentTarget];
            NSInteger textureIndexOfTarget = [[targetTextureIndices objectAtIndex:indexOfObject] integerValue];
            [currentTarget setInputSize:imageBufferSize atIndex:textureIndexOfTarget];
            [currentTarget setInputFramebuffer:outputFramebuffer atIndex:textureIndexOfTarget];
            [currentTarget newFrameReadyAtTime:kCMTimeIndefinite atIndex:textureIndexOfTarget];
        }
        dispatch_semaphore_signal(dataUpdateSemaphore);
    });
}

- (void)updateTexture {
    hasProcessedData = NO;
    
}



- (void) update:(CMTime)time {
    
    NSTimeInterval currentTime = CMTimeGetSeconds(time);
    NSTimeInterval elapsed = currentTime - lastTime;
    if( elapsed > [self.decoder frameDurationAtIndex:0] ){
    
        [self processData];
        [self loadTexture:index];
        
        index = index+1;
        if(index >= self.decoder.frameCount) {
            index = 0;
        }
        lastTime = currentTime;
    }
}


- (void)disposeFramebuffer {
    [outputFramebuffer enableReferenceCounting];
    [outputFramebuffer unlock];
}

- (void)drawImage:(GLuint)textureID {
    [GPUImageContext setActiveShaderProgram:self.spriteProgram];
    outputFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:imageBufferSize onlyTexture:NO];
    [outputFramebuffer activateFramebuffer];
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };
    
    static const GLfloat textureCoordinates[] = {
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
    };
    
    glActiveTexture(GL_TEXTURE4);
    glBindTexture(GL_TEXTURE_2D, textureID);
    glUniform1i(_inputImageTextureUniform, 4);
    
    glVertexAttribPointer(_positionAttribute, 2, GL_FLOAT, 0, 0, squareVertices);
    glVertexAttribPointer(_inputTextureCoordinateAttribute, 2, GL_FLOAT, 0, 0, textureCoordinates);
    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

}

- (void)dealloc {
    [self disposeFramebuffer];
}


- (void)processNextFrame:(CVPixelBufferRef)pb
{
    GLsizei textureWidth = (GLsizei)CVPixelBufferGetWidth(pb);
    GLsizei textureHeight = (GLsizei)CVPixelBufferGetHeight(pb);
    CVOpenGLESTextureRef textureRef = NULL;
    
    glActiveTexture(GL_TEXTURE4);
    if ([GPUImageContext supportsFastTextureUpload])
    {
        CVPixelBufferLockBaseAddress(pixelBuffer, 0);
        
        [GPUImageContext useImageProcessingContext];
        
        CVReturn err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                                    textureCache,
                                                                    pb,
                                                                    NULL,
                                                                    GL_TEXTURE_2D,
                                                                    GL_BGRA, // opengl format
                                                                    textureWidth,
                                                                    textureHeight,
                                                                    GL_RGBA, // native iOS format
                                                                    GL_UNSIGNED_BYTE,
                                                                    0,
                                                                    &textureRef);
        if (!textureRef || err)
        {
            NSLog(@"CVOpenGLESTextureCacheCreateTextureFromImage failed (error: %d)", err);
            return;
        }
        
        GLuint outputTexture = CVOpenGLESTextureGetName(textureRef);
        
        glBindTexture(GL_TEXTURE_2D, outputTexture);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        [self drawImage:outputTexture];
        
        CVPixelBufferUnlockBaseAddress(pb, 0);
        
        if (textureRef)
        {
            CFRelease(textureRef);
            textureRef = 0;
        }
        
        CVOpenGLESTextureCacheFlush(textureCache, 0);
        outputTexture = 0;
    }
    else
    {
//        CVPixelBufferLockBaseAddress(pixelBuffer, 0);
//        
//        glBindTexture(GL_TEXTURE_2D, outputTexture);
//        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, textureWidth, textureHeight, 0, GL_BGRA, GL_UNSIGNED_BYTE, CVPixelBufferGetBaseAddress(pixelBuffer));
//        
//        [self drawImage];
//        
//        
//        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    }
}

- (CVPixelBufferRef)pixelBufferFaster:(CGImageRef)image{
    
    CVPixelBufferRef pxbuffer = NULL;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    
    size_t width =  CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    size_t bytesPerRow = CGImageGetBytesPerRow(image);
    
    CFDataRef  dataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(image));
    GLubyte  *imageData = (GLubyte *)CFDataGetBytePtr(dataFromImageDataProvider);
    
    CVPixelBufferCreateWithBytes(kCFAllocatorDefault,width,height,kCVPixelFormatType_32BGRA,imageData,bytesPerRow,NULL,NULL,(__bridge CFDictionaryRef)options,&pxbuffer);
    
    CFRelease(dataFromImageDataProvider);
    
    return pxbuffer;
    
}

- (CVPixelBufferRef)pixelBufferFromCGImageWithPool:(CVPixelBufferPoolRef)pixelBufferPool image:(CGImageRef)image
{
    
    CVPixelBufferRef pxbuffer = NULL;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    
    size_t width =  CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    size_t bytesPerRow = CGImageGetBytesPerRow(image);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(image);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(image);
    void *pxdata = NULL;
    
    
    if (pixelBufferPool == NULL)
        NSLog(@"pixelBufferPool is null!");
    
    CVReturn status = CVPixelBufferPoolCreatePixelBuffer (NULL, pixelBufferPool, &pxbuffer);
    if (pxbuffer == NULL) {
        status = CVPixelBufferCreate(kCFAllocatorDefault, width,
                                     height, kCVPixelFormatType_32BGRA, (__bridge CFDictionaryRef) options,
                                     &pxbuffer);
    }
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    NSParameterAssert(pxdata != NULL);
    
    if(1){
        
        CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(pxdata, width,
                                                     height,bitsPerComponent,bytesPerRow, rgbColorSpace,
                                                     bitmapInfo);
        NSParameterAssert(context);
        CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
        CGContextDrawImage(context, CGRectMake(0, 0, width,height), image);
        CGColorSpaceRelease(rgbColorSpace);
        CGContextRelease(context);
    }else{
        
        
        CFDataRef  dataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(image));
        CFIndex length = CFDataGetLength(dataFromImageDataProvider);
        GLubyte  *imageData = (GLubyte *)CFDataGetBytePtr(dataFromImageDataProvider);
        memcpy(pxdata,imageData,length);
        
        CFRelease(dataFromImageDataProvider);
    }
    
    
    return pxbuffer;
    
}

@end
