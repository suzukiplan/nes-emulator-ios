//
//  CaptureImageViewController.m
//  Example
//
//  Created by Yoji Suzuki on 2018/03/04.
//  Copyright © 2018年 SUZUKI PLAN. All rights reserved.
//

#import "CaptureImageViewController.h"

@interface CaptureImageViewController ()

@end

@implementation CaptureImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView* bg = [[UIView alloc] initWithFrame:self.view.frame];
    bg.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
    [bg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)]];
    [self.view addSubview:bg];

    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat width = screenSize.width - 16;
    CGFloat x = (screenSize.width - width) / 2.0f;
    CGFloat height = width + 32;
    CGFloat y = (screenSize.height - height) / 2.0f;
    UIView* container = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    container.layer.cornerRadius = 4.0;
    container.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:container];

    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, width - 16, 16)];
    label.text = @"Captured image";
    label.font = [UIFont systemFontOfSize:14];
    [container addSubview:label];

    UIImageView* image = [[UIImageView alloc] initWithImage:_captureImage];
    image.frame = CGRectMake(8, 32, width - 16, (width - 16) / 16.0f * 15.0f);
    [container addSubview:image];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
