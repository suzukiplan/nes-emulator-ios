//
//  NESLayer.m
//  NESView
//
//  Created by 鈴木　洋司　 on 2018/02/26.
//  Copyright © 2018年 SUZUKI PLAN. All rights reserved.
//

#import "NESLayer.h"
#import <pthread.h>

#define VRAM_WIDTH 256
#define VRAM_HEIGHT 240

@interface NESLayer ()
@property (atomic) pthread_mutex_t mutex;
@property (atomic) CGContextRef img;
@property (assign) unsigned short* imgbuf;
@property (atomic) BOOL destroyed;
@end

@implementation NESLayer

+ (id)defaultActionForKey:(NSString*)key
{
    return nil;
}

- (id)init
{
    if (self = [super init]) {
        _destroyed = NO;
        pthread_mutex_init(&_mutex, NULL);
        _imgbuf = (unsigned short*)malloc(VRAM_WIDTH * VRAM_HEIGHT * 2);
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        _img = CGBitmapContextCreate(
            _imgbuf, VRAM_WIDTH, VRAM_HEIGHT, 5, VRAM_WIDTH * 2, colorSpace,
            kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder16Little);
        CFRelease(colorSpace);
    }
    return self;
}

- (void)lockVram
{
    if (_destroyed) {
        return;
    }
    pthread_mutex_lock(&_mutex);
}

- (unsigned short*)getVram
{
    return _imgbuf;
}

- (void)unlockVram
{
    if (_destroyed) {
        return;
    }
    pthread_mutex_unlock(&_mutex);
}

- (void)drawFrame
{
    if (_destroyed) {
        return;
    }
    [self lockVram];
    CGImageRef cgImage = CGBitmapContextCreateImage(_img);
    self.contents = (__bridge id)cgImage;
    [self unlockVram];
    CFRelease(cgImage);
}

- (UIImage*)capture
{
    if (_destroyed) {
        return nil;
    }
    CGImageRef cgImage = CGBitmapContextCreateImage(_img);
    if (!cgImage) {
        return nil;
    }
    UIImage* uiImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return uiImage;
}

- (void)destroy
{
    if (!_destroyed) {
        _destroyed = YES;
        CGContextRelease(_img);
        _img = nil;
        free(_imgbuf);
        _imgbuf = NULL;
        pthread_mutex_destroy(&_mutex);
    }
}

- (void)dealloc
{
    [self destroy];
}

@end
