//
//  OGLESObjects.m
//  RGBAShader
//
//  Created by Moses DeJong on 8/21/13.
//  This software has been placed in the public domain.

#import "OGLESObjects.h"
#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
// declaration for OGLESMappedTexture

@interface OGLESMappedTexture ()

@property (nonatomic, assign) uint32_t width;
@property (nonatomic, assign) uint32_t height;

@property (nonatomic, assign) uint32_t *baseAddress;

@property (nonatomic, assign) CVImageBufferRef bufferRef;

@property (nonatomic, assign) CVOpenGLESTextureCacheRef textureCacheRef;

@property (nonatomic, assign) CVOpenGLESTextureRef textureRef;

@property (nonatomic, retain) EAGLContext *context;

@end


@implementation OGLESMappedTexture

- (void) dealloc {
  NSAssert(self.baseAddress == NULL, @"OGLESMappedTexture deallocated with baseAddress still mapped into memory");
  
  self.baseAddress = NULL;
  self.textureRef = NULL;
  self.textureCacheRef = NULL;
  self.bufferRef = NULL;
  self.context = nil;
  
#if __has_feature(objc_arc)
#else
  [super dealloc];
#endif // objc_arc
}

+ (OGLESMappedTexture*) oGLESMappedTexture:(EAGLContext*)context
{
  OGLESMappedTexture *obj = [[OGLESMappedTexture alloc] init];
#if __has_feature(objc_arc)
#else
	obj = [obj autorelease];
#endif // objc_arc
  
  obj.context = context;
  return obj;
}

// Setters for CoreVideo object properties, these are not managed by ARC

- (void) setBufferRef:(CVImageBufferRef)inBufferRef
{
  if (inBufferRef) {
    CFRetain(inBufferRef);
  }
  if (_bufferRef) {
    CFRelease(_bufferRef);
  }
  _bufferRef = inBufferRef;
}

- (void) setTextureCacheRef:(CVOpenGLESTextureCacheRef)inTextureCacheRef
{
  if (inTextureCacheRef) {
    CFRetain(inTextureCacheRef);
  }
  if (_textureCacheRef) {
    CFRelease(_textureCacheRef);
  }
  _textureCacheRef = inTextureCacheRef;
}

- (void) setTextureRef:(CVOpenGLESTextureRef)inTextureRef
{
  if (inTextureRef) {
    CFRetain(inTextureRef);
  }
  if (_textureRef) {
    CFRelease(_textureRef);
  }
  _textureRef = inTextureRef;
}

// methods

// Util method to make a texture object that is mapped as user memory.
// Returns TRUE on success, FALSE if something went wrong.

- (BOOL) makeMappedTexture:(CGSize)dimensions
{
  CVImageBufferRef bufferRef = NULL;
  CVOpenGLESTextureRef textureCoreVideoTextureRef;
  CVOpenGLESTextureCacheRef textureCoreVideoTextureCacheRef;
  CVReturn cvRetval;
  
  uint32_t textureWidth = (uint32_t) dimensions.width;
  uint32_t textureHeight = (uint32_t) dimensions.height;
  self.width = textureWidth;
  self.height = textureHeight;
  
  int flatBytesPerRow = textureWidth * sizeof(uint32_t);
  
  NSNumber *rowAlignmentNumBytesNum;
  
  //rowAlignmentNumBytesNum = [NSNumber numberWithInt:bytesPerRow];
  // Align row to 16 byte bound
  rowAlignmentNumBytesNum = [NSNumber numberWithInt:16];
  
  NSDictionary *surfacePropertiesEmptyDict = [NSDictionary dictionary];
  NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                         surfacePropertiesEmptyDict, kCVPixelBufferIOSurfacePropertiesKey,
                         rowAlignmentNumBytesNum, kCVPixelBufferBytesPerRowAlignmentKey,
                         nil];
  
  CFDictionaryRef attrsRef;
  
#if __has_feature(objc_arc)
  attrsRef = (__bridge CFDictionaryRef) attrs;
#else
	attrsRef = (CFDictionaryRef) attrs;
#endif // objc_arc
  
  cvRetval = CVPixelBufferCreate(kCFAllocatorDefault,
                                 textureWidth,
                                 textureHeight,
                                 kCVPixelFormatType_32BGRA,
                                 attrsRef,
                                 &bufferRef);
  
  if (bufferRef == NULL) {
    NSLog(@"Error at CVPixelBufferCreate returned NULL %d", cvRetval);
    return FALSE;
  }
  
  if (cvRetval != kCVReturnSuccess) {
    NSLog(@"Error at CVPixelBufferCreate %d", cvRetval);
    return FALSE;
  }
  
  size_t bytesPerRowActual = CVPixelBufferGetBytesPerRow(bufferRef);
  assert(bytesPerRowActual != 0);
  assert(bytesPerRowActual >= flatBytesPerRow);
  
  // Use iOS 5.0 API to map the CoreVideo buffer into memory and configure
  // it as an OpenGL texture. Writing to the memory location will result
  // in the texture data being updated.
  
  CFDictionaryRef cacheAttributes = NULL;
  CFDictionaryRef textureAttributes = NULL;
  
  cvRetval = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault,
                                          cacheAttributes,
                                          self.context,
                                          textureAttributes,
                                          &textureCoreVideoTextureCacheRef);
  
  if (textureCoreVideoTextureCacheRef == NULL) {
    NSLog(@"Error at CVOpenGLESTextureCacheCreate returned NULL %d", cvRetval);
    return FALSE;
  }
  
  if (cvRetval != kCVReturnSuccess) {
    NSLog(@"Error at CVOpenGLESTextureCacheCreate %d", cvRetval);
    return FALSE;
  }
  
  cvRetval = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                          textureCoreVideoTextureCacheRef,
                                                          bufferRef,
                                                          NULL,
                                                          GL_TEXTURE_2D,
                                                          GL_RGBA,
                                                          textureWidth,
                                                          textureHeight,
                                                          GL_BGRA,
                                                          GL_UNSIGNED_BYTE,
                                                          0,
                                                          &textureCoreVideoTextureRef);
  
  if (textureCoreVideoTextureRef == NULL) {
    NSLog(@"Error at CVOpenGLESTextureCacheCreateTextureFromImage returned NULL %d", cvRetval);
    return FALSE;
  }
  
  if (cvRetval != kCVReturnSuccess) {
    NSLog(@"Error at CVOpenGLESTextureCacheCreateTextureFromImage %d", cvRetval);
    return FALSE;
  }
  
  // At this point, the texture should be allocated, but we do not actually need to lock
  // the memory yet.
  
  self.baseAddress = NULL;
  self.bufferRef = bufferRef;
  self.textureCacheRef = textureCoreVideoTextureCacheRef;
  self.textureRef = textureCoreVideoTextureRef;

  // Release refs
  CFRelease(bufferRef);
  CFRelease(textureCoreVideoTextureCacheRef);
  CFRelease(textureCoreVideoTextureRef);
  
  return TRUE;
}

- (void) bindTexture
{
  CVOpenGLESTextureRef textureRef = self.textureRef;
  glBindTexture(CVOpenGLESTextureGetTarget(textureRef), CVOpenGLESTextureGetName(textureRef));
}

- (BOOL) lockTexture
{
  CVImageBufferRef bufferRef = self.bufferRef;
  uint32_t *baseAddress = self.baseAddress;
  //CVOpenGLESTextureRef textureRef = self.textureRef;
  CVReturn cvRetval;
  
  NSAssert(bufferRef != NULL, @"bufferRef is NULL");
  NSAssert(baseAddress == NULL, @"buffer already locked");
  
  cvRetval = CVPixelBufferLockBaseAddress(bufferRef, 0);
  if (cvRetval != kCVReturnSuccess) {
    NSLog(@"Error at CVPixelBufferLockBaseAddress %d", cvRetval);
    return FALSE;
  }
  
  int textureWidth = self.width;
  //int textureHeight = self.height;
  
  size_t bytesPerRow = CVPixelBufferGetBytesPerRow(bufferRef);
  assert(bytesPerRow != 0);
  assert(bytesPerRow >= textureWidth*sizeof(uint32_t));
  
  baseAddress = CVPixelBufferGetBaseAddress(bufferRef);
  if (baseAddress == NULL) {
    NSLog(@"Error at CVPixelBufferGetBaseAddress returned NULL");
    return FALSE;
  }
  
  self.baseAddress = baseAddress;
  
  return TRUE;
}

- (BOOL) unlockTexture
{
  CVReturn cvRetval;

  NSAssert(self.baseAddress != NULL, @"buffer should be locked when unlock is invoked");
  
  cvRetval = CVPixelBufferUnlockBaseAddress(self.bufferRef, 0);
  if (cvRetval != kCVReturnSuccess) {
    NSLog(@"Error at CVPixelBufferUnlockBaseAddress %d", cvRetval);
    return FALSE;
  }
  
  CVOpenGLESTextureCacheFlush(self.textureCacheRef, 0);
  
  self.baseAddress = NULL;
  
  return TRUE;
}

- (void) copyFlatPixelsIntoBuffer:(uint32_t*)pixels
{
  CVImageBufferRef bufferRef = self.bufferRef;
  uint32_t *baseAddress = self.baseAddress;
  
  const uint32_t width = CVPixelBufferGetWidth(bufferRef);
  const uint32_t maxNumRows = CVPixelBufferGetHeight(bufferRef);
  const uint32_t actualBytesPerRow = CVPixelBufferGetBytesPerRow(bufferRef);
  const uint32_t flatBytesPerRow = width * sizeof(uint32_t);
  
  for (int row = 0; row < maxNumRows; row++) {
    char *rowPtrDest = (char*)baseAddress + (row * actualBytesPerRow);
    char *rowPtrSrc = (char*)pixels + (row * flatBytesPerRow);
#if defined(DEBUG)
    uint32_t value;
    value = ((uint32_t*)rowPtrSrc)[0];
    value = ((uint32_t*)rowPtrSrc)[width - 1];
    ((uint32_t*)rowPtrDest)[0] = value;
    ((uint32_t*)rowPtrDest)[width - 1] = value;
#endif // DEBUG
    memcpy(rowPtrDest, rowPtrSrc, flatBytesPerRow);
  }
  
  return;
}

- (void) copyIntoFlatPixelsBuffer:(uint32_t*)pixels
{
  uint32_t textureWidth = self.width;
  uint32_t textureHeight = self.height;
  const uint32_t actualBytesPerRow = CVPixelBufferGetBytesPerRow(self.bufferRef);
  uint32_t *baseAddress = self.baseAddress;
  NSAssert(baseAddress, @"buffer has not locked the base address");
  
  //uint32_t *flatCopy = malloc(textureWidth * textureHeight * sizeof(uint32_t));
  NSAssert(pixels, @"pixels");

  for (int row = 0; row < textureHeight; row++) {
    uint32_t *dstRowAddress = (uint32_t*)pixels + (row * textureWidth);
    uint32_t *srcRowAddress = (uint32_t*)baseAddress + (row * actualBytesPerRow/sizeof(uint32_t));
    memcpy(dstRowAddress, srcRowAddress, textureWidth * sizeof(uint32_t));
  }
  
  return;
}


@end
