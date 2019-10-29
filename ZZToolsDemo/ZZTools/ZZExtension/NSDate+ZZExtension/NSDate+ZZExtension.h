//
//  NSObject+NSTimeInterval.h
//  ShallBuyLife
//
//  Created by 刘猛 on 2018/12/10.
//  Copyright © 2018 刘猛. All rights reserved.
//
//  类别,具体用法查看具体公开方法的单独注释
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (ZZExtension)

/*** 获取当前时间戳*/
+ (NSTimeInterval)zz_getCurrentTimestamp;

/*** 获取当前时间*/
+ (NSString *)zz_getCurrentTimeWithFormatter:(NSString *)format;

/*** 时间转化成时间戳*/
+ (NSInteger)zz_getTimestampWithTime:(NSString *)formatTime andFormatter:(NSString *)format;

/*** 时间戳转时间*/
+ (NSString *)zz_getTimeWithTimestamp:(NSTimeInterval)timestamp andFormatter:(NSString *)format;

/**获取timestamp的monthsAgo月前时间*/
+ (NSString *)zz_getTimeWithTimestamp:(NSTimeInterval)timestamp monthsAgo:(int)monthsAgo;

/**获取timestamp的monthsAgo月后时间*/
+ (NSString *)zz_getTimeWithTimestamp:(NSTimeInterval)timestamp monthsAfter:(int)monthsAfter;

@end

NS_ASSUME_NONNULL_END
