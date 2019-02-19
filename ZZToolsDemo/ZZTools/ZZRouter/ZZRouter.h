//
//  ZZRouter.h
//  ZZToolsDemo
//
//  Created by yons on 2019/2/11.
//  Copyright © 2019年 刘猛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef id (^ZZRouterBlock)(NSDictionary *result);

# pragma mark- ZZRouter
@interface ZZRouter : NSObject

+ (instancetype)shared;

/**
 * 注册路由, 传入路由以及
 */
- (void)map:(NSString *)route toControllerClass:(Class)controllerClass;

/**
 * 根据路由, 获取控制器对象, 可传入参数
 * 
 */
- (UIViewController *)matchController:(NSString *)route;

@end

# pragma mark- UIViewController
@interface UIViewController (ZZRouter)

@property (nonatomic, strong) NSDictionary *params;

@end

NS_ASSUME_NONNULL_END
