//
//  ZZScrollView.m
//  ZZToolsDemo
//
//  Created by 刘猛 on 16/10/24.
//  Copyright © 2016年 刘猛. All rights reserved.
//

#import "ZZCollectionView.h"

@interface ZZCollectionView ()

@property (copy, nonatomic) ZZScrollViewShouldBeginPanGestureHandler gestureBeginHandler;

@end

@implementation ZZCollectionView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (_gestureBeginHandler && gestureRecognizer == self.panGestureRecognizer) {
        return _gestureBeginHandler(self, (UIPanGestureRecognizer *)gestureRecognizer);
    }
    else {
        return [super gestureRecognizerShouldBegin:gestureRecognizer];
    }
}

- (void)setupScrollViewShouldBeginPanGestureHandler:(ZZScrollViewShouldBeginPanGestureHandler)gestureBeginHandler {
    _gestureBeginHandler = [gestureBeginHandler copy];
}

@end
