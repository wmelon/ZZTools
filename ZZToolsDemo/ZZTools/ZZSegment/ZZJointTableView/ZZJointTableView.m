//
//  ZZJointTableView.m
//  ShallBuyLife
//
//  Created by 刘猛 on 2019/1/16.
//  Copyright © 2019 刘猛. All rights reserved.
//

#import "ZZJointTableView.h"

@implementation ZZJointTableView

/// 返回YES同时识别多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    //gestureRecognizer是当前类的实例滚动视图接受的事件
    //otherGestureRecognizer加载当前对象上的滚动视图接受事件的.
    
    //1.横向不处理
    if ([gestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)gestureRecognizer.view;
        if (scrollView.contentSize.width > scrollView.bounds.size.width) {
            return NO;
        }
    }
    
    //2.横向不处理
    if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)otherGestureRecognizer.view;
        if (scrollView.contentSize.width > scrollView.bounds.size.width) {
            return NO;
        }
    }
    
    //3.如果是特定的tag1000, 则不处理
    if (otherGestureRecognizer.view.tag == 1000 || gestureRecognizer.view.tag == 1000) {
        return NO;
    }

    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
    
}

@end
