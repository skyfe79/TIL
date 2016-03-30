//
//  GPUImageSpriteOverlayOutput.h
//  CustomOutput
//
//  Created by burt on 3/30/16.
//  Copyright © 2016 burt. All rights reserved.
//

#import <GPUImage/GPUImage.h>

@interface GPUImageSpriteOverlayOutput : GPUImageOutput
- (instancetype) initWithSize:(CGSize) size;
- (void) processData;
- (void) update:(CMTime)time;
@end
