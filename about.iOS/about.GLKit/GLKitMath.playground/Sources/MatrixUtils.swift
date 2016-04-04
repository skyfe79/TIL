import Foundation
import GLKit



public func GLKMatrix4MakeFromCGAffineTransform(m : CGAffineTransform) -> GLKMatrix4 {
    
    let mm = CATransform3DMakeAffineTransform(m)
    return GLKMatrix4MakeFromCATransform3D(mm)
}

public func GLKMatrix4MakeFromCATransform3D(m : CATransform3D) -> GLKMatrix4 {
    return GLKMatrix4Make(
        Float(m.m11), Float(m.m12), Float(m.m13), Float(m.m14),
        Float(m.m21), Float(m.m22), Float(m.m23), Float(m.m24),
        Float(m.m31), Float(m.m32), Float(m.m33), Float(m.m34),
        Float(m.m41), Float(m.m42), Float(m.m43), Float(m.m44))
}

