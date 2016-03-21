//
//  ViewController.m
//  RenderImage
//
//  Created by burt on 3/21/16.
//  Copyright © 2016 burt. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
@property(nonatomic, strong) GPUImageView *imageView;
@property(nonatomic, strong) GPUImagePicture *picture;
@property(nonatomic, strong) GPUImageTransformFilter *transformFilter;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.imageView];

    self.picture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(
                                     128.0/CGRectGetWidth(self.view.bounds),
                                     128.0/CGRectGetWidth(self.view.bounds));
    
    self.transformFilter = [[GPUImageTransformFilter alloc] init];
    self.transformFilter.anchorTopLeft = false;
    [self.transformFilter setAffineTransform:transform];
    
    self.picture = [[GPUImagePicture alloc] initWithImage:[self.transformFilter imageByFilteringImage:[UIImage imageNamed:@"logo"]]];
    [self.picture addTarget:self.imageView];
    [self.picture processImage];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
