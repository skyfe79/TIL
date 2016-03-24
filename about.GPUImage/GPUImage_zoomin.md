```
+ (void)zoomInAndWriteToMovie:(UIImage*)image
{
    NSString* moviePath = @"output.mp4";
    NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject];
    NSURL* movieURL = [NSURL URLWithString:moviePath relativeToURL: [NSURL fileURLWithPath:documentPath isDirectory:YES]];
    GPUImageMovieWriter *movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(1280,720)];

    GPUImagePicture *imageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageTransformFilter *transformFilter = [[GPUImageTransformFilter alloc] init];
    [imageSource addTarget:transformFilter];

    [transformFilter addTarget:movieWriter];
    [movieWriter startRecording];

    const int totalFrames = 100;
    const float startZoomRatio = 1.2f;
    const float endZoomRatio = 1.0f;
    for (int i = 0; i < totalFrames; i++) {
        float currentZoomRatio = startZoomRatio + (endZoomRatio - startZoomRatio) * i / (float)totalFrames;
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(currentZoomRatio, currentZoomRatio);

        transformFilter.affineTransform = scaleTransform;
        imageSource.imageFrameTime = CMTimeMake(i, 30); // 30 FPS

        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [imageSource processImageWithCompletionHandler:^{
            dispatch_semaphore_signal(semaphore);
        }];

        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
                [[GPUImageContext sharedFramebufferCache] purgeAllUnassignedFramebuffers];
    [transformFilter removeTarget:movieWriter];

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [movieWriter finishRecordingWithCompletionHandler:^{
        dispatch_semaphore_signal(semaphore); // Force to wait for the completion, it might be causing bugs to continue without waiting.
    }];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [transformFilter removeAllTargets];
    [imageSource removeAllTargets];
}

```
