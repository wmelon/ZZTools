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

typedef id (^ZZRouterBlock)(NSDictionary *params);

# pragma mark- ZZRouter
@interface ZZRouter : NSObject

+ (instancetype)shared;

- (void)map:(NSString *)route toControllerClass:(Class)controllerClass;
- (UIViewController *)match:(NSString *)route __attribute__((deprecated));
- (UIViewController *)matchController:(NSString *)route;

- (void)map:(NSString *)route toBlock:(ZZRouterBlock)block;
- (ZZRouterBlock)matchBlock:(NSString *)route;
- (id)callBlock:(NSString *)route;

@end

# pragma mark- UIViewController
@interface UIViewController (ZZRouter)

@property (nonatomic, strong) NSDictionary *params;

@end


NS_ASSUME_NONNULL_END
