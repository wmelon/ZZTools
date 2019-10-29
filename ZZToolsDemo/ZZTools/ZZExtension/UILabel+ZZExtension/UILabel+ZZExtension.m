//
//  UILabel+common.m
//  ZZToolsDemo
//
//  Created by 刘猛 on 2019/6/22.
//  Copyright © 2019 nvZhuangWang. All rights reserved.
//

#import "ZZPrivateHeader.h"
#import "UILabel+ZZExtension.h"
#import "UIColor+ZZExtension.h"

@implementation UILabel (ZZExtension)

- (instancetype)initWithTextColor:(id)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment superView:(UIView *)superView {
    if (self == [super init]) {
        [superView addSubview:self];
        if ([textColor isKindOfClass:[NSString class]]) {
            self.textColor = [UIColor zz_colorWithCSS:textColor];
        } else if ([textColor isMemberOfClass:[UIColor class]]) {
            self.textColor = textColor;
        }
        self.font = font;
        self.textAlignment = textAlignment;
    }
    return self;
}

- (instancetype)initWithBackgroundColor:(NSString *)background alpha:(CGFloat)alpha superView:(UIView *)superView {
    if (self == [super init]) {
        [superView addSubview:self];
        self.backgroundColor = [UIColor zz_colorWithCSS:background];
        self.alpha = alpha;
    }
    return self;
}

//- (NSAttributedString *)getAttStr:(NSArray *)textArr textColor:(NSArray *)textColor textFont:(NSArray<UIFont *> *)textFont {
//    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] init];
//    for (int i = 0; i < textArr.count; i ++) {
//        NSAttributedString *att = [[NSAttributedString alloc] initWithString:textArr[i] attributes:@ {NSForegroundColorAttributeName:textColor[i],NSFontAttributeName:textFont[i]}];
//        [attStr appendAttributedString:att];
//    }
//    return attStr;
//}

/**设置文字渐变*/
- (CAGradientLayer *)zz_setGradientTitle:(NSArray *)colorArray locations:(NSArray *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    
    if (self.frame.size.width <= 0.00001 && self.frame.size.height < 0.00001) {
        NSLog(@"给label的titl添加渐变色时, 请确定该label的frame已经被计算, 此次设置渐变色操作无效.");
        return [CAGradientLayer layer];
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.frame;
    NSMutableArray *cgColorArray = [[NSMutableArray alloc] init];
    for (NSString *string in colorArray) {
        id color = (__bridge id)[UIColor zz_colorWithCSS:string].CGColor;
        [cgColorArray addObject:color];
    }
    gradientLayer.colors = cgColorArray;
    gradientLayer.locations = locations;
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    [self.superview.layer addSublayer:gradientLayer];
    gradientLayer.mask = self.layer;
    self.frame = gradientLayer.bounds;
    
    return gradientLayer;
}

/**获取高度*/
+ (CGFloat)zz_getLabelHeightWithMaxWidth:(CGFloat)widthText text:(NSString *)text font:(UIFont *)font {
    
    //高度估计文本大概要显示几行，宽度根据需求自己定义。 MAXFLOAT 可以算出具体要多高
    CGSize size = CGSizeMake(widthText, CGFLOAT_MAX);
    
    //    获取当前文本的属性
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    
    //ios7方法，获取文本需要的size，限制宽度
    CGSize actualsize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
    
    return actualsize.height;
}

/**自适应宽度*/
+ (CGFloat)zz_getWidthWithString:(NSString *)textString height:(CGFloat)height font:(UIFont *)font {
    CGFloat width = [textString boundingRectWithSize:CGSizeMake(1000, height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@ {NSFontAttributeName:font} context:nil].size.width;
    return width;
}

- (void)zz_setLineSpace:(CGFloat)space {
    if (self.text.length > 0) {
        NSString *labelText = self.text;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:space];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        self.attributedText = attributedString;
        [self sizeToFit];
    }
}

@end









