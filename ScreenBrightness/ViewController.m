//
//  ViewController.m
//  ScreenBrightness
//
//  Created by weekope on 2017/11/9.
//  Copyright © 2017年 weekope. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, assign) CGFloat brightnessIn;
@property (nonatomic, assign) CGFloat brightnessTo;
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(screenBrightnessChanging:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(screenBrightnessChanging:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    //调整屏幕亮度至指定数值
    [self screenBrightnessChangingToValue:1.0f];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSNotification *noti = [NSNotification notificationWithName:@"viewDidAppear" object:@(YES)];
    [self screenBrightnessChanging:noti];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSNotification *noti = [NSNotification notificationWithName:@"viewDidDisappear" object:@(NO)];
    [self screenBrightnessChanging:noti];
}

- (void)dealloc {
    [_timer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - changing screen brightness

- (void)screenBrightnessChangingToValue:(CGFloat)value {
    _brightnessTo = value;
}


#pragma mark - timer

- (void)screenBrightnessChanging:(NSNotification *)notification {
    if ([notification.name isEqualToString:UIApplicationWillResignActiveNotification]) {
        UIScreen.mainScreen.brightness = _brightnessIn;
        [_timer invalidate];
    }
    else if ([notification.name isEqualToString:UIApplicationDidBecomeActiveNotification]) {
        _brightnessIn = UIScreen.mainScreen.brightness;
        [_timer invalidate];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01f
                                                  target:self
                                                selector:@selector(timerChangeScreenBrightness:)
                                                userInfo:@(YES)
                                                 repeats:YES];
    }
    else {
        if ([notification.object boolValue]) {
            _brightnessIn = UIScreen.mainScreen.brightness;
        }
        [_timer invalidate];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01f
                                                  target:self
                                                selector:@selector(timerChangeScreenBrightness:)
                                                userInfo:notification.object
                                                 repeats:YES];
    }
}

- (void)timerChangeScreenBrightness:(NSTimer *)timer {
    if ([timer.userInfo boolValue]) {
        if (UIScreen.mainScreen.brightness >= _brightnessTo) {
            [timer invalidate];
        }
        else {
            UIScreen.mainScreen.brightness += 0.01f;
        }
    }
    else {
        if (UIScreen.mainScreen.brightness <= _brightnessTo) {
            [timer invalidate];
        }
        else {
            UIScreen.mainScreen.brightness -= 0.01f;
        }
    }
}

@end
