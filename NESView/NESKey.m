//
//  NESKey.m
//  NESView
//
//  Created by Yoji Suzuki on 2018/02/17.
//  Copyright © 2018年 SUZUKI PLAN. All rights reserved.
//

#import "NESKey.h"

@interface NESKey ()
@property (nonatomic, readwrite, strong, nonnull) NESPlayer* player1;
@property (nonatomic, readwrite, strong, nonnull) NESPlayer* player2;
@end

#define MASK_A 1
#define MASK_B 2
#define MASK_SELECT 4
#define MASK_START 8
#define MASK_UP 16
#define MASK_DOWN 32
#define MASK_LEFT 64
#define MASK_RIGHT 128

@implementation NESKey

- (instancetype)init
{
    if (self = [super init]) {
        _player1 = [[NESPlayer alloc] init];
        _player2 = [[NESPlayer alloc] init];
    }
    return self;
}

- (NSInteger)getCode
{
    NSInteger code1 = _player1.up ? MASK_UP : 0;
    code1 += _player1.down ? MASK_DOWN : 0;
    code1 += _player1.left ? MASK_LEFT : 0;
    code1 += _player1.right ? MASK_RIGHT : 0;
    code1 += _player1.a ? MASK_A : 0;
    code1 += _player1.b ? MASK_B : 0;
    code1 += _player1.select ? MASK_SELECT : 0;
    code1 += _player1.start ? MASK_START : 0;
    NSInteger code2 = _player2.up ? MASK_UP : 0;
    code2 += _player2.down ? MASK_DOWN : 0;
    code2 += _player2.left ? MASK_LEFT : 0;
    code2 += _player2.right ? MASK_RIGHT : 0;
    code2 += _player2.a ? MASK_A : 0;
    code2 += _player2.b ? MASK_B : 0;
    code2 += _player2.select ? MASK_SELECT : 0;
    code2 += _player2.start ? MASK_START : 0;
    return code1 + code2 * 256;
}

@end
