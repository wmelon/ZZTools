//
//  NSObject+NSAttributedString.h
//  ShallBuyLife
//
//  Created by 刘猛 on 2018/12/10.
//  Copyright © 2018 刘猛. All rights reserved.
//
//  类别,具体用法查看具体公开方法的单独注释
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (ZZExtension)

/**
 获取富文本字符,所有数组的长度必须相等
 * @param textArr       字符串数组
 * @param textColors    颜色UIColor数组
 * @param textFonts     字体UIFont数组
 */
+ (NSAttributedString *)zz_getAttributedString:(NSArray *)textArr textColors:(NSArray<UIColor *> *)textColors textFonts:(NSArray<UIFont *> *)textFonts;

@end

NS_ASSUME_NONNULL_END
