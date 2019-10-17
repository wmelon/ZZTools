//
//  UIView+ZZExtension.h
//  FanLi
//
//  Created by 刘猛 on 2019/8/28.
//  Copyright © 2019年 刘猛. All rights reserved.
//
//  类别,具体用法查看具体公开方法的单独注释
//

#import <UIKit/UIKit.h>

@interface UIView (ZZExtension)

# pragma mark- 对外属性

@property (nonatomic, assign) CGFloat               zz_x;
@property (nonatomic, assign) CGFloat               zz_y;
@property (nonatomic, assign) CGFloat               zz_width;
@property (nonatomic, assign) CGFloat               zz_height;
@property (nonatomic, assign) CGFloat               zz_centerX;
@property (nonatomic, assign) CGFloat               zz_centerY;

/**被添加的渐变色*/
@property (nonatomic, strong) CAGradientLayer      *zz_gradientLayer;

# pragma mark- 对外方法

/**截图*/
- (UIImage *)zz_snapshot;

/**移除背景渐变色*/
- (void)zz_removeGradientLayer;

/**指定圆角*/
- (void)zz_setRoundCornerRadii:(CGFloat)radii position:(UIRectCorner)position;

/**设置阴影*/
- (void)zz_setShadowWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

/**添加顶部模拟分割线*/
- (void)zz_addTopSplit:(NSString *)color height:(CGFloat)height alpha:(CGFloat)alpha leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin;

/**给view一个底部的分割线*/
- (void)zz_addBottomSplit:(NSString *)color height:(CGFloat)height alpha:(CGFloat)alpha leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin;

/** 渐变背景色
  * @param bounds       view的bounds
  * @param colorArray   颜色string数组，如@[@"#FFFFFF",@"#F2F2F2"]
  * @param locations    如@[@0.0, @1.0];
  * @param startPoint   如CGPointMake(0, 0)
  * @param endPoint     如CGPointMake(1, 1)
 */
- (void)zz_insertGradientLayerWithBounds:(CGRect)bounds colorArray:(NSArray *)colorArray locations:(NSArray *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end
