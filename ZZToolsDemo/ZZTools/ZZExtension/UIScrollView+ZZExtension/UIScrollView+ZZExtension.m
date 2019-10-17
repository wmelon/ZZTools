//
//  UIScrollView+ZZExtension.m
//  ZZToolsDemo
//
//  Created by 刘猛 on 2019/5/31.
//  Copyright © 2019 刘猛. All rights reserved.
//

#import <objc/message.h>
#import "ZZPrivateHeader.h"
#import "UIScrollView+ZZExtension.h"

@interface UIScrollView ()

/**指示器的背景view*/
@property (nonatomic , strong) UIView   *indicatorsBgView;

@end

@implementation UIScrollView (ZZExtension)

# pragma mark- 对外提供的方法
- (void)zz_scrollToTopAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = 0 - self.contentInset.top;
    [self setContentOffset:off animated:animated];
}

- (void)zz_setIndicatorsColor:(UIColor *)indicatorsColor backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius {
    [self zz_setIndicatorsColor:indicatorsColor backgroundColor:backgroundColor cornerRadius:cornerRadius originalMargin:AfW(3)];
}

- (void)zz_setIndicatorsColor:(UIColor *)indicatorsColor backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius originalMargin:(CGFloat)originalMargin {
    for (UIImageView *imageView in self.subviews) {
        if ([imageView isKindOfClass:[UIImageView class]]) {
            
            // 直接让滚动条显示出来
            imageView.alpha = 1;
            imageView.image = nil;
            imageView.backgroundColor = indicatorsColor;
            [self flashScrollIndicators];
            
            //设置滚动条背景, 这里我是用水平滚动举例子, 如果是垂直的, 自行改变
            if (imageView.alpha != 1) {return;}//这一句很重要, 不要感觉没有用, 不要感觉下面不会执行!!!
            UIView *indicatorsBgView = [[UIView alloc] init];
            indicatorsBgView.backgroundColor = backgroundColor;
            [self insertSubview:indicatorsBgView atIndex:0];
            indicatorsBgView.frame = CGRectMake(self.scrollIndicatorInsets.left + AfW(3), imageView.frame.origin.y, self.frame.size.width - self.scrollIndicatorInsets.left - self.scrollIndicatorInsets.right - AfW(6), imageView.frame.size.height);
            self.indicatorsBgView = indicatorsBgView;
            
            //圆角
            imageView.layer.cornerRadius = cornerRadius;
            indicatorsBgView.layer.cornerRadius = cornerRadius;
            
        }
    }
}

@end
