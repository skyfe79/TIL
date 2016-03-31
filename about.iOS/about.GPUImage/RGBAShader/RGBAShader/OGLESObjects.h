//
//  OGLESObjects.h
//
//  Created by Moses DeJong on 8/21/13.
//  This software has been placed in the public domain.
//
//  This module contains a collection of useful OpenGL ES 2.0 objects that can be held
//  as NSObject derived references in an Objective-C class. Each object contains members
//  and functions for a specific task. While it is possible to directly create OpenGL
//  objects and operate on them, the logic can quickly get complex and hard to reuse.
//  This encapsulation makes it easier to operate on collections of OpenGL objects
//  by holding related references and functionality in specific classes.

#import <Foundation/Foundation.h>

@interface OGLESMappedTexture : NSObject

// The width and height members

@property (nonatomic, readonly) uint32_t width;
@property (nonatomic, readonly) uint32_t height;

// The pointer to the first row in the image data. Note that this
// base address is NULL unless the buffer is locked.

@property (nonatomic, readonly) uint32_t *baseAddress;

@property (nonatomic, readonly) CVImageBufferRef bufferRef;

@property (nonatomic, readonly) CVOpenGLESTextureCacheRef textureCacheRef;

@property (nonatomic, readonly) CVOpenGLESTextureRef textureRef;

// TRUE when the texture has been fully written and is ready to render with OpenGL.

@property (nonatomic, assign) BOOL isReady;

// Create an instance of a mapped texture cache object. This interface
// provides a way to render directly into an existing OpenGL texture
// by writing to memory from the main thread or from a secondary thread.
// The same texture object (memory range) is used over and over, this
// is really useful for a movie that contains N frames that are all the
// same size.

+ (OGLESMappedTexture*) oGLESMappedTexture:(EAGLContext*)context;

// This method is invoked to create the buffer and the associated
// texture objects. The caller must pass the size of the texture
// in pixels.

- (BOOL) makeMappedTexture:(CGSize)dimensions;

// To lock a texture is to map the texture into memory, the mapping starts
// at the memory address pointed to by baseAddress.

- (BOOL) lockTexture;

// To unlock a texture is to remove the mapping, so that the texture memory
// is ready to use in OpenGL.

- (BOOL) unlockTexture;

// Bind this texture to the current OpenGL context. The buffer should have been
// unlocked by the time it is bound. Note that a texture can be bound multiple
// times, typically a texture will be bound before rendering in each frame render.

- (void) bindTexture;

// This method provides a way to copy the pixels from a flat buffer (a buffer
// that has no row padding) into the CoreVideo buffer. It is not possible to
// copy a flat buffer of pixels with one big memcpy because of padding that
// can appear at the end of each row. Note that the width and height of the
// passed in buffer of pixels must already match the dimentions of the
// CoreVideo pixel buffer.

- (void) copyFlatPixelsIntoBuffer:(uint32_t*)pixels;

// This method will copy all the pixels in the CoreVideo buffer into a flat buffer.

- (void) copyIntoFlatPixelsBuffer:(uint32_t*)pixels;

@end
