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
    [(NESLayer*)self.layer drawFrame];
    [_delegate nesView:self didDetectVsyncWithFrameCount:_frameCount];
}

- (void)dealloc
{
    [self destroy];
}

- (void)destroy
{
    if (!_destroyed) {
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
    if (rom.length < 1) {
        return NO;
    }
    NESEmulator_loadRom(_context, rom.bytes, (size_t)rom.length);
    _frameCount = 0;
    return YES;
}

- (void)tick:(NESKey*)key
{
    NESEmulator_setPlaySpeed(_context, 1);
    NESEmulator_execFrame(_context, (int)key.code);
    _frameCount++;
    [self _copyVram];
}

- (void)ticks:(NSArray<NESKey*>*)keys count:(NSInteger)count
{
    NESEmulator_setPlaySpeed(_context, (int)count);
    for (NSInteger index = 0; index < count; index++) {
        NESEmulator_execFrame((void*)self.context, (int)keys[index].code);
        self.frameCount++;
    }
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
    [(NESLayer*)self.layer lockVram];
    NESEmulator_reset((void*)_context);
    [(NESLayer*)self.layer unlockVram];
}

- (nullable NSData*)saveState
{
    return nil; // TODO
}

- (BOOL)loadState:(nullable NSData*)state
{
    if (!state) {
        return NO;
    }
    return NESEmulator_setDump(_context, state.bytes, (size_t)state.length) ? NO : YES;
}

@end
