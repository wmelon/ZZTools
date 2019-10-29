//
//  UILabel+common.h
//  ZZToolsDemo
//
//  Created by 刘猛 on 2019/6/22.
//  Copyright © 2019 nvZhuangWang. All rights reserved.
//
//  类别,具体用法查看具体公开方法的单独注释
//

#import <UIKit/UIKit.h>

@interface UILabel (ZZExtension)

- (instancetype)initWithTextColor:(id)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment superView:(UIView *)superView;

/**计算label的高度*/
+ (CGFloat)zz_getLabelHeightWithMaxWidth:(CGFloat)widthText text:(NSString *)text font:(UIFont *)font;

/**计算label的宽度*/
+ (CGFloat)zz_getWidthWithString:(NSString *)textString height:(CGFloat)height font:(UIFont *)font;

/** 设置行间距 */
- (void)zz_setLineSpace:(CGFloat)space;

/**设置文字渐变*/
- (CAGradientLayer *)zz_setGradientTitle:(NSArray *)colorArray locations:(NSArray *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end
