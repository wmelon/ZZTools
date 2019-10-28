//
//  UIViewController+ZZExtension.m
//  ZZToolsDemo
//
//  Created by 刘猛 on 16/6/7.
//  Copyright © 2016年 刘猛. All rights reserved.
//

#import <objc/runtime.h>
#import "ZZScrollPageViewDelegate.h"
#import "UIViewController+ZZExtension.h"

char ZJIndexKey;

@implementation UIViewController (ZZExtension)

- (UIViewController *)zz_scrollViewController {
    UIViewController *controller = self;
    while (controller) {
        if ([controller conformsToProtocol:@protocol(ZZScrollPageViewDelegate)]) {
            break;
        }
        controller = controller.parentViewController;
    }
    return controller;
}

- (void)setZz_currentIndex:(NSInteger)zz_currentIndex {
    objc_setAssociatedObject(self, &ZJIndexKey, [NSNumber numberWithInteger:zz_currentIndex], OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)zz_currentIndex {
    return [objc_getAssociatedObject(self, &ZJIndexKey) integerValue];
}

@end
