//
//  NESPlayer.h
//  NESView
//
//  Created by Yoji Suzuki on 2018/02/17.
//  Copyright © 2018年 SUZUKI PLAN. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MASK_A 1
#define MASK_B 2
#define MASK_SELECT 4
#define MASK_START 8
#define MASK_UP 16
#define MASK_DOWN 32
#define MASK_LEFT 64
#define MASK_RIGHT 128

@interface NESPlayer : NSObject
@property (nonatomic, readwrite) BOOL up;
@property (nonatomic, readwrite) BOOL down;
@property (nonatomic, readwrite) BOOL left;
@property (nonatomic, readwrite) BOOL right;
@property (nonatomic, readwrite) BOOL a;
@property (nonatomic, readwrite) BOOL b;
@property (nonatomic, readwrite) BOOL select;
@property (nonatomic, readwrite) BOOL start;
- (void)setCode:(NSInteger)code;
@end
