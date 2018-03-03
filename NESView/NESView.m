//
//  NESView.m
//  NESView
//
//  Created by Yoji Suzuki on 2018/02/17.
//  Copyright © 2018年 SUZUKI PLAN. All rights reserved.
//

#import "NESEmulator.h"
#import "NESLayer.h"
#import "NESView.h"

@interface NESView ()
@property (nonatomic) CADisplayLink* displayLink;
@property (assign) void* context;
@property (atomic) NSInteger frameCount;
@property (nonatomic) BOOL destroyed;
@end

@implementation NESView

+ (Class)layerClass
{
    return [NESLayer class];
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if ([super initWithCoder:aDecoder]) {
        [self _init];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]) != nil) {
        [self _init];
    }
    return self;
}

- (void)_init
{
    NSLog(@"initializing NESView");
    _context = NESEmulator_init();
    self.opaque = NO;
    self.clearsContextBeforeDrawing = NO;
    self.multipleTouchEnabled = NO;
    self.userInteractionEnabled = NO;
    ((NESLayer*)self.layer).nesView = self;
    _displayLink = [CADisplayLink displayLinkWithTarget:self
                                               selector:@selector(_detectVsync)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                       forMode:NSRunLoopCommonModes];
    _destroyed = NO;
}

- (void)_detectVsync
{
    [self setNeedsDisplay];
    [_delegate nesView:self didDetectVsyncWithFrameCount:_frameCount];
}

- (void)dealloc
{
    [self destroy];
}

- (void)destroy
{
    if (!_destroyed) {
        NSLog(@"terminating NESView");
        [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop]
                                forMode:NSDefaultRunLoopMode];
        _displayLink = nil;
        NESEmulator_deinit(_context);
        _context = NULL;
        _destroyed = YES;
    }
}

- (BOOL)loadRom:(NSData*)rom
{
    NSLog(@"loading rom: size = %lud", rom.length);
    NESEmulator_loadRom(_context, rom.bytes, rom.length);
    _frameCount = 0;
    return YES;
}

- (void)tick:(NESKey*)key
{
    NESEmulator_execFrame(_context, (int)key.code);
    _frameCount++;
    [self _copyVram];
}

- (void)ticks:(NSArray<NESKey*>*)keys
{
    [keys enumerateObjectsUsingBlock:^(NESKey* _Nonnull key, NSUInteger index,
                                       BOOL* _Nonnull stop) {
        NESEmulator_execFrame((void*)_context, (int)key.code);
        _frameCount++;
    }];
    [self _copyVram];
}

- (void)_copyVram
{
    [(NESLayer*)self.layer lockVram];
    unsigned short* vram = [(NESLayer*)self.layer getVram];
    NESEmulator_copyVram(_context, vram);
    [(NESLayer*)self.layer unlockVram];
}

- (void)reset
{
    NESEmulator_reset((void*)_context);
}

@end
