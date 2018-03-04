//
//  NESPlayer.m
//  NESView
//
//  Created by Yoji Suzuki on 2018/02/17.
//  Copyright © 2018年 SUZUKI PLAN. All rights reserved.
//

#import "NESPlayer.h"

@implementation NESPlayer

- (instancetype)init
{
    return [super init];
}

- (void)setCode:(NSInteger)code
{
    _up = code & MASK_UP ? YES : NO;
    _down = code & MASK_DOWN ? YES : NO;
    _left = code & MASK_LEFT ? YES : NO;
    _right = code & MASK_RIGHT ? YES : NO;
    _a = code & MASK_A ? YES : NO;
    _b = code & MASK_B ? YES : NO;
    _select = code & MASK_SELECT ? YES : NO;
    _start = code & MASK_START ? YES : NO;
}

@end
