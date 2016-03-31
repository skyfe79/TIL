//
//  ViewController.m
//  SGG
//
//  Created by burt on 2016. 3. 31..
//  Copyright © 2016년 BurtK. All rights reserved.
//

#import "ViewController.h"
#import "SGGSprite.h"

@interface ViewController ()
@property(nonatomic, strong) EAGLContext *context;
@property (strong) GLKBaseEffect * effect;
@property (strong) SGGSprite * player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if(!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    [EAGLContext setCurrentContext:self.context];
    
    self.effect = [[GLKBaseEffect alloc] init];
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, 480, 0, 320, -1024, 1024);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    self.player = [[SGGSprite alloc] initWithFile:@"Player.png" effect:self.effect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(1, 1, 1, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    [self.player render];
}

- (void)update {
    
}

@end
