//
//  NESPlayer.h
//  NESView
//
//  Created by Yoji Suzuki on 2018/02/17.
//  Copyright © 2018年 SUZUKI PLAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NESPlayer : NSObject
@property (nonatomic, readwrite) BOOL up;
@property (nonatomic, readwrite) BOOL down;
@property (nonatomic, readwrite) BOOL left;
@property (nonatomic, readwrite) BOOL right;
@property (nonatomic, readwrite) BOOL a;
@property (nonatomic, readwrite) BOOL b;
@property (nonatomic, readwrite) BOOL select;
@property (nonatomic, readwrite) BOOL start;
@end
