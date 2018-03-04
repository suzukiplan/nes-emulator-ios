//
//  NESKey.h
//  NESView
//
//  Created by Yoji Suzuki on 2018/02/17.
//  Copyright © 2018年 SUZUKI PLAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NESView/NESPlayer.h>

@interface NESKey : NSObject
@property (nonatomic, readonly, strong, nonnull) NESPlayer* player1;
@property (nonatomic, readonly, strong, nonnull) NESPlayer* player2;
@property (nonatomic, readonly) NSInteger code;
- (void)setCode:(NSInteger)code;
@end
