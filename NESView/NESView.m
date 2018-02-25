//
//  NESView.m
//  NESView
//
//  Created by Yoji Suzuki on 2018/02/17.
//  Copyright © 2018年 SUZUKI PLAN. All rights reserved.
//

#import "NESView.h"

@interface NESView()
@property (nonatomic) CADisplayLink* displayLink;
@end

@interface NESLayer : CALayer
@property (weak) NESView* view;
@end

@implementation NESView

+ (Class) layerClass
{
    return [NESLayer class];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ([super initWithCoder:aDecoder]) {
        [self _init];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])!=nil) {
        [self _init];
    }
    return self;
}

- (void)_init
{
    self.opaque = NO;
    self.clearsContextBeforeDrawing = NO;
    self.multipleTouchEnabled = NO;
    self.userInteractionEnabled = NO;
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)dealloc
{
    [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (BOOL)loadRom:(NSData*)rom
{
    // TODO: need implement
    return NO;
}

- (void)tick:(NESKey*)key
{
    // TODO: need implement
}

- (void)ticks:(NSArray<NESKey*>*)keys
{
    // TODO: need implement
}

@end

@implementation NESLayer

static void* GameLoop(void* args)
{
    while(alive_flag) {
        while(event_flag) usleep(100);
        nes_vram_copy(imgbuf[bno]);
        event_flag = true;
    }
    end_flag = true;
    return NULL;
}

+(id)defaultActionForKey:(NSString *)key
{
    return nil;
}

- (id)init {
    if (self = [super init]) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        for(int i = 0; i < 2; i++) {
            img[i] = CGBitmapContextCreate(imgbuf[i],
                                           VRAM_WIDTH,
                                           VRAM_HEIGHT,
                                           5,
                                           VRAM_WIDTH * 2,
                                           colorSpace,
                                           kCGImageAlphaNoneSkipFirst|
                                           kCGBitmapByteOrder16Little
                                           );
            if (!img[i]) NSLog(@"CREATE FAILED");
        }
        CFRelease(colorSpace);
        pthread_create(&tid, NULL, GameLoop, NULL);
        struct sched_param param;
        memset(&param,0,sizeof(param));
        param.sched_priority = 46;
        pthread_setschedparam(tid,SCHED_OTHER,&param);
    }
    return self;
}

- (void)orientationChanged:(NSNotification *)notification
{
}

- (void)display {
    while (!event_flag) usleep(100);
        bno = 1 - bno;
        event_flag = false;
        CGImageRef cgImage = CGBitmapContextCreateImage(img[1 - bno]);
        self.contents = (__bridge id)cgImage;
        CFRelease(cgImage);
        [self.view.delegate gameScreenDidUpdate];
}

- (void)dealloc
{
    alive_flag = false;
    while (!end_flag) usleep(100);
        for (int i = 0; i < 2; i++) {
            if (img[i]) {
                CFRelease(img[i]);
                img[i] = nil;
            }
        }
}

@end
