//
//  AVFrameDrawer.h
//  AVSimpleEditoriOS
//
//  Created by malczak on 03/11/14.
//
//

#include <GPUImage/GPUImage.h>

@interface GPUImageVideoOverlayOutput : GPUImageOutput // based on GPUImageRawDataInput
{
    GPUPixelFormat pixelFormat;
    GPUPixelType   pixelType;
    CGSize uploadedImageSize;
    BOOL hasProcessedData;
    
    dispatch_semaphore_t dataUpdateSemaphore;
}

@property (nonatomic, copy) BOOL (^contextUpdateBlock)(CGContextRef context, CGSize size, CMTime time);

// initialization and teardown
-(id) initWithSize:(CGSize) size;
-(id) initWithSize:(CGSize) size contextInitailizeBlock:(void(^)(CGContextRef context, CGSize size)) contextInitializeBlock;

// data processing
-(void) processData;
-(CGSize) outputImageSize;
-(void)update:(CMTime)time;
@end
