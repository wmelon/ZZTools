//
//  AppDelegate.m
//  ZZToolsDemo
//
//  Created by 刘猛 on 2019/1/3.
//  Copyright © 2019 刘猛. All rights reserved.
//

#import "AppDelegate.h"
#import "ZZFPSButton.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor blackColor];[self.window makeKeyAndVisible];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    
    
    CGRect frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 34 + ([UIScreen mainScreen].bounds.size.height >= 812 ? 24 : 0), 80, 30);
    UIColor *btnBGColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    ZZFPSButton *btn = [ZZFPSButton setTouchWithFrame:frame titleFont:[UIFont systemFontOfSize:15] backgroundColor:btnBGColor backgroundImage:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.window addSubview:btn];
    });
    
    return YES;
}

@end
