//
//  ZZSuperVC.h
//  ZZToolsDemo
//
//  Created by 刘猛 on 2019/7/31.
//  Copyright © 2019 nvZhuangWang. All rights reserved.
//
//  控制器基类
//

#import <UIKit/UIKit.h>

// 导航栏风格, 不同的风格影响以下内容：默认的返回按钮图片，导航栏背景色，导航栏标题，左右按钮标题颜色
typedef NS_ENUM(NSUInteger, BaseNavigationBarStyle) {
    BaseNavigationBarStyleNormal,   //默认风格，F2F2F2
    BaseNavigationBarStyleWhite,     //白色
    BaseNavigationBarStyleClearWhiteContent, // 透明风格。白色标题
    BaseNavigationBarStyleClearBlackContent  // 透明风格。黑色标题
};

/** 控制器基类  */
@interface ZZSuperVC : UIViewController

#pragma mark - 通用设置

///是否允许侧滑返回，默认YES
@property (nonatomic, assign) BOOL                      popGestureEnable;

///期望的状态栏样式。原则是控制器只关系自己想展示什么样式，不需要管其他页面的效果
@property (nonatomic, assign) UIStatusBarStyle          statusBarStyle;

///路由传参统一使用该字典包装
@property (nonatomic, strong) NSMutableDictionary       *params;

///是否push过
@property (nonatomic, assign) BOOL                      isPushed;

///销毁当前导航控制器中的哪些页面，默认nil
@property (nonatomic, copy) NSArray<NSString *>         *removeClassArray;

///push后是否从导航控制器中移除本页面，默认NO
@property (nonatomic, assign) BOOL                      removeAfterPush;

#pragma mark - 导航栏
///自定义导航栏的样式
@property (nonatomic, assign) BaseNavigationBarStyle    barStyle;
///自定义的导航栏
@property (nonatomic, strong) UIImageView               *navView;
///是否隐藏自定义导航栏,默认NO
@property (nonatomic, assign) BOOL                      hideNavigationView;
///是否显示navView底部的线条,默认NO
@property (nonatomic, assign) BOOL                      showNavigationBottomLine;
///导航栏左按钮。默认显示返回按钮，默认goBack
@property (nonatomic, strong) UIButton                  *leftButton;
///导航栏标题按钮，设置self.title即可。默认无点击事件
@property (nonatomic, strong) UIButton                  *titleView;
///导航栏右按钮。默认rightButtonClick:
@property (nonatomic, strong) UIButton                  *rightButton;

# pragma mark- 子类重载方法
/** 返回到上级控制器 */
- (void)goBack;

/** 右边按钮的点击事件,空实现,可在子类中重写 */
- (void)rightButtonClick:(UIButton *)button;

/** 按钮绑定方法, 空实现, 子类重写时直接提示, 方便敲代码*/
- (void)buttonClick:(UIButton *)button;

@end
