//
//  AppDelegate.h
//  Example
//
//  Created by Yoji Suzuki on 2018/03/03.
//  Copyright © 2018年 SUZUKI PLAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow* window;

@property (readonly, strong) NSPersistentContainer* persistentContainer;

- (void)saveContext;

@end
