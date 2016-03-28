

import UIKit
import AVFoundation


public class AVFrameUtils {
    
    /**
     
     This creates an image generator from an asset,
     from which we can extract a CGImage near an iframe of the video.
     We’ll create our own time using CMTimeMake, setting it to the very beginning here.
     
     Then we’ll turn the CGImage into a more usable UIImage.
     Setting the appliesPreferredTrackTransform property to YES guarantees that the image is
     returned the correct way up, rather than rotated (which otherwise happens sometimes).
     
     */
     // extract to first frame
     // @see http://stackoverflow.com/questions/10221242/first-frame-of-a-video-using-avfoundation
    public static func firstFrame(url : NSURL) -> UIImage? {
        let asset = AVURLAsset(URL: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        do {
            let cgImage = try generator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil)
            return UIImage(CGImage: cgImage)
        } catch {
            return nil
        }
    }

    public static func extractAllFrameList(url: NSURL, countPerSecond : Int) -> [UIImage] {
        var frameList : [UIImage] = []
        let asset = AVURLAsset(URL: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        // extract count frames per second
        let videoDuration = asset.duration
        let seconds = CMTimeGetSeconds(videoDuration)
        let frameCountToExtract : Int64 = Int64(seconds * Float64(countPerSecond))
        let step : Int64 = videoDuration.value / frameCountToExtract
        
        var value : Int64 = 0
        for _ in 0..<frameCountToExtract {
            let frameGenerator = AVAssetImageGenerator(asset: asset)
            frameGenerator.requestedTimeToleranceAfter = kCMTimeZero
            frameGenerator.requestedTimeToleranceBefore = kCMTimeZero
            
            let time = CMTimeMake(value, videoDuration.timescale)
            
            do {
                let cgImage = try frameGenerator.copyCGImageAtTime(time, actualTime: nil)
                frameList.append(UIImage(CGImage: cgImage))
                value += step
            } catch {
                
            }
        }
        return frameList
    }
}