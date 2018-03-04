//
//  ViewController.m
//  Example
//
//  Created by Yoji Suzuki on 2018/03/03.
//  Copyright © 2018年 SUZUKI PLAN. All rights reserved.
//

#import "ViewController.h"
#import "CaptureImageViewController.h"
#import <NESView/NESView.h>

@interface ViewController () <NESViewDelegate>
@property (nonatomic) NESView* nesView;
@property (nonatomic) NSArray<NESKey*>* nesKeys;
@property (atomic) NSInteger playSpeed;
@property (nonatomic) NSData* state;
@property (nonatomic) UIImage* captureImage;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray* keys = [NSMutableArray arrayWithCapacity:8];
    for (int i = 0; i < 8; i++) {
        keys[i] = [[NESKey alloc] init];
    }
    self.nesKeys = keys;
    _playSpeed = 1;

    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    int position = 24;

    // Debug buttons (reset & capture)
    [self makeButtonWithRect:CGRectMake(8, position, 72, 32) title:@"RESET" action:@selector(reset)];
    [self makeButtonWithRect:CGRectMake(8 + 72 + 8, position, 88, 32) title:@"CAP:VIDEO" action:@selector(captureVideo)];
    [self makeButtonWithRect:CGRectMake(8 + 72 + 8 + 88 + 8, position, 88, 32) title:@"CAP:AUDIO" action:@selector(captureAudio)];
    position += 40;

    { // Debug buttons (change speed)
        int width = (screenSize.width - 8) / 8 - 8;
        for (int i = 0; i < 8; i++) {
            CGRect rect = CGRectMake(8 + i * (width + 8), position, width, 32);
            UIButton* button = [self makeButtonWithRect:rect
                                                  title:[NSString stringWithFormat:@"x%d", i + 1]
                                                 action:@selector(changeSpeed:)];
            button.tag = i + 1;
        }
    }
    position += 40;

    // Debug buttons (save & load state)
    [self makeButtonWithRect:CGRectMake(8, position, 100, 32) title:@"SAVE STATE" action:@selector(saveState)];
    [self makeButtonWithRect:CGRectMake(8 + 100 + 8, position, 100, 32) title:@"LOAD STATE" action:@selector(loadState)];
    position += 40;

    { // initialize and place the NESView
        int width = screenSize.width - 16;
        int height = (int)(width / 16.0 * 15);
        _nesView = [[NESView alloc] initWithFrame:CGRectMake(8, position, width, height)];
        _nesView.delegate = self;
        [self.view addSubview:_nesView];
        position += height + 8;
    }

    { // load a ROM file to the NESView
        NSURL* romURL = [[NSBundle mainBundle] URLForResource:@"example" withExtension:@"nes"];
        NSLog(@"rom: %@", romURL);
        NSData* romData = [NSData dataWithContentsOfFile:romURL.path];
        [_nesView loadRom:romData];
    }

    { // Debug buttons (controller - cursor)
        int width = (screenSize.width - 8) / 4 - 8;
        [self makeButtonWithRect:CGRectMake(8, position, width, 32) title:@"UP" actionDown:@selector(pushUp) actionUp:@selector(releaseUp)];
        [self makeButtonWithRect:CGRectMake(8 + (width + 8) * 1, position, width, 32) title:@"DOWN" actionDown:@selector(pushDown) actionUp:@selector(releaseDown)];
        [self makeButtonWithRect:CGRectMake(8 + (width + 8) * 2, position, width, 32) title:@"LEFT" actionDown:@selector(pushLeft) actionUp:@selector(releaseLeft)];
        [self makeButtonWithRect:CGRectMake(8 + (width + 8) * 3, position, width, 32) title:@"RIGHT" actionDown:@selector(pushRight) actionUp:@selector(releaseRight)];
    }
    position += 40;

    { // Debug buttons (controller - buttons)
        int width = (screenSize.width - 8) / 4 - 8;
        [self makeButtonWithRect:CGRectMake(8, position, width, 32) title:@"A" actionDown:@selector(pushA) actionUp:@selector(releaseA)];
        [self makeButtonWithRect:CGRectMake(8 + (width + 8) * 1, position, width, 32) title:@"B" actionDown:@selector(pushB) actionUp:@selector(releaseB)];
        [self makeButtonWithRect:CGRectMake(8 + (width + 8) * 2, position, width, 32) title:@"SELECT" actionDown:@selector(pushSelect) actionUp:@selector(releaseSelect)];
        [self makeButtonWithRect:CGRectMake(8 + (width + 8) * 3, position, width, 32) title:@"START" actionDown:@selector(pushStart) actionUp:@selector(releaseStart)];
    }
}

- (UIButton*)makeButtonWithRect:(CGRect)rect title:(NSString*)title action:(SEL)action
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = rect;
    button.layer.cornerRadius = 4.0;
    button.layer.borderColor = button.tintColor.CGColor;
    button.layer.borderWidth = 2.0;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

- (UIButton*)makeButtonWithRect:(CGRect)rect title:(NSString*)title actionDown:(SEL)actionDown actionUp:(SEL)actionUp
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = rect;
    button.layer.cornerRadius = 4.0;
    button.layer.borderColor = button.tintColor.CGColor;
    button.layer.borderWidth = 2.0;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:actionDown forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:actionUp forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:actionUp forControlEvents:UIControlEventTouchCancel];
    [self.view addSubview:button];
    return button;
}

- (void)nesView:(NESView*)nesView didDetectVsyncWithFrameCount:(NSInteger)frameCount
{
    NSInteger playSpeed = _playSpeed;
    if (1 == playSpeed) {
        [nesView tick:_nesKeys[0]];
    } else {
        NSInteger code = _nesKeys[0].code;
        for (int i = 1; i < playSpeed; i++) {
            [_nesKeys[i] setCode:code];
        }
        [nesView ticks:_nesKeys count:playSpeed];
    }
}

- (void)reset
{
    [_nesView reset];
}

- (void)captureVideo
{
    _captureImage = [_nesView capture];
    CaptureImageViewController* vc = [[CaptureImageViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.captureImage = _captureImage;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)captureAudio
{
    // TODO
}

- (void)changeSpeed:(UIButton*)sender
{
    NSLog(@"change speed: x%lu", sender.tag);
    _playSpeed = sender.tag;
}

- (void)saveState
{
    if (!(_state = [_nesView saveState])) {
        [self showErrorMessage:@"Failed saving state."];
    }
}

- (void)loadState
{
    if (![_nesView loadRom:_state]) {
        [self showErrorMessage:@"Failed loading state."];
    }
}

- (void)pushUp
{
    _nesKeys[0].player1.up = YES;
}

- (void)releaseUp
{
    _nesKeys[0].player1.up = NO;
}

- (void)pushDown
{
    _nesKeys[0].player1.down = YES;
}

- (void)releaseDown
{
    _nesKeys[0].player1.down = NO;
}

- (void)pushLeft
{
    _nesKeys[0].player1.left = YES;
}

- (void)releaseLeft
{
    _nesKeys[0].player1.left = NO;
}

- (void)pushRight
{
    _nesKeys[0].player1.right = YES;
}

- (void)releaseRight
{
    _nesKeys[0].player1.right = NO;
}

- (void)pushA
{
    _nesKeys[0].player1.a = YES;
}

- (void)releaseA
{
    _nesKeys[0].player1.a = NO;
}

- (void)pushB
{
    _nesKeys[0].player1.b = YES;
}

- (void)releaseB
{
    _nesKeys[0].player1.b = NO;
}

- (void)pushSelect
{
    _nesKeys[0].player1.select = YES;
}

- (void)releaseSelect
{
    _nesKeys[0].player1.select = NO;
}

- (void)pushStart
{
    _nesKeys[0].player1.start = YES;
}

- (void)releaseStart
{
    _nesKeys[0].player1.start = NO;
}

- (void)showErrorMessage:(NSString*)message
{
    UIAlertController* ctrl = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"Close"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction* action) {
                                                       [ctrl dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    [ctrl addAction:action];
    [self presentViewController:ctrl animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
