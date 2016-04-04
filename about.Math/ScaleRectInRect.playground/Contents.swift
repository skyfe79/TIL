//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

//@see http://stackoverflow.com/questions/6278876/how-to-know-the-image-size-after-applying-aspect-fit-for-the-image-in-an-uiimage
func CGSizeAspectFit(aspectRatio : CGSize, boundingSize : CGSize) -> CGSize
{
    let mW : CGFloat = boundingSize.width / aspectRatio.width
    let mH : CGFloat = boundingSize.height / aspectRatio.height
    var newSize = boundingSize
    
    if mH < mW  {
        newSize.width = mH * aspectRatio.width
    } else if mW < mH  {
        newSize.height = mW * aspectRatio.height
    }
    return newSize
}

func CGSizeAspectFill(aspectRatio : CGSize, minimumSize : CGSize) -> CGSize
{
    let mW : CGFloat = minimumSize.width / aspectRatio.width;
    let mH : CGFloat = minimumSize.height / aspectRatio.height;
    var newSize = minimumSize
    if mH > mW {
        newSize.width = mH * aspectRatio.width
    } else if mW > mH {
        newSize.height = mW * aspectRatio.height
    }
    return newSize;
}

CGSizeAspectFit(CGSizeMake(480, 640), boundingSize: CGSizeMake(1000, 1000))
CGSizeAspectFill(CGSizeMake(480, 640), minimumSize: CGSizeMake(1000, 1000))


//@see https://gist.github.com/lanephillips/6874933
func ScaleToAspectFitRectInRect(rfit : CGRect, _ rtarget : CGRect) -> CGFloat
{
    // first try to match width
    let s : CGFloat = CGRectGetWidth(rtarget) / CGRectGetWidth(rfit);
    // if we scale the height to make the widths equal, does it still fit?
    if (CGRectGetHeight(rfit) * s <= CGRectGetHeight(rtarget)) {
        return s;
    }
    // no, match height instead
    return CGRectGetHeight(rtarget) / CGRectGetHeight(rfit);
}

func AspectFitRectInRect(rfit : CGRect, _ rtarget : CGRect) -> CGRect
{
    let s = ScaleToAspectFitRectInRect(rfit, rtarget);
    let w = CGRectGetWidth(rfit) * s;
    let h = CGRectGetHeight(rfit) * s;
    let x = CGRectGetMidX(rtarget) - w / 2;
    let y = CGRectGetMidY(rtarget) - h / 2;
    return CGRectMake(x, y, w, h);
}

func ScaleToAspectFitRectAroundRect(rfit : CGRect, _ rtarget : CGRect) -> CGFloat
{
    // fit in the target inside the rectangle instead, and take the reciprocal
    return 1 / ScaleToAspectFitRectInRect(rtarget, rfit);
}

func AspectFitRectAroundRect(rfit : CGRect, _ rtarget : CGRect) -> CGRect
{
    let s = ScaleToAspectFitRectAroundRect(rfit, rtarget);
    let w = CGRectGetWidth(rfit) * s;
    let h = CGRectGetHeight(rfit) * s;
    let x = CGRectGetMidX(rtarget) - w / 2;
    let y = CGRectGetMidY(rtarget) - h / 2;
    return CGRectMake(x, y, w, h);
}

AspectFitRectInRect(CGRectMake(100, 100, 370, 155), CGRectMake(200, 200, 300, 375))
AspectFitRectAroundRect(CGRectMake(100, 100, 370, 155), CGRectMake(200, 200, 300, 375))


let rect = CGRectMake(0, 0, 200, 100)
var roll : CGFloat = 180
CGRectApplyAffineTransform(rect, CGAffineTransformMakeRotation(fmod((90 + roll), 360) * CGFloat(M_PI)/180.0))
roll = 270
CGRectApplyAffineTransform(rect, CGAffineTransformMakeRotation(fmod((90 + roll), 360) * CGFloat(M_PI)/180.0))

let rect180 = CGRectMake(0.670694335616827, 0.5111582027228, 0.0244140625, 0.0244140625)
let rect270 = CGRectMake(0.623245116843645, 0.615251952810286, 0.01220703125, 0.048828125)



