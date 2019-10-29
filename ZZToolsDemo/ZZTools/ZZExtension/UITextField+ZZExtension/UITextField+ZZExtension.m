//
//  UITextField+LYCommon.m
//  FanLi
//
//  Created by 刘猛 on 2019/8/29.
//  Copyright © 2019 nvZhuangWang. All rights reserved.
//

#import "ZZTimer.h"
#import "SDAutoLayout.h"
#import <objc/message.h>
#import "UIColor+ZZExtension.h"
#import "UIButton+ZZExtension.h"
#import "UITextField+ZZExtension.h"

#define AfW(x) (x / 375.0 * UIWidth)
#define UIWidth UIScreen.mainScreen.bounds.size.width
#define UIHeight UIScreen.mainScreen.bounds.size.height

static char LeftButtonClick;
static char RightButtonClick;

static char ZZ_NormalImage;
static char ZZ_HighlightedImage;
static char ZZ_RightButton;
static char ZZ_ALLOWGETCODE;
static char ZZ_Button;
static char ZZ_Title;

@interface UITextField ()

@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic,   copy) NSString *zz_normalImage;
@property (nonatomic,   copy) NSString *zz_highlightedImage;
/***/
@property (nonatomic,   copy) NSString *zz_title;

@end

@implementation UITextField (ZZExtension)

#pragma mark - 对外暴露方法的实现

- (instancetype)initWithFont:(UIFont *)textFont placeholderColor:(NSString *)placeholderC superView:(UIView *)superView {
    
    if (self == [super init]) {
        [superView addSubview:self];
        self.font = textFont;
        if (placeholderC.length > 5) {
            self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: [UIColor zz_colorWithCSS:placeholderC], NSFontAttributeName: textFont}];
        } else {
            self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName: textFont}];
        }
        
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    
    return self;
}

- (UIButton *)zz_setRightViewWithMargin:(CGFloat)leftMargin RightMargin:(CGFloat)rightMargin Title:(NSString *)title titleColor:(NSString *)titleColor OrImage:(id)image action:(TextFieldLeftOrRightViewButtonClicked)action {
    self.rightButtonClick = action;self.rightView = [[UIView alloc] init];
    self.rightView.backgroundColor = [UIColor clearColor];[self addSubview:self.rightView];
    self.rightView.sd_layout.rightEqualToView(self).topEqualToView(self).bottomEqualToView(self);
    
    UIButton *btn = [[UIButton alloc] initWithTitle:title titleColor:titleColor font:[UIFont systemFontOfSize:14] image:image selectImage:nil superView:self.rightView];
    btn.tag = 2;btn.zz_changeWidthWithText = YES;
    btn.sd_layout.leftEqualToView(self.rightView)
    .topEqualToView(self.rightView).bottomEqualToView(self.rightView);
    [btn addTarget:self action:@selector(btnClcik:) forControlEvents:UIControlEventTouchUpInside];
    
    if (title) {
        [btn zz_setImage2LeftWithMargin:leftMargin centerMargin:0 title2RightWithMargin:rightMargin];
    } else {
        [btn zz_setImage2RightWithMargin:rightMargin centerMargin:0 title2LeftWithMargin:leftMargin];
    }
    [self.rightView setupAutoWidthWithRightView:btn rightMargin:0];
    self.rightViewMode = UITextFieldViewModeAlways;
    
    return btn;
}

- (UIButton *)zz_setRightViewWithMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin width:(CGFloat)width height:(CGFloat)height image:(id)image action:(TextFieldLeftOrRightViewButtonClicked)action {
    self.rightButtonClick = action;self.rightView = [[UIView alloc] init];
    self.rightView.backgroundColor = [UIColor clearColor];[self addSubview:self.rightView];
    self.rightView.sd_layout.rightEqualToView(self).topEqualToView(self).bottomEqualToView(self);
    
    UIButton *btn = [[UIButton alloc] initWithTitle:@"" titleColor:@"333333" font:[UIFont systemFontOfSize:14] image:image selectImage:image superView:self.rightView];btn.tag = 2;
    btn.sd_layout.leftSpaceToView(self.rightView, leftMargin).centerYEqualToView(self.rightView).widthIs(width).heightIs(height);
    [btn addTarget:self action:@selector(btnClcik:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightView setupAutoWidthWithRightView:btn rightMargin:rightMargin];
    self.rightViewMode = UITextFieldViewModeAlways;
    
    return btn;
}

- (UIButton *)zz_setGetCodeRightViewWithLeftMargin:(CGFloat)leftMargin RightMargin:(CGFloat)rightMargin width:(CGFloat)width Title:(NSString *)title titleColor:(NSString *)titleColor font:(CGFloat)font action:(TextFieldLeftOrRightViewButtonClicked)action {
    
    self.rightButtonClick = action;self.rightView = [[UIView alloc] init];
    self.rightView.backgroundColor = [UIColor clearColor];[self addSubview:self.rightView];
    self.rightView.sd_layout.rightEqualToView(self).topEqualToView(self).bottomEqualToView(self);
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    self.zz_title = title;
    [self.rightView addSubview:btn];
    [btn setTitleColor:[UIColor zz_colorWithCSS:titleColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor zz_colorWithCSS:@"999999"] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    //[btn setBackgroundImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    
    btn.tag = 2;btn.zz_changeWidthWithText = YES;
    btn.sd_layout.leftEqualToView(self.rightView).widthIs(width)
    .bottomEqualToView(self.rightView)
    .topEqualToView(self.rightView);
    
    [btn addTarget:self action:@selector(getCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightView setupAutoWidthWithRightView:btn rightMargin:rightMargin];
    self.rightViewMode = UITextFieldViewModeAlways;
    self.allowGetCode = YES;
    return btn;
}

- (UIButton *)zz_setGetCodeRightViewWithLeftMargin:(CGFloat)leftMargin RightMargin:(CGFloat)rightMargin width:(CGFloat)width height:(CGFloat)height Title:(NSString *)title titleColor:(NSString *)titleColor font:(CGFloat)font image:(NSString *)image highlightedImage:(NSString *)highlightedImage action:(TextFieldLeftOrRightViewButtonClicked)action {
    
    self.rightButtonClick = action;self.rightView = [[UIView alloc] init];
    self.rightView.backgroundColor = [UIColor clearColor];[self addSubview:self.rightView];
    self.rightView.sd_layout.rightEqualToView(self).topEqualToView(self).bottomEqualToView(self);
    self.zz_normalImage = image;self.zz_highlightedImage = highlightedImage;
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    self.zz_title = title;
    [self.rightView addSubview:btn];
    [btn setTitleColor:[UIColor zz_colorWithCSS:titleColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor zz_colorWithCSS:@"999999"] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    //[btn setBackgroundImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    
    btn.tag = 2;btn.zz_changeWidthWithText = YES;
    btn.sd_layout.leftEqualToView(self.rightView).centerYEqualToView(self.rightView)
    .widthIs(width).heightIs(height);
    
    [btn addTarget:self action:@selector(getCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightView setupAutoWidthWithRightView:btn rightMargin:rightMargin];
    self.rightViewMode = UITextFieldViewModeAlways;
    self.allowGetCode = YES;
    return btn;
    
}

- (void)getCodeButtonClick:(UIButton *)btn {//获取验证码按钮的专属方法
    
    if (!self.allowGetCode) {return;}
    //if ([GHNetwork manage].netWorkstatus < 1) {[MBManager showBriefAlert:@"网络异常"];return;}
    btn.userInteractionEnabled = NO;
    [btn setBackgroundImage:nil forState:UIControlStateNormal];
    self.rightButton = btn;self.zz_title = self.rightButton.titleLabel.text;
    [[ZZTimer sharedManager] zz_cancelTimerWithName:@"封装的获取验证码"];
    [[ZZTimer sharedManager] zz_getGCDTimerWithName:@"封装的获取验证码" totalTime:60 frequency:1 queue:nil repeats:YES action:^(double pastTime, double remainingTime) {
        
        if ([[ZZTimer sharedManager] zz_isExist:@"封装的获取验证码"]) {
            NSString *title = [NSString stringWithFormat:@"%.0fs",remainingTime];
            [btn setTitle:title forState:(UIControlStateNormal)];
        }
        
        if (remainingTime <= 0) {
            [btn setTitle:self.zz_title forState:(UIControlStateNormal)];btn.userInteractionEnabled = YES;
            [btn setBackgroundImage:[UIImage imageNamed:self.zz_normalImage] forState:UIControlStateNormal];
        }
        
    }];
    
    if (self.rightButtonClick) {
        self.rightButtonClick(btn);
    }
    
}

- (void)zz_resetGetCodeAbout {
    [[ZZTimer sharedManager] zz_cancelTimerWithName:@"封装的获取验证码"];
    self.rightButton.selected = NO;
    [self.rightButton setTitle:self.zz_title forState:(UIControlStateNormal)];
    self.rightButton.userInteractionEnabled = YES;
    if (self.zz_normalImage) {
        [self.rightButton setBackgroundImage:[UIImage imageNamed:self.zz_normalImage] forState:UIControlStateNormal];
    }
}

- (UIButton *)zz_setLeftViewWithMargin:(CGFloat)leftMargin RightMargin:(CGFloat)rightMargin Title:(NSString *)title font:(UIFont *)font titleColor:(NSString *)titleColor OrImage:(id)image action:(TextFieldLeftOrRightViewButtonClicked)action {
    self.leftButtonClick = action;self.leftView = [[UIView alloc] init];
    self.leftView.backgroundColor = [UIColor clearColor];[self addSubview:self.leftView];
    self.leftView.sd_layout.leftEqualToView(self).topEqualToView(self).bottomEqualToView(self);
    
    UIButton *btn = [[UIButton alloc] initWithTitle:title titleColor:titleColor font:font image:image selectImage:image superView:self.leftView];
    btn.tag = 1;btn.zz_changeWidthWithText = YES;btn.titleLabel.font = font;
    btn.sd_layout.leftEqualToView(self.leftView)
    .topEqualToView(self.leftView).bottomEqualToView(self.leftView);
    [btn addTarget:self action:@selector(btnClcik:) forControlEvents:UIControlEventTouchUpInside];
    
    if (title) {
        [btn zz_setImage2LeftWithMargin:leftMargin centerMargin:0 title2RightWithMargin:rightMargin];
    } else {
        [btn zz_setImage2RightWithMargin:rightMargin centerMargin:0 title2LeftWithMargin:leftMargin];
    }
    [self.leftView setupAutoWidthWithRightView:btn rightMargin:0];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.button = btn;
    return btn;
}

- (UIButton *)zz_setLeftViewWithMargin:(CGFloat)leftMargin RightMargin:(CGFloat)rightMargin Title:(NSString *)title titleColor:(NSString *)titleColor OrImage:(id)image action:(TextFieldLeftOrRightViewButtonClicked)action {
    return [self zz_setLeftViewWithMargin:leftMargin RightMargin:rightMargin Title:title font:[UIFont systemFontOfSize:AfW(14)] titleColor:titleColor OrImage:image action:action];
}

- (void)btnClcik:(UIButton *)btn {
    if (btn.tag == 1) {
        if (self.leftButtonClick) {
            self.leftButtonClick(btn);
        }
    } else {
        if (self.rightButtonClick) {
            self.rightButtonClick(btn);
        }
    }
}

- (void)setLeftButtonClick:(TextFieldLeftOrRightViewButtonClicked)leftButtonClick {
    objc_setAssociatedObject(self, &LeftButtonClick, leftButtonClick, OBJC_ASSOCIATION_COPY);
}

- (TextFieldLeftOrRightViewButtonClicked)leftButtonClick {
    return objc_getAssociatedObject(self, &LeftButtonClick);
}

- (void)setRightButtonClick:(TextFieldLeftOrRightViewButtonClicked)rightButtonClick {
    objc_setAssociatedObject(self, &RightButtonClick, rightButtonClick, OBJC_ASSOCIATION_COPY);
}

- (TextFieldLeftOrRightViewButtonClicked)rightButtonClick {
    return objc_getAssociatedObject(self, &RightButtonClick);
}

- (void)setZz_normalImage:(NSString *)zz_normalImage {
    objc_setAssociatedObject(self, &ZZ_NormalImage, zz_normalImage, OBJC_ASSOCIATION_COPY);
}

- (NSString *)zz_normalImage {
    return objc_getAssociatedObject(self, &ZZ_NormalImage);
}

- (void)setZz_title:(NSString *)zz_title {
    objc_setAssociatedObject(self, &ZZ_Title, zz_title, OBJC_ASSOCIATION_COPY);
}

- (NSString *)zz_title {
    return objc_getAssociatedObject(self, &ZZ_Title);
}

- (void)setZz_highlightedImage:(NSString *)zz_highlightedImage {
    objc_setAssociatedObject(self, &ZZ_HighlightedImage, zz_highlightedImage, OBJC_ASSOCIATION_COPY);
}

- (NSString *)zz_highlightedImage {
    return objc_getAssociatedObject(self, &ZZ_HighlightedImage);
}

- (void)setRightButton:(UIButton *)rightButton {
    objc_setAssociatedObject(self, &ZZ_RightButton, rightButton, OBJC_ASSOCIATION_RETAIN);
}

- (UIButton *)rightButton {
    return objc_getAssociatedObject(self, &ZZ_RightButton);
}

- (void)setAllowGetCode:(BOOL)allowGetCode {
    objc_setAssociatedObject(self, &ZZ_ALLOWGETCODE, @(allowGetCode), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)allowGetCode {
    return [objc_getAssociatedObject(self, &ZZ_ALLOWGETCODE) boolValue];
}

- (void)setButton:(UIButton *)button {
    objc_setAssociatedObject(self, &ZZ_Button, button, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)button {
    return objc_getAssociatedObject(self, &ZZ_Button);
}

- (void)zz_setPlaceHolderString:(NSString *)string placeHolderFont:(UIFont *)font palceHolderColor:(UIColor *)color {
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:font , NSForegroundColorAttributeName:color}];
}

@end












