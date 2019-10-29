//
//  UIButton+ZZExtension.m
//  ZZExtensionDemo
//
//  Created by 刘猛 on 2019/9/3.
//  Copyright © 2019年 LY. All rights reserved.
//

#import "UIButton+ZZExtension.h"
#import "SDAutoLayout.h"
#import <objc/runtime.h>
#import "UIColor+ZZExtension.h"
#import "UIImage+ZZExtension.h"

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

static char ZZ_TEMPFONT;
static char ZZ_PLACELABEL;
static char ZZ_SELECTTIMES;
static char ZZ_CHANGEWIDTHWITHTEXT;

@interface UIButton()

@property (nonatomic, assign) UIFont        *tempFont;
@property (nonatomic, strong) UILabel       *placeLabel;

@end

@implementation UIButton (ZZExtension)

- (instancetype)initWithTitle:(NSString *)title titleColor:(NSString *)titleColor font:(UIFont *)font image:(id)image selectImage:(id)selectImage superView:(UIView *)superView {
    if (self == [super init]) {
        [superView addSubview:self];
        if (title) {[self setTitle:title forState:UIControlStateNormal];}
        //[self setTitle:title forState:UIControlStateSelected];
        //[self setTitle:title forState:UIControlStateHighlighted];
        if (titleColor.length > 0) {
            [self setTitleColor:[UIColor zz_colorWithCSS:titleColor] forState:UIControlStateNormal];
        } else {
            [self setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        }
        
        if (!font) {font = [UIFont systemFontOfSize:13];}self.titleLabel.font = font;
        
        //设置图片
        if ([image isKindOfClass:[UIImage class]]) {
            [self setImage:image forState:UIControlStateNormal];
            [self setImage:image forState:UIControlStateHighlighted];
        } else if([image isKindOfClass:[NSString class]]) {
            [self setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
        }
        //设置选中图片
        if ([selectImage isKindOfClass:[UIImage class]]) {
            [self setImage:selectImage forState:UIControlStateSelected];
        } else if([selectImage isKindOfClass:[NSString class]]) {
            [self setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
        }
        
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;

        self.tempFont = font;UIImage *img = self.imageView.image;
        if (!img && image != nil) {
            if([image isKindOfClass:[NSString class]]) {
                if ([image isEqualToString:@""]) {[self layoutIfNeeded];return self;}
            }
            NSLog(@"未正确设置图片,可能造成约束失败,图片可传入图片名或者UIImage");
        }
        [self zz_cancelHighlighted];[self layoutIfNeeded];
    }
    return self;
}

#pragma mark - 设置图文位置
- (void)zz_setImage2LeftWithMargin:(CGFloat)leftMargin centerMargin:(CGFloat)centerMargin title2RightWithMargin:(CGFloat)rightMargin {
    [self zz_setImage2LeftWithMargin:leftMargin centerMargin:centerMargin title2RightWithMargin:rightMargin imageSize:self.imageView.image.size];
}

- (void)zz_setImage2LeftWithMargin:(CGFloat)leftMargin centerMargin:(CGFloat)centerMargin title2RightWithMargin:(CGFloat)rightMargin imageSize:(CGSize)imageSize {
    
    if (leftMargin >= 500) {
        self.titleLabel.sd_layout.rightSpaceToView(self, rightMargin).centerYEqualToView(self).heightRatioToView(self, 1);
        self.imageView.sd_layout.centerYEqualToView(self).widthIs(imageSize.width).heightIs(imageSize.height);
    } if (centerMargin >= 500) {
        self.imageView.sd_layout.leftSpaceToView(self, leftMargin).centerYEqualToView(self).widthIs(imageSize.width).heightIs(imageSize.height);
        self.titleLabel.sd_layout.rightSpaceToView(self, rightMargin).centerYEqualToView(self).heightRatioToView(self, 1);//.autoHeightRatio(0);
        [self.titleLabel setSingleLineAutoResizeWithMaxWidth:300];
    } else {
        self.imageView.sd_layout.leftSpaceToView(self, leftMargin).centerYEqualToView(self).widthIs(imageSize.width).heightIs(imageSize.height);
        self.titleLabel.sd_layout.leftSpaceToView(self.imageView, centerMargin).centerYEqualToView(self).heightRatioToView(self, 1);//.autoHeightRatio(0);
        [self.titleLabel setSingleLineAutoResizeWithMaxWidth:300];
    }

    if (!self.placeLabel) {
        self.placeLabel = [[UILabel alloc] init];[self addSubview:self.placeLabel];
        self.placeLabel.text = self.titleLabel.text;self.placeLabel.font = self.tempFont;
        self.placeLabel.sd_layout.leftEqualToView(self.titleLabel).centerYEqualToView(self).autoHeightRatio(0);
        [self.placeLabel setSingleLineAutoResizeWithMaxWidth:300];self.placeLabel.alpha = 0;
        if (leftMargin >= 500) {self.imageView.sd_layout.rightSpaceToView(self.placeLabel, centerMargin);}
    }
    
    if (rightMargin >= 500 || centerMargin >= 500 || leftMargin >= 500) {return;}//如果右间距大于等于500则不自适应宽度

    [self setupAutoWidthWithRightView:self.zz_changeWidthWithText ? self.titleLabel : self.placeLabel rightMargin:rightMargin];
}

- (void)zz_setImage2FullAndTitle2Center {
    
    self.imageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.titleLabel.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}

- (void)zz_setImage2RightWithMargin:(CGFloat)rightMargin centerMargin:(CGFloat)centerMargin title2LeftWithMargin:(CGFloat)leftMargin {
    //NSLog(@"self.imageView.image === %@",self.imageView.image);
    UIImage *currentImage = self.imageView.image;
    
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:300];
    
    if (!self.placeLabel) {
        self.placeLabel = [[UILabel alloc] init];
        [self addSubview:self.placeLabel];
        self.placeLabel.text = self.titleLabel.text;
        self.placeLabel.font = self.tempFont;
        if (leftMargin < 500 && centerMargin < 500) {
            self.titleLabel.sd_layout.leftSpaceToView(self, leftMargin).centerYEqualToView(self).autoHeightRatio(0);
        }
        self.placeLabel.sd_layout.leftEqualToView(self.titleLabel)
        .centerYEqualToView(self).autoHeightRatio(0);
        [self.placeLabel setSingleLineAutoResizeWithMaxWidth:300];
        self.placeLabel.alpha = 0;
    }
    
    if (leftMargin >= 500) {
        self.imageView.sd_layout.rightSpaceToView(self, rightMargin)
        .centerYEqualToView(self).widthIs(currentImage.size.width).heightIs(currentImage.size.height);
        
        self.titleLabel.sd_layout.rightSpaceToView(self.imageView, centerMargin)
        .centerYEqualToView(self).heightRatioToView(self, 1);return;
    } else if (centerMargin >= 500) {
        self.titleLabel.sd_layout.leftSpaceToView(self, leftMargin).centerYEqualToView(self).heightRatioToView(self, 1);
        self.imageView.sd_layout.rightSpaceToView(self, rightMargin).centerYEqualToView(self).
        widthIs(currentImage.size.width).heightIs(currentImage.size.height);
        return;
    } else {
        self.titleLabel.sd_layout.leftSpaceToView(self, leftMargin).centerYEqualToView(self).heightRatioToView(self, 1);
        self.imageView.sd_layout.leftSpaceToView(self.zz_changeWidthWithText ? self.titleLabel : self.placeLabel, centerMargin)
        .centerYEqualToView(self).widthIs(currentImage.size.width).heightIs(currentImage.size.height);
    }
    
    if (rightMargin >= 500) {return;}//如果右间距大于等于500则不自适应宽度
    
    [self setupAutoWidthWithRightView:self.imageView rightMargin:rightMargin];
}

- (void)zz_setImage2TopWithMargin:(CGFloat)topMargin title2BottomWithMargin:(CGFloat)bottomMargin {

    UIImage *img = self.imageView.image;if (!img) {
        NSLog(@"请先设置按钮图片");
        return;
    }
    
    if (UIScreen.mainScreen.bounds.size.width <= 320) {//如果是5s或者se尺寸的, 用二倍的图片, 但用一倍图的大小
        self.imageView.sd_layout.centerXEqualToView(self).topSpaceToView(self, topMargin).heightIs(img.size.height * 0.66667).widthIs(img.size.width * 0.66667);
    } else {
        self.imageView.sd_layout.centerXEqualToView(self).topSpaceToView(self, topMargin).heightIs(img.size.height).widthIs(img.size.width);
    }
    
    self.titleLabel.sd_layout.bottomSpaceToView(self, bottomMargin).autoHeightRatio(0).leftEqualToView(self).rightEqualToView(self);

    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}

- (void)zz_setImage2TopWithMargin:(CGFloat)topMargin title2BottomWithMargin:(CGFloat)bottomMargin imageSize:(CGSize)imageSize {
    
    //UIImage *img = self.imageView.image;if (!img) {return;}
    
    self.imageView.sd_layout.centerXEqualToView(self).topSpaceToView(self, topMargin).heightIs(imageSize.height).widthIs(imageSize.width);
    
    self.titleLabel.sd_layout.bottomSpaceToView(self, bottomMargin).autoHeightRatio(0).leftEqualToView(self).rightEqualToView(self);
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

}

- (void)zz_setImage2TopWithMargin:(CGFloat)topMargin centerMargin:(CGFloat)centerMargin title2BottomWithMargin:(CGFloat)bottomMargin {
    UIImage *img = self.imageView.image;if (!img) {
        NSLog(@"请先设置按钮图片");
        return;
    }
    
    if (UIScreen.mainScreen.bounds.size.width <= 320) {//如果是5s或者se尺寸的, 用二倍的图片, 但用一倍图的大小
        self.imageView.sd_layout.topSpaceToView(self, topMargin).centerXEqualToView(self).heightIs(img.size.height * 0.66667).widthIs(img.size.width * 0.66667);
    } else {
        self.imageView.sd_layout.topSpaceToView(self, topMargin).centerXEqualToView(self).heightIs(img.size.height).widthIs(img.size.width);
    }

    self.titleLabel.sd_layout.centerXEqualToView(self).topSpaceToView(self.imageView, centerMargin).autoHeightRatio(0);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:120];

    if (centerMargin >= 500 || bottomMargin >= 500) {
        return;
    }

    [self setupAutoHeightWithBottomView:self.titleLabel bottomMargin:bottomMargin];

}

- (void)zz_setTitle:(NSString *)title showLength:(int)length forState:(UIControlState)state {
    NSRange range= {0,length};//截取位置从索引2开始 截取3位长度的字符 包括索引为2对应的字符
    NSString *subStr = [title substringWithRange:range];
    NSString *showStr = [NSString stringWithFormat:@"%@...",subStr];
    [self setTitle:showStr forState:state];
}

#pragma mark - 属性set/get方法的实现
- (void)setPlaceLabel:(UILabel *)placeLabel {
    objc_setAssociatedObject(self, &ZZ_PLACELABEL, placeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UILabel *)placeLabel {
    return objc_getAssociatedObject(self, &ZZ_PLACELABEL);
}

- (void)setTempFont:(UIFont *)tempFont {
    objc_setAssociatedObject(self, &ZZ_TEMPFONT, tempFont, OBJC_ASSOCIATION_RETAIN);
}
- (UIFont *)tempFont {
    return objc_getAssociatedObject(self, &ZZ_TEMPFONT);
}

- (void)setZz_selectTimes:(int)zz_selectTimes {
    objc_setAssociatedObject(self, &ZZ_SELECTTIMES, @(zz_selectTimes), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (int)zz_selectTimes {
    NSNumber *i = objc_getAssociatedObject(self, &ZZ_SELECTTIMES);
    return i.intValue;
}

- (void)setZz_changeWidthWithText:(BOOL)zz_changeWidthWithText {
    int i = zz_changeWidthWithText ? 1 : 0;
    objc_setAssociatedObject(self, &ZZ_CHANGEWIDTHWITHTEXT, @(i), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)zz_changeWidthWithText {
    NSNumber *i = objc_getAssociatedObject(self, &ZZ_CHANGEWIDTHWITHTEXT);
    return i.intValue;
}

- (BOOL)canBecomeFirstResponder {return YES;}

#pragma mark -- 扩大点击范围
/** 可点击范围从按钮边缘向四个方向扩大的距离 */
- (void)setZz_enlargeEdge:(CGFloat)zz_enlargeEdge {
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:zz_enlargeEdge], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:zz_enlargeEdge], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:zz_enlargeEdge], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:zz_enlargeEdge], OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (CGFloat)zz_enlargeEdge {
    NSNumber *edge = objc_getAssociatedObject(self, &topNameKey);
    return edge.doubleValue;
}

/** 可点击范围从按钮边缘向四个方向扩大的距离 */
- (void)setEnlargeEdgeInsets:(UIEdgeInsets)insets {
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:insets.top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:insets.right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:insets.bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:insets.left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (UIEdgeInsets)enlargeEdgeInsets {
    NSNumber *topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber *leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    NSNumber *bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber *rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    
    return UIEdgeInsetsMake(topEdge.doubleValue, leftEdge.doubleValue, bottomEdge.doubleValue, rightEdge.doubleValue);
}

// pointInside:withEvent: 方法，扩大响应范围
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super pointInside:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? YES : NO;
}
- (CGRect)enlargedRect {
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge) {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    } else {
        return self.bounds;
    }
}

- (void)zz_cancelHighlighted {
    [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventAllTouchEvents];
}

- (void)btnClick:(UIButton *)btn {
    btn.highlighted = NO;
}

@end
