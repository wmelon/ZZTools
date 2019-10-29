//
//  ZZTimer.m
//  ZZExtensionDemo
//
//  Created by 刘猛 on 2019/9/3.
//  Copyright © 2019 nvZhuangWang. All rights reserved.
//

#import "ZZTimer.h"

static ZZTimer *instance = nil;

@interface ZZTimer ()

@property (nonatomic, strong) NSMutableDictionary  *timeContainerDic;
@property (nonatomic, strong) NSMutableDictionary  *remainingTimeDic;
@property (nonatomic, strong) NSMutableDictionary  *pastingTimeDic;

@end

@implementation ZZTimer

- (BOOL)zz_isExist:(NSString *)name {
    return [self.timeContainerDic objectForKey:name] != nil;
}

- (void)zz_getGCDTimerWithName:(NSString *)name totalTime:(double)totalTime frequency:(float)frequency queue:(dispatch_queue_t)queue repeats:(BOOL)repeats action:(ZZTimeCallBack)action {

    if (!name || [self.timeContainerDic objectForKey:name] != nil) {return;}//如我没有名字或者名称已存在则不执行!
    if (!queue) {queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);}

    //获取一个timer
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_resume(timer);
    
    [self.timeContainerDic setObject:timer forKey:name];
    //[self.remainingTimeDic setObject:@(totalTime) forKey:name];
    
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, frequency * NSEC_PER_SEC, frequency * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //double remaining = [[self.remainingTimeDic objectForKey:name] doubleValue];
            double pastingTime = [[self.pastingTimeDic objectForKey:name] doubleValue];
            if (totalTime > 0) {
                if (pastingTime >= totalTime) {
                    action(totalTime, 0);
                    [self zz_cancelTimerWithName:name];
                } else {
                    action(pastingTime, totalTime - pastingTime);
                    pastingTime = pastingTime + frequency;
                    [self.pastingTimeDic setObject:[NSString stringWithFormat:@"%f", pastingTime] forKey:name];
                }
            }
            if (!repeats) {[self zz_cancelTimerWithName:name];}
        });
    });
}

- (void)zz_cancelTimerWithName:(NSString *)name {//取消计时器
    NSString *pastedTimeKey = [NSString stringWithFormat:@"XXTimer_%@",name];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:pastedTimeKey];
    if (!name) {return;}
    dispatch_source_t timer = [self.timeContainerDic objectForKey:name];
    if (!timer) {return;}
    [self.timeContainerDic removeObjectForKey:name];
    //[self.remainingTimeDic removeObjectForKey:name];
    [self.pastingTimeDic removeObjectForKey:name];
    dispatch_source_cancel(timer);
    //NSLog(@"定时器 %@ 被取消了!",name);
}

#pragma mark - 单例类的实现
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZZTimer alloc] init];
        instance.timeContainerDic = [[NSMutableDictionary alloc] init];
        //instance.remainingTimeDic = [[NSMutableDictionary alloc] init];
        instance.pastingTimeDic = [[NSMutableDictionary alloc] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    if(instance == nil) {
        instance = [super allocWithZone:zone];
    }
    return instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return instance;
}

@end
