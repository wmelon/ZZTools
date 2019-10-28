//
//  UIView+ZZExtension.m
//  ZZToolsDemo
//
//  Created by 刘猛 on 2019/8/28.
//  Copyright © 2019年 刘猛. All rights reserved.
//

#import "ZZAutoLayout.h"
#import <Objc/runtime.h>
#import "UIView+ZZExtension.h"
#import "UIColor+ZZExtension.h"

static char GLAYER;

@interface UIView ()

@end

@implementation UIView (ZZExtension)

# pragma mark- 对外提供
- (UIImage *)zz_snapshot {
    if ([self isKindOfClass:[UIScrollView class]]) {
        return [self captureScrollView:(UIScrollView *)self];
    }
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);;
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    } else {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.layer renderInContext:context];
    }
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

///移除背景渐变色
- (void)zz_removeGradientLayer {
    [self.zz_gradientLayer removeFromSuperlayer];
}

///指定圆角
- (void)zz_setRoundCornerRadii:(CGFloat)radii position:(UIRectCorner)position {
    CGRect rect = self.bounds;
    UIRectCorner corners = position;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(radii, radii)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

///设置阴影
- (void)zz_setShadowWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 3;
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = NO;
    
}

///添加顶部模拟分割线
- (void)zz_addTopSplit:(NSString *)color height:(CGFloat)height alpha:(CGFloat)alpha leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin {
    
    UIView *bottomLine = [[UIView alloc] init];[self addSubview:bottomLine];
    bottomLine.sd_layout.topEqualToView(self)
    .leftSpaceToView(self, leftMargin)
    .rightSpaceToView(self, rightMargin)
    .heightIs(height);
    bottomLine.backgroundColor = [UIColor zz_colorWithCSS:color];
    bottomLine.alpha = alpha;
    
}

///添加底部模拟分割线
- (void)zz_addBottomSplit:(NSString *)color height:(CGFloat)height alpha:(CGFloat)alpha leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin {
    
    UIView *bottomLine = [[UIView alloc] init];[self addSubview:bottomLine];
    bottomLine.sd_layout.bottomEqualToView(self)
    .rightSpaceToView(self, rightMargin)
    .leftSpaceToView(self, leftMargin)
    .heightIs(height);
    bottomLine.backgroundColor = [UIColor zz_colorWithCSS:color];
    bottomLine.alpha = alpha;
    
}

///渐变背景色
- (void)zz_insertGradientLayerWithBounds:(CGRect)bounds colorArray:(NSArray *)colorArray locations:(NSArray *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    
    CAGradientLayer *glayer = [[CAGradientLayer alloc] init];
    glayer.cornerRadius = self.layer.cornerRadius;
    NSMutableArray *cgColorArray = [[NSMutableArray alloc] init];
    for (NSString *string in colorArray) {
        id color;
        if ([string isKindOfClass:[NSString class]]) {
            color = (__bridge id)[UIColor zz_colorWithCSS:string].CGColor;
        } else {
            UIColor *cor = (UIColor *)string;
            color = (__bridge id)cor.CGColor;
        }
        [cgColorArray addObject:color];
    }
    glayer.colors = cgColorArray;
    glayer.locations = locations;
    glayer.startPoint = startPoint;
    glayer.endPoint = endPoint;
    glayer.frame = bounds;
    [self zz_removeGradientLayer];
    self.zz_gradientLayer = glayer;
    [self.layer insertSublayer:glayer atIndex:0];
    
}

# pragma mark- 私有方法
- (UIImage *)captureScrollView:(UIScrollView *)scrollView {
    
    UIImage* image = nil;
    
    //    UIGraphicsBeginImageContext(scrollView.contentSize);  默认
    
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, 0.0); {
        
        CGPoint savedContentOffset = scrollView.contentOffset;
        
        CGRect savedFrame = scrollView.frame;
        
        scrollView.contentOffset = CGPointZero;
        
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        
        scrollView.frame = savedFrame;
        
    }
    
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }
    
    return nil;
    
}

# pragma mark- set/get方法


- (CAGradientLayer *)zz_gradientLayer {
    return objc_getAssociatedObject(self, &GLAYER);
}
- (void)setZz_gradientLayer:(CAGradientLayer *)zz_gradientLayer {
    objc_setAssociatedObject(self, &GLAYER, zz_gradientLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)zz_x {
    return self.frame.origin.x;
}
- (void)setZz_x:(CGFloat)zz_x {
    CGRect frame = self.frame;
    frame.origin.x = zz_x;
    self.frame = frame;
}

- (CGFloat)zz_y {
    return self.frame.origin.y;
}
- (void)setZz_y:(CGFloat)zz_y {
    CGRect frame = self.frame;
    frame.origin.y = zz_y;
    self.frame = frame;
}

- (CGFloat)zz_centerX {
    return self.center.x;
}
- (void)setZz_centerX:(CGFloat)zz_centerX {
    CGPoint center = self.center;
    center.x = zz_centerX;
    self.center = center;
}

- (CGFloat)zz_centerY {
    return self.center.y;
}
- (void)setZz_centerY:(CGFloat)zz_centerY {
    CGPoint center = self.center;
    center.y = zz_centerY;
    self.center = center;
}

- (CGFloat)zz_width {
    return self.frame.size.width;
}
- (void)setZz_width:(CGFloat)zz_width {
    CGRect frame = self.frame;
    frame.size.width = zz_width;
    self.frame = frame;
}

- (CGFloat)zz_height {
    return self.frame.size.height;
}
- (void)setZz_height:(CGFloat)zz_height {
    CGRect frame = self.frame;
    frame.size.height = zz_height;
    self.frame = frame;
}


@end
