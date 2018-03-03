//
//  NESLayer.h
//  NESView
//
//  Created by 鈴木　洋司　 on 2018/02/26.
//  Copyright © 2018年 SUZUKI PLAN. All rights reserved.
//

#import "NESView.h"
#import <QuartzCore/QuartzCore.h>

@interface NESLayer : CALayer
@property (nonatomic, weak) NESView* nesView;
- (unsigned short*)getVram;
- (void)lockVram;
- (void)unlockVram;
- (void)drawFrame;
@end
