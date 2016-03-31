//
//  GPUImageTempFilter.h
//  CustomOutput
//
//  Created by burt on 3/31/16.
//  Copyright © 2016 burt. All rights reserved.
//

#import "GPUImageFilter.h"
@interface GPUImageTempFilter : GPUImageFilter
@property (nonatomic, copy) void (^contextUpdateBlock)(GLint positionAttribute, GLint textureCoordinateAttribute, GLint inputTextureUniform);
@end
