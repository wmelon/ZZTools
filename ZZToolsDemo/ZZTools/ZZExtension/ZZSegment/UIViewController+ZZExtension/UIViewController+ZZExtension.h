//
//  UIViewController+ZZExtension.h
//  ZZToolsDemo
//
//  Created by 刘猛 on 16/6/7.
//  Copyright © 2016年 刘猛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ZZExtension)

/**所有子控制的父控制器, 方便在每个子控制页面直接获取到父控制器进行其他操作*/
@property (nonatomic, weak, readonly) UIViewController      *zz_scrollViewController;

@property (nonatomic, assign) NSInteger                     zz_currentIndex;

@end

@interface UIView (ZZSegment)

@property (nonatomic, assign) CGFloat               zz_x;
@property (nonatomic, assign) CGFloat               zz_y;
@property (nonatomic, assign) CGFloat               zz_width;
@property (nonatomic, assign) CGFloat               zz_height;
@property (nonatomic, assign) CGFloat               zz_centerX;
@property (nonatomic, assign) CGFloat               zz_centerY;

@end
