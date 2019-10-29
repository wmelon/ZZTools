//
//  UITextField+LYCommon.h
//  FanLi
//
//  Created by 刘猛 on 2019/8/29.
//  Copyright © 2019 nvZhuangWang. All rights reserved.
//
//  类别,具体用法查看具体公开方法的单独注释
//

#import <UIKit/UIKit.h>


typedef void(^TextFieldLeftOrRightViewButtonClicked)(UIButton *button);

@interface UITextField (ZZExtension)

/**是否可以获取验证码*/
@property (nonatomic, assign) BOOL allowGetCode;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic,   copy) TextFieldLeftOrRightViewButtonClicked leftButtonClick;

@property (nonatomic,   copy) TextFieldLeftOrRightViewButtonClicked rightButtonClick;

/**请传入字体大小,占位文字颜色,父视图*/
- (instancetype)initWithFont:(UIFont *)textFont placeholderColor:(NSString *)placeholderC superView:(UIView *)superView;

/**设置leftView,title和image只能传一个*/
- (UIButton *)zz_setLeftViewWithMargin:(CGFloat)leftMargin RightMargin:(CGFloat)rightMargin Title:(NSString *)title titleColor:(NSString *)titleColor OrImage:(id)image action:(TextFieldLeftOrRightViewButtonClicked)action;

/**设置leftView,title和image只能传一个,支持自定义font*/
- (UIButton *)zz_setLeftViewWithMargin:(CGFloat)leftMargin RightMargin:(CGFloat)rightMargin Title:(NSString *)title font:(UIFont *)font titleColor:(NSString *)titleColor OrImage:(id)image action:(TextFieldLeftOrRightViewButtonClicked)action;

/**设置rightView,title和image只能传一个*/
- (UIButton *)zz_setRightViewWithMargin:(CGFloat)leftMargin RightMargin:(CGFloat)rightMargin Title:(NSString *)title titleColor:(NSString *)titleColor OrImage:(id)image action:(TextFieldLeftOrRightViewButtonClicked)action;

/**设置image类型的rightView*/
- (UIButton *)zz_setRightViewWithMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin width:(CGFloat)width height:(CGFloat)height image:(id)image action:(TextFieldLeftOrRightViewButtonClicked)action;

/**获取验证码专用*/
- (UIButton *)zz_setGetCodeRightViewWithLeftMargin:(CGFloat)leftMargin RightMargin:(CGFloat)rightMargin width:(CGFloat)width Title:(NSString *)title titleColor:(NSString *)titleColor font:(CGFloat)font action:(TextFieldLeftOrRightViewButtonClicked)action;

- (UIButton *)zz_setGetCodeRightViewWithLeftMargin:(CGFloat)leftMargin RightMargin:(CGFloat)rightMargin width:(CGFloat)width height:(CGFloat)height Title:(NSString *)title titleColor:(NSString *)titleColor font:(CGFloat)font image:(NSString *)image highlightedImage:(NSString *)highlightedImage action:(TextFieldLeftOrRightViewButtonClicked)action;

/**重置获取验证码相关的东西*/
- (void)zz_resetGetCodeAbout;

/** 设置占位文字、字体大小、字体颜色 */
- (void)zz_setPlaceHolderString:(NSString *)string placeHolderFont:(UIFont *)font palceHolderColor:(UIColor *)color;

@end
