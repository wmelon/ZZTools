//
//  UIControl+ZZExtension.m
//  FanLi
//
//  Created by 刘猛 on 2019/9/4.
//  Copyright © 2019 nvZhuangWang. All rights reserved.
//

#import "ZZTimer.h"
#import <objc/message.h>
#import "NSString+ZZExtension.h"
#import "UIControl+ZZExtension.h"

static char ZZ_NAME;
static char ZZ_CALLBACK;
static char ZZ_FREQUENCY;
static char ZZ_EVENTINTERVAL;//EventInterval;
static char ZZ_ISRETURNCLICKEVENT;//IsReturnClickEvent;

@interface UIColor ()

@property (nonatomic,   copy) NSString    *zz_name;
@property (nonatomic, assign) CGFloat     zz_frequency;
@property (nonatomic, assign) double      zz_eventInterval;

@end

@implementation UIControl (ZZExtension)

//对外开放的方法实现
- (void)zz_setReturnEventAfterClicked:(double) interval frequency:(CGFloat)frequency callBack:(UIControlReturnEventingCallBack)callBack {
    if (![self isKindOfClass:[UIButton class]]) {return;}
    self.zz_eventInterval = interval;if (!callBack || interval < 0) {return;}
    //给按钮一个唯一的名字,用来管理定时器
    self.zz_name = [NSString zz_getSingletonStringWithLength:10];
    self.zz_frequency = frequency;self.callBack = callBack;
}

#pragma mark - 方法替换->实现按钮的间隔点击
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //方法替换
        Method orginalMethod = class_getInstanceMethod([self class], @selector(sendAction:to:forEvent:));
        Method myMethod = class_getInstanceMethod([self class], @selector(mySendAction:to:forEvent:));
        method_exchangeImplementations(myMethod, orginalMethod);
    });
}

- (void)mySendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event {

    //如果延迟>0表示设置了点击间隔,并如果这个间隔还没过的话就return
    if (self.zz_eventInterval > 0 && self.isReturnClickEvent) {return;}
    self.isReturnClickEvent = YES;
    [self mySendAction:action to:target forEvent:event];
    if (self.zz_eventInterval > 0) {
        [self performSelector:@selector(changeReturnCondition) withObject:nil afterDelay:self.zz_eventInterval];
    }

    if (self.callBack) {
        //如果开启了定时回调则继续进行操作
        [[ZZTimer sharedManager] zz_getGCDTimerWithName:self.zz_name totalTime:self.zz_eventInterval frequency:self.zz_frequency queue:nil repeats:YES action:^(double pastTime , double remainingTime) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.callBack(remainingTime);
            });
        }];
    }

}

- (void)changeReturnCondition {//延迟一点时间后把self.returnClickEvent设为NO
    self.isReturnClickEvent = NO;
}

#pragma mark - 属性set/get方法的实现
- (void)setZz_name:(NSString *)zz_name {
    objc_setAssociatedObject(self, &ZZ_NAME, zz_name, OBJC_ASSOCIATION_COPY);
}

- (NSString *)zz_name {
    return objc_getAssociatedObject(self, &ZZ_NAME);
}

- (void)setZz_frequency:(CGFloat)zz_frequency {
    NSString *string = [NSString stringWithFormat:@"%lf",zz_frequency];
    objc_setAssociatedObject(self, &ZZ_FREQUENCY, string, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (CGFloat)zz_frequency {
    NSString *string = objc_getAssociatedObject(self, &ZZ_FREQUENCY);
    return [string floatValue];
}

- (void)setZz_eventInterval:(double)zz_eventInterval {
    NSString *string = [NSString stringWithFormat:@"%lf",zz_eventInterval];
    objc_setAssociatedObject(self, &ZZ_EVENTINTERVAL, string, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (double)zz_eventInterval {
    NSString *string = objc_getAssociatedObject(self, &ZZ_EVENTINTERVAL);
    return [string doubleValue];
}


- (void)setIsReturnClickEvent:(BOOL)isReturnClickEvent {
    objc_setAssociatedObject(self, &ZZ_ISRETURNCLICKEVENT, @(isReturnClickEvent), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isReturnClickEvent {
    NSNumber *number = objc_getAssociatedObject(self, &ZZ_ISRETURNCLICKEVENT);
    return number.intValue;
}

- (void)setCallBack:(UIControlReturnEventingCallBack)callBack {
    objc_setAssociatedObject(self, &ZZ_CALLBACK, callBack, OBJC_ASSOCIATION_COPY);
}

- (UIControlReturnEventingCallBack)callBack {
    return objc_getAssociatedObject(self, &ZZ_CALLBACK);
}

@end
