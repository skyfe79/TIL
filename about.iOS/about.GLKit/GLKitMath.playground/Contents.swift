//: Playground - noun: a place where people can play

import UIKit
import GLKit

print(NSStringFromGLKMatrix4(GLKMatrix4Identity))
print(NSStringFromGLKMatrix4(GLKMatrix4MakeFromCATransform3D(CATransform3DIdentity)))
print(NSStringFromGLKMatrix4(GLKMatrix4MakeFromCGAffineTransform(CGAffineTransformIdentity)))

print(NSStringFromGLKMatrix4(GLKMatrix4MakeTranslation(99, 99, 0)))
print(NSStringFromGLKMatrix4(GLKMatrix4MakeFromCATransform3D(CATransform3DMakeTranslation(99, 99, 0))))
print(NSStringFromGLKMatrix4(GLKMatrix4MakeFromCGAffineTransform(CGAffineTransformMakeTranslation(99, 99))))

print(NSStringFromGLKMatrix4(GLKMatrix4MakeScale(99, 99, 1.0)))
print(NSStringFromGLKMatrix4(GLKMatrix4MakeFromCATransform3D(CATransform3DMakeScale(99, 99, 1.0))))
print(NSStringFromGLKMatrix4(GLKMatrix4MakeFromCGAffineTransform(CGAffineTransformMakeScale(99, 99))))


// z-rotation
print(NSStringFromGLKMatrix4(GLKMatrix4MakeRotation(Float(M_2_PI), 0.0, 0.0, 1.0)))
print(NSStringFromGLKMatrix4(GLKMatrix4MakeFromCATransform3D(CATransform3DMakeRotation(CGFloat(M_2_PI), 0.0, 0.0, 1.0))))
print(NSStringFromGLKMatrix4(GLKMatrix4MakeFromCGAffineTransform(CGAffineTransformMakeRotation(CGFloat(M_2_PI)))))




