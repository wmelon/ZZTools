//
//  UIViewController+UIViewController_ZJScrollPageController.h
//  ZZToolsDemo
//
//  Created by 刘猛 on 16/6/7.
//  Copyright © 2016年 刘猛. All rights reserved.
//
#import <UIKit/UIKit.h>


@interface UIViewController (ZJScrollPageController)
/**
 *  所有子控制的父控制器, 方便在每个子控制页面直接获取到父控制器进行其他操作
 */
@property (nonatomic, weak, readonly) UIViewController *zz_scrollViewController;

@property (nonatomic, assign) NSInteger zz_currentIndex;




@end
