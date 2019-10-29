//
//  UIButton+ZZExtension.h
//  ZZExtensionDemo
//
//  Created by 刘猛 on 2019/9/3.
//  Copyright © 2019年 LY. All rights reserved.
//
//  类别,具体用法查看具体公开方法的单独注释
//

#import <UIKit/UIKit.h>

@interface UIButton (ZZExtension)

/** 为yes时,按钮会根据图文自适应宽度 */
@property (nonatomic, assign) BOOL      zz_changeWidthWithText;

/**选中状态的选中次数*/
@property (nonatomic, assign) int       zz_selectTimes;

/** 扩大按钮点击范围 */
@property (nonatomic, assign) CGFloat   zz_enlargeEdge;

/**
 * 快捷的初始化方法
 */
- (instancetype _Nullable)initWithTitle:(NSString *_Nullable)title titleColor:(NSString *_Nullable)titleColor font:(UIFont *_Nullable)font image:(id _Nullable)image selectImage:(id _Nullable)selectImage superView:(UIView *_Nonnull)superView;

/**
 * 左图片右文字,自适应宽度(若rightMargin >= 500则不自适应宽度)
 * 若centerMargin>= 500则不自适应宽度且图片根据按钮适应
 * 若rightMargin >= 500则不自适应宽度
 */
- (void)zz_setImage2LeftWithMargin:(CGFloat)leftMargin centerMargin:(CGFloat)centerMargin title2RightWithMargin:(CGFloat)rightMargin;

- (void)zz_setImage2LeftWithMargin:(CGFloat)leftMargin centerMargin:(CGFloat)centerMargin title2RightWithMargin:(CGFloat)rightMargin imageSize:(CGSize)imageSize;

/**
 * 右图片左文字,自适应宽度(若rightMargin >= 500则不自适应宽度)
 * 若centerMargin>= 500则不自适应宽度且图片根据按钮适应
 * 若rightMargin >= 500则不自适应宽度
 */
- (void)zz_setImage2RightWithMargin:(CGFloat)rightMargin centerMargin:(CGFloat)centerMargin title2LeftWithMargin:(CGFloat)leftMargin;

/**上边图片,下边文字*/
- (void)zz_setImage2TopWithMargin:(CGFloat)topMargin title2BottomWithMargin:(CGFloat)bottomMargin;

/**上边图片,下边文字,图片宽高自己传*/
- (void)zz_setImage2TopWithMargin:(CGFloat)topMargin title2BottomWithMargin:(CGFloat)bottomMargin imageSize:(CGSize)imageSize;

/**上边图片,下边文字,按钮高度会自适应*/
- (void)zz_setImage2TopWithMargin:(CGFloat)topMargin centerMargin:(CGFloat)centerMargin title2BottomWithMargin:(CGFloat)bottomMargin;

/**禁用按钮的点击高亮*/
- (void)zz_cancelHighlighted;

/**设置为普通按钮...*/
- (void)zz_setImage2FullAndTitle2Center;

/**设置最多显示n个文字后为...*/
- (void)zz_setTitle:(NSString *_Nullable)title showLength:(int)length forState:(UIControlState)state;

@end













