//
//  ZJScrollView.m
//  ZZToolsDemo
//
//  Created by 刘猛 on 16/10/24.
//  Copyright © 2016年 刘猛. All rights reserved.
//

#import "ZJCollectionView.h"


@interface ZJCollectionView ()
@property (copy, nonatomic) ZJScrollViewShouldBeginPanGestureHandler gestureBeginHandler;
@end
@implementation ZJCollectionView


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (_gestureBeginHandler && gestureRecognizer == self.panGestureRecognizer) {
        return _gestureBeginHandler(self, (UIPanGestureRecognizer *)gestureRecognizer);
    }
    else {
        return [super gestureRecognizerShouldBegin:gestureRecognizer];
    }
}

- (void)setupScrollViewShouldBeginPanGestureHandler:(ZJScrollViewShouldBeginPanGestureHandler)gestureBeginHandler {
    _gestureBeginHandler = [gestureBeginHandler copy];
}

@end
