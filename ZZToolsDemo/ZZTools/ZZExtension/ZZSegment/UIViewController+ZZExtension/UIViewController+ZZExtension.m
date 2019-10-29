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

@implementation UIView (ZZSegment)

- (CGFloat)zz_x {
    return self.frame.origin.x;
}
- (void)setZz_x:(CGFloat)zz_x {
    CGRect frame = self.frame;
    frame.origin.x = zz_x;
    self.frame = frame;
}

- (CGFloat)zz_y {
    return self.frame.origin.y;
}
- (void)setZz_y:(CGFloat)zz_y {
    CGRect frame = self.frame;
    frame.origin.y = zz_y;
    self.frame = frame;
}

- (CGFloat)zz_centerX {
    return self.center.x;
}
- (void)setZz_centerX:(CGFloat)zz_centerX {
    CGPoint center = self.center;
    center.x = zz_centerX;
    self.center = center;
}

- (CGFloat)zz_centerY {
    return self.center.y;
}
- (void)setZz_centerY:(CGFloat)zz_centerY {
    CGPoint center = self.center;
    center.y = zz_centerY;
    self.center = center;
}

- (CGFloat)zz_width {
    return self.frame.size.width;
}
- (void)setZz_width:(CGFloat)zz_width {
    CGRect frame = self.frame;
    frame.size.width = zz_width;
    self.frame = frame;
}

- (CGFloat)zz_height {
    return self.frame.size.height;
}
- (void)setZz_height:(CGFloat)zz_height {
    CGRect frame = self.frame;
    frame.size.height = zz_height;
    self.frame = frame;
}


@end
