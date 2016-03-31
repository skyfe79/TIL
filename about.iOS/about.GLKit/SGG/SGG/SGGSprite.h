//
//  SGGSprite.h
//  SGG
//
//  Created by burt on 2016. 3. 31..
//  Copyright © 2016년 BurtK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface SGGSprite : NSObject
- (id)initWithFile:(NSString *)fileName effect:(GLKBaseEffect *)effect;
- (void)render;
@end
