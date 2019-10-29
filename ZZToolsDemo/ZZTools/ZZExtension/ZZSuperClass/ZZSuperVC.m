//
//  SuperVC.m
//  BossTravel
//
//  Created by 刘猛 on 2019/7/31.
//  Copyright © 2019 nvZhuangWang. All rights reserved.
//

#import "ZZSuperVC.h"
#import "ZZPrivateHeader.h"
#import "UIColor+ZZExtension.h"
#import "UINavigationController+ZZExtension.h"

@interface ZZSuperVC ()

@property (nonatomic, strong) UIView    *naviBottomLine;

@end

@implementation ZZSuperVC

# pragma mark- 生命周期
- (instancetype)init {
    if (self = [super init]) {
        
        // 默认设置
        self.hidesBottomBarWhenPushed = YES;
        if (@available(iOS 11.0, *)) {
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        self.popGestureEnable = YES;
        self.zz_prefersNavigationBarHidden = YES;
        // 默认导航栏风格，要走set方法设置一下默认样式
        self.barStyle = BaseNavigationBarStyleWhite;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    if (@available(iOS 13.0, *)) {[self setOverrideUserInterfaceStyle:UIUserInterfaceStyleLight];}
    
    // 1.1 状态栏
    if ([self.params.allKeys containsObject:@"statusBarStyle"]) {
        self.statusBarStyle = [self.params[@"statusBarStyle"] integerValue];
    }
    
    // 1.2 导航栏
    if ([self.params.allKeys containsObject:@"hideNavigationView"]) {
        self.hideNavigationView = [self.params[@"hideNavigationView"] boolValue];
    }
    if (!self.hideNavigationView) {
        
        [self.view addSubview:self.navView];
        
        [self.navView addSubview:self.leftButton];
        [self.navView addSubview:self.titleView];
        [self.navView addSubview:self.rightButton];
        
        [self.navView addSubview:self.naviBottomLine];
        self.naviBottomLine.hidden = !self.showNavigationBottomLine;
        
        if ([self.params.allKeys containsObject:@"barStyle"]) {
            self.barStyle = [self.params[@"barStyle"] integerValue];
        }
        self.title = self.params[@"title"];
    }
    
    // 1.3 侧滑返回
    if ([self.params.allKeys containsObject:@"popGestureEnable"]) {
        self.popGestureEnable = [self.params[@"popGestureEnable"] boolValue];
    }
    
//    // 1.4 IQKeyboardManager
//    if ([self.params.allKeys containsObject:@"IQEnableAutoToolbar"]) {
//        self.IQEnableAutoToolbar = [self.params[@"IQEnableAutoToolbar"] boolValue];
//    }
//
//    self.IQEnableAutoToolbar = YES;
    
    // 2、默认设置，部分属性放在init方法设置
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([UIApplication sharedApplication].statusBarStyle != self.statusBarStyle) {
        [UIApplication sharedApplication].statusBarStyle = self.statusBarStyle;
    }
    
//    if ([IQKeyboardManager sharedManager].isEnableAutoToolbar != self.IQEnableAutoToolbar) {
//        [IQKeyboardManager sharedManager].enableAutoToolbar = self.IQEnableAutoToolbar;
//    }
    
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 从导航控制器的子控制器中 移除某些页面
    if (self.navigationController.viewControllers.count > 1) {
        
        NSMutableArray *vcArray = self.navigationController.viewControllers.mutableCopy;
        NSMutableArray *removeArray = [NSMutableArray array];
        
        for (UIViewController *vc in vcArray) {
            // 跳过当前控制器。只移除中间的页面
            if (vc == self) {
                continue;
            }
            
            // 移除的页面根据 当前页面的removeClassArray 和 每一个vc的removeAfterPush判断
            if (self.removeClassArray.count > 0 && [self.removeClassArray containsObject:NSStringFromClass([vc class])]) {
                [removeArray addObject:vc];
            } else if ([vc isKindOfClass:[ZZSuperVC class]]) {
                if (((ZZSuperVC *)vc).removeAfterPush) {
                    [removeArray addObject:vc];
                }
            }
        }
        
        // 是否有需要移除的页面
        if (removeArray.count > 0) {
            [vcArray removeObjectsInArray:removeArray];
            [self.navigationController setViewControllers:vcArray animated:NO];
        }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //if ([IQKeyboardManager sharedManager].enableAutoToolbar) {[IQKeyboardManager sharedManager].enableAutoToolbar = NO;}
    NSArray *viewControllers = self.navigationController.viewControllers;//获取当前的视图控制其
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {self.isPushed = YES;}
    [self.view endEditing:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@的对象被释放了(所属类名)", NSStringFromClass([self class]));
}

# pragma mark- 自定义导航栏
- (void)setBarStyle:(BaseNavigationBarStyle)barStyle {
    _barStyle = barStyle;
    
    switch (_barStyle) {
        case BaseNavigationBarStyleNormal:{
            
            self.statusBarStyle = UIStatusBarStyleDefault;
            self.navView.backgroundColor = [UIColor zz_colorWithCSS:@"#F2F2F2"];
            
            [self.leftButton setTitleColor:[UIColor zz_colorWithCSS:@"#333333"] forState:UIControlStateNormal];
            [self.leftButton setImage:[UIImage imageNamed:@"public_back_black"] forState:UIControlStateNormal];
            
            if (self.titleView && [self.titleView isKindOfClass:[UIButton class]]) {
                [self.titleView setTitleColor:[UIColor zz_colorWithCSS:@"#333333"] forState:UIControlStateNormal];
            }
            
            [self.rightButton setTitleColor:[UIColor zz_colorWithCSS:@"#333333"] forState:UIControlStateNormal];
            
            break;
        }
        case BaseNavigationBarStyleWhite:{
            
            self.statusBarStyle = UIStatusBarStyleDefault;
            self.navView.backgroundColor = [UIColor whiteColor];
            
            [self.leftButton setTitleColor:[UIColor zz_colorWithCSS:@"#333333"] forState:UIControlStateNormal];
            [self.leftButton setImage:[UIImage imageNamed:@"public_back_black"] forState:UIControlStateNormal];
            
            if (self.titleView && [self.titleView isKindOfClass:[UIButton class]]) {
                [self.titleView setTitleColor:[UIColor zz_colorWithCSS:@"#333333"] forState:UIControlStateNormal];
            }
            [self.rightButton setTitleColor:[UIColor zz_colorWithCSS:@"#333333"] forState:UIControlStateNormal];
            
            break;
        }
        case BaseNavigationBarStyleClearWhiteContent:{
            
            self.statusBarStyle = UIStatusBarStyleLightContent;
            self.navView.backgroundColor = [UIColor clearColor];
            
            [self.leftButton setTitleColor:[UIColor zz_colorWithCSS:@"#FFFFFF"] forState:UIControlStateNormal];
            [self.leftButton setImage:[UIImage imageNamed:@"public_back_white"] forState:UIControlStateNormal];
            
            if (self.titleView && [self.titleView isKindOfClass:[UIButton class]]) {
                [self.titleView setTitleColor:[UIColor zz_colorWithCSS:@"#FFFFFF"] forState:UIControlStateNormal];
            }
            
            [self.rightButton setTitleColor:[UIColor zz_colorWithCSS:@"#FFFFFF"] forState:UIControlStateNormal];
            
            break;
        }
        case BaseNavigationBarStyleClearBlackContent:{
            
            self.statusBarStyle = UIStatusBarStyleDefault;
            self.navView.backgroundColor = [UIColor clearColor];
            
            [self.leftButton setTitleColor:[UIColor zz_colorWithCSS:@"#333333"] forState:UIControlStateNormal];
            [self.leftButton setImage:[UIImage imageNamed:@"public_back_black"] forState:UIControlStateNormal];
            
            if (self.titleView && [self.titleView isKindOfClass:[UIButton class]]) {
                [self.titleView setTitleColor:[UIColor zz_colorWithCSS:@"#333333"] forState:UIControlStateNormal];
            }
            
            [self.rightButton setTitleColor:[UIColor zz_colorWithCSS:@"#333333"] forState:UIControlStateNormal];
            
            break;
        }
        default:
            break;
    }
}

- (void)setShowNavigationBottomLine:(BOOL)showNavigationBottomLine {
    _showNavigationBottomLine = showNavigationBottomLine;
    
    self.naviBottomLine.hidden = !showNavigationBottomLine;
}

# pragma mark- 默认方法，子类可重载
- (void)goBack {
    
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)rightButtonClick:(UIButton *)button {
    
}

- (void)buttonClick:(UIButton *)button {
    
}

# pragma mark- Getter/Setter
- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    
    if (self.titleView) {
        
        if ([self.titleView isKindOfClass:[UIButton class]]) {
            [self.titleView setTitle:title forState:UIControlStateNormal];
        }else if ([self.titleView isKindOfClass:[UILabel class]]) {
            ((UILabel *)self.titleView).text = title;
        }else if ([self.titleView isKindOfClass:[UITextField class]]) {
            ((UITextField *)self.titleView).text = title;
        }
    }
}

- (void)setParams:(NSMutableDictionary *)params {
    
    //将参数加到外层来, 保证self.params[@"key"]可以直接取到值
    if ([params[@"MGJRouterParameterUserInfo"] isKindOfClass:[NSDictionary class]]) {
        for (NSString *key in params[@"MGJRouterParameterUserInfo"]) {
            [params setObject:params[@"MGJRouterParameterUserInfo"][key] forKey:key];
        }
    }
    
    _params = params;
}

// 侧滑返回
- (void)setPopGestureEnable:(BOOL)popGestureEnable {
    _popGestureEnable = popGestureEnable;
    
    self.zz_interactivePopDisabled = !_popGestureEnable;
}

// 导航栏相关
- (void)setHideNavigationView:(BOOL)hideNavigationView {
    _hideNavigationView = hideNavigationView;
    
    if (_hideNavigationView && self.navView.superview) {
        [self.navView removeFromSuperview];
    }else if (!_hideNavigationView && !self.navView.superview) {
        [self.view addSubview:self.navView];
    }
}

- (UIImageView *)navView {
    if (!_navView) {
        _navView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ZZWidth, 64 + ZZSafeTopHeight)];
        _navView.userInteractionEnabled = YES;
        _navView.backgroundColor = [UIColor zz_colorWithCSS:@"#FFFFFFFF"];
    }
    return _navView;
}

- (UIView *)naviBottomLine {
    if (!_naviBottomLine) {
        _naviBottomLine = [[UIView alloc] init];
        
        _naviBottomLine.frame = CGRectMake(0, ZZSafeTopHeight + 63, ZZWidth, 1);
        _naviBottomLine.backgroundColor = [UIColor zz_colorWithCSS:@"#EEEEEE"];
    }
    return _naviBottomLine;
}

- (UIButton *)titleView {
    if (!_titleView) {
        _titleView = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleView.titleLabel.font = [UIFont boldSystemFontOfSize:AfW(18)];
        [_titleView setTitleColor:[UIColor zz_colorWithCSS:@"#333333"] forState:UIControlStateNormal];
        _titleView.adjustsImageWhenHighlighted = NO;
        
        CGFloat minX = (ZZWidth - AfW(300)) / 2.0;
        _titleView.frame = CGRectMake(minX, ZZStatusBarHeight, AfW(300), 44);
    }
    return _titleView;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:AfW(13)];
        [_leftButton setTitleColor:[UIColor zz_colorWithCSS:@"#333333"] forState:UIControlStateNormal];
        _leftButton.adjustsImageWhenHighlighted = NO;
        _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        _leftButton.frame = CGRectMake(AfW(12), ZZStatusBarHeight, 44, 44);
        
        [_leftButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:AfW(13)];
        [_rightButton setTitleColor:[UIColor zz_colorWithCSS:@"#333333"] forState:UIControlStateNormal];
        _rightButton.adjustsImageWhenHighlighted = NO;
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        CGFloat minX = [UIScreen mainScreen].bounds.size.width - 44 - AfW(12);
        _rightButton.frame = CGRectMake(minX, ZZStatusBarHeight, 44, 44);
        [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

# pragma mark- 方法重写
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if (@available(iOS 13.0, *)) {
        if (viewControllerToPresent.modalPresentationStyle == UIModalPresentationAutomatic) {
            viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
        }
    }
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end











