//
//  NESView.h
//  NESView
//
//  Created by Yoji Suzuki on 2018/02/17.
//  Copyright © 2018年 SUZUKI PLAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NESView/NESKey.h>

//! Project version number for NESView.
FOUNDATION_EXPORT double NESViewVersionNumber;

//! Project version string for NESView.
FOUNDATION_EXPORT const unsigned char NESViewVersionString[];

NS_ASSUME_NONNULL_BEGIN

@interface NESView : UIView
- (BOOL)loadRom:(NSData*)rom;
- (void)tick:(NESKey*)key;
- (void)ticks:(NSArray<NESKey*>*)keys;
@end

NS_ASSUME_NONNULL_END
