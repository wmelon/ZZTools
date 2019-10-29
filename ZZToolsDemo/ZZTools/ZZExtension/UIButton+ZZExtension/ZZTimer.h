//
//  ZZTimer.h
//  ZZExtensionDemo
//
//  Created by 刘猛 on 2019/9/3.
//  Copyright © 2019 nvZhuangWang. All rights reserved.
//
//  通过单利类获取一个计时器, 摆脱当前控制器的生命周期
//

#import <Foundation/Foundation.h>

typedef void(^ZZTimeCallBack)(double pastTime,double remainingTime);

@interface ZZTimer : NSObject

+ (ZZTimer *)sharedManager;

/**根据名字创建一个GCD封装的定时器,注:重名则会被return*/
- (void)zz_getGCDTimerWithName:(NSString *)name totalTime:(double)totalTime frequency:(float)frequency queue:(dispatch_queue_t)queue repeats:(BOOL)repeats action:(ZZTimeCallBack)action;

/**根据名字取消定时器*/
- (void)zz_cancelTimerWithName:(NSString *)name;

- (BOOL)zz_isExist:(NSString *)name;

@end
