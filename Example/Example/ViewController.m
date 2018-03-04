//
//  ViewController.m
//  Example
//
//  Created by Yoji Suzuki on 2018/03/03.
//  Copyright © 2018年 SUZUKI PLAN. All rights reserved.
//

#import "ViewController.h"
#import <NESView/NESView.h>

@interface ViewController () <NESViewDelegate>
@property (nonatomic) NESView* nesView;
@property (nonatomic) NESKey* nesKey;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _nesKey = [[NESKey alloc] init];

    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    int position = 24;

    { // RESET button
        UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(8, position, 72, 32);
        button.layer.cornerRadius = 4.0;
        button.layer.borderColor = button.tintColor.CGColor;
        button.layer.borderWidth = 2.0;
        [button setTitle:@"RESET" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    position += 40;

    { // initialize and place the NESView
        int width = screenSize.width - 16;
        int height = (int)(width / 16.0 * 15);
        _nesView = [[NESView alloc] initWithFrame:CGRectMake(8, position, width, height)];
        _nesView.delegate = self;
        [self.view addSubview:_nesView];
    }

    { // load a ROM file to the NESView
        NSURL* romURL = [[NSBundle mainBundle] URLForResource:@"example" withExtension:@"nes"];
        NSLog(@"rom: %@", romURL);
        NSData* romData = [NSData dataWithContentsOfFile:romURL.path];
        [_nesView loadRom:romData];
    }
}

- (void)nesView:(NESView*)nesView didDetectVsyncWithFrameCount:(NSInteger)frameCount
{
    [nesView tick:_nesKey];
}

- (void)reset
{
    [_nesView reset];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
