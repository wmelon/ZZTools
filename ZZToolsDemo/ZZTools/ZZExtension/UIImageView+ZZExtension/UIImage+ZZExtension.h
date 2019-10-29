//
//  UIImage+ZZExtension.h
//  ZZToolsDemo
//
//  Created by 刘猛 on 2019/12/26.
//  Copyright © 2019年 apple. All rights reserved.
//
//  类别,具体用法查看具体公开方法的单独注释
//

#import <UIKit/UIKit.h>

@interface UIImage (ZZExtension)

/**对图片进行毛玻璃效果(高斯模糊), blur取值0-100*/
- (UIImage *)zz_blurryWithBlurLevel:(CGFloat)blur;

- (UIImage *)zz_circleImage;

/** 图片格式，如@"gif"  */
- (NSString *)zz_getImageFormat;

/*图片压缩为不超过M大小的NSData数据*/
- (NSData *)zz_getDataWithMaxM:(CGFloat)M;

/**  UIColor转换UIimage */
+ (UIImage*)imageWithColor:(UIColor*)color;

/** 预留位置：处理图片，剪切，渲染等  */

@end
