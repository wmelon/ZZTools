//
//  NSObject+NSAttributedString.m
//  ZZToolsDemo
//
//  Created by 刘猛 on 2018/12/10.
//  Copyright © 2018 刘猛. All rights reserved.
//

#import "UIColor+ZZExtension.h"
#import "NSAttributedString+ZZExtension.h"

@implementation NSAttributedString (ZZExtension)

+ (NSAttributedString *)zz_getAttributedString:(NSArray *)textArr textColors:(NSArray<UIColor *> *)textColors textFonts:(NSArray<UIFont *> *)textFonts  {
    
    if (textArr.count != textColors.count || textColors.count != textFonts.count) {
        NSLog(@"生成属性字符串时，传入的数组参数的count不一致");
        return nil;
    }
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    for (int i = 0; i < textArr.count; i ++) {
        NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:textArr[i] attributes:@ {NSForegroundColorAttributeName:textColors[i],NSFontAttributeName:textFonts[i]}];
        [result appendAttributedString:attrText];
    }
    
    return result;
}

@end
