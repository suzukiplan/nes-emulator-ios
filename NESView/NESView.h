//
//  NESView.h
//  NESView
//
//  Created by Yoji Suzuki on 2018/02/17.
//  Copyright © 2018年 SUZUKI PLAN. All rights reserved.
//

#import <NESView/NESKey.h>
#import <UIKit/UIKit.h>

//! Project version number for NESView.
FOUNDATION_EXPORT double NESViewVersionNumber;

//! Project version string for NESView.
FOUNDATION_EXPORT const unsigned char NESViewVersionString[];

NS_ASSUME_NONNULL_BEGIN

@class NESView;

@protocol NESViewDelegate <NSObject>
- (void)nesView:(NESView*)nesView
    didDetectVsyncWithFrameCount:(NSInteger)frameCount;
@end

@interface NESView : UIView
@property (nonatomic, weak) id<NESViewDelegate> delegate;
- (BOOL)loadRom:(NSData*)rom;
- (void)tick:(NESKey*)key;
- (void)ticks:(NSArray<NESKey*>*)keys count:(NSInteger)count;
- (void)reset;
- (void)destroy;
- (nullable NSData*)saveState;
- (BOOL)loadState:(nullable NSData*)state;
@end

NS_ASSUME_NONNULL_END
