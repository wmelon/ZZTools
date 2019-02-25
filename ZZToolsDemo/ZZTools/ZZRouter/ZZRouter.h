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

# pragma mark- ZZRouter
@interface ZZRouter : NSObject

+ (instancetype)shared;

/**
 * 根据路由, 获取控制器对象, 可传入参数
 * 参数传入形式类似get请求, 如: https://xxx/app/goods/detail?goodsId=10, 其中"?"前面是路由, "?"后面是参数, 多个参数用&连接
 * 所有参数都在当前控制器的params属性中(类别中已添加该字典属性), 此时, 传说参数后, params对应@{ @"goodsId": @"10"}
 */
- (UIViewController *)getController:(NSString *)route;

/**
 * 注册路由, 传入路由以及参数
 */
- (void)mapRoute:(NSString *)route toControllerClass:(Class)controllerClass;

@end

# pragma mark- UIViewController
typedef void(^ZZRouterBlock)(NSDictionary *result);

@interface UIViewController (ZZRouter)

/**
 * 路由传参, "?"后面所有的参数都将包含在此
 * 参数中的key对应字典中的key, 参数中的value就是key对应的value
 */
@property (nonatomic , strong) NSDictionary     *params;

/**
 * 用途: 次级页面反向传值的回调
 * 比喻: 如果把使用路由打开一个页面看做是调用一个接口的话, 那么回调就是网络请求的返回值, 只不过大部分路由不需要返回值而已
 * 使用: 在一些需要反向传值的页面, 建议也仿照服务端返回数据时, 采用jsonSting去交流数据(或者只在字典中存入系统原有类的实例)
 * 原因: 因为在实际开发中, 我们对外提供了一个路由接口, 可能有其他很多同事需要使用, 谁使用, 谁解析返回值
 * 原因: 如果你传入了一个CustomClass, 别人拿到数据在导入你的CustomClass类, 就又产生了耦合
 */
@property (nonatomic ,   copy) ZZRouterBlock    routerCallBack;

@end

NS_ASSUME_NONNULL_END
