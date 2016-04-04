//
//  SGGSprite.m
//  SGG
//
//  Created by burt on 2016. 3. 31..
//  Copyright © 2016년 BurtK. All rights reserved.
//

#import "SGGSprite.h"

typedef struct {
    CGPoint geometryVertex;
    CGPoint textureVertex;
} TexturedVertex;

typedef struct {
    TexturedVertex bl;
    TexturedVertex br;
    TexturedVertex tl;
    TexturedVertex tr;
} TexturedQuad;

@interface SGGSprite()

@property(strong) GLKBaseEffect *effect;
@property(assign) TexturedQuad quad;
@property(strong) GLKTextureInfo *textureInfo;

@end

@implementation SGGSprite
- (id)initWithFile:(NSString *)fileName effect:(GLKBaseEffect *)effect {
    
    self = [super init];
    if(self) {
        self.effect = effect;
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@YES, GLKTextureLoaderOriginBottomLeft, nil];
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        self.textureInfo = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
        if(self.textureInfo == nil) {
            return nil;
        }
        
        TexturedQuad newQuad;
        newQuad.bl.geometryVertex = CGPointMake(0, 0);
        newQuad.br.geometryVertex = CGPointMake(self.textureInfo.width, 0);
        newQuad.tl.geometryVertex = CGPointMake(0, self.textureInfo.height);
        newQuad.tr.geometryVertex = CGPointMake(self.textureInfo.width, self.textureInfo.height);
        
        newQuad.bl.textureVertex = CGPointMake(0, 0);
        newQuad.br.textureVertex = CGPointMake(1, 0);
        newQuad.tl.textureVertex = CGPointMake(0, 1);
        newQuad.tr.textureVertex = CGPointMake(1, 1);
        self.quad = newQuad;
    }
    return self;
}
- (void)render {
    // 1
    self.effect.texture2d0.name = self.textureInfo.name;
    self.effect.texture2d0.enabled = YES;
    
    // 2
    [self.effect prepareToDraw];
    
    // 3
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    
    // 4
    long offset = (long)&_quad;
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void *) (offset + offsetof(TexturedVertex, geometryVertex)));
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void *) (offset + offsetof(TexturedVertex, textureVertex)));
    
    // 5
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4); 
}
@end
