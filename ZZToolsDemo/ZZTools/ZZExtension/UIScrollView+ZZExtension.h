//
//  UIScrollView+ZZExtension.h
//  ZZToolsDemo
//
//  Created by 刘猛 on 2019/5/31.
//  Copyright © 2019 刘猛. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (ZZExtension)

# pragma mark- 对外提供的方法

///滚动到顶部, 无视偏移量!!!
- (void)zz_scrollToTopAnimated:(BOOL)animated;

/**
 * 设置指示器的颜色, 背景颜色, 圆角
 * originalMargin默认为3, 这个是微调的偏移量, 一试便知!
 */
- (void)zz_setIndicatorsColor:(UIColor *)indicatorsColor backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius;

/**
 * 设置指示器的颜色, 背景颜色, 圆角
 * originalMargin默认为3, 这个是微调的偏移量, 一试便知!
 */
- (void)zz_setIndicatorsColor:(UIColor *)indicatorsColor backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius originalMargin:(CGFloat)originalMargin;

@end

NS_ASSUME_NONNULL_END
