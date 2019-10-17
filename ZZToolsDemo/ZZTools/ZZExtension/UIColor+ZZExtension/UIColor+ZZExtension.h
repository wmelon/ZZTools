//
//  UIColor+ZZExtension.h
//  ZZToolsDemo
//
//  Created by 刘猛 on 2019/8/28.
//  Copyright © 2019年 刘猛. All rights reserved.
//
//  类别,具体用法查看具体公开方法的单独注释
//

#import <UIKit/UIKit.h>

/**
 渐变方式
 - ZZGradientChangeDirectionLevel:              水平渐变
 - ZZGradientChangeDirectionVertical:           竖直渐变
 - ZZGradientChangeDirectionUpwardDiagonalLine: 向下对角线渐变
 - ZZGradientChangeDirectionDownDiagonalLine:   向上对角线渐变
 */
typedef NS_ENUM(NSInteger, ZZGradientChangeDirection) {
    ZZGradientChangeDirectionHorizontal,
    ZZGradientChangeDirectionVertical,
    ZZGradientChangeDirectionUpDiagonalLine,
    ZZGradientChangeDirectionDownDiagonalLine,
};

@interface UIColor (ZZExtension)

+ (UIColor*)zz_colorWithCSS:(NSString*)css;
+ (UIColor*)zz_colorWithHex:(NSUInteger)hex;

- (uint)zz_hex;
- (NSString*)zz_hexString;
- (NSString*)zz_cssString;

/**
 创建渐变颜色
 @param size       渐变的size
 @param direction  渐变方式
 @param startcolor 开始颜色
 @param endColor   结束颜色
 @return 创建的渐变颜色
 */
+ (UIColor *)zz_gradientColorWithSize:(CGSize)size direction:(ZZGradientChangeDirection)direction startColor:(UIColor *)startcolor endColor:(UIColor *)endColor;

/// 竖向渐变色。如果满足不了需要，请调用包含全部参数的方法
+ (UIColor *)zz_gradientColorWithSize:(CGSize)size colorArray:(NSArray<NSString *> *)colorArray;

@end
