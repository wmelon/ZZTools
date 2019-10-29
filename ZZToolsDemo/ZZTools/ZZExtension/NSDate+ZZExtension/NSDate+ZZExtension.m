//
//  NSObject+NSTimeInterval.m
//  ZZToolsDemo
//
//  Created by 刘猛 on 2018/12/10.
//  Copyright © 2018 刘猛. All rights reserved.
//

#import "NSDate+ZZExtension.h"

@implementation NSDate (ZZExtension)

#pragma mark - 时间戳处理
+ (NSTimeInterval)zz_getCurrentTimestamp {
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    return (NSTimeInterval)[dat timeIntervalSince1970];
}

/**根据format获取时间戳字符串,如:yyyy-MM-dd hh:mm:ss*/
+ (NSString *)zz_getCurrentTimeWithFormatter:(NSString *)format {//获取时间字符串
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //设置格式
    [formatter setDateFormat:format];
    //设置时区
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *nowtimeStr = [formatter stringFromDate:datenow];//这就是转换后的可用时间字符串了!
    return nowtimeStr;
}

+ (NSInteger)zz_getTimestampWithTime:(NSString *)formatTime andFormatter:(NSString *)format {//时间转时间戳
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format]; //(@"yyyy-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    //NSLog(@"将某个时间转化成 时间戳&&&&&&&timeSp:%ld",(long)timeSp); //时间戳的值
    return timeSp;
}

+ (NSString *)zz_getTimeWithTimestamp:(NSTimeInterval)timestamp andFormatter:(NSString *)format {//时间戳转时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];//@"yyyy-MM-dd HH:mm:ss"
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

+ (NSString *)zz_getTimeWithTimestamp:(NSTimeInterval)timestamp monthsAgo:(int)monthsAgo {
    
    //1. 获取基础时间的年月日
    NSString *date = [self zz_getTimeWithTimestamp:timestamp andFormatter:@"yyyy-MM-dd"];
    if ([date componentsSeparatedByString:@"-"].count < 3) {NSLog(@"方法: zz_getTimeWithTimestamp monthsAgo: 参数有误");return 0;}
    //2. 计算年月日
    int year = [[date componentsSeparatedByString:@"-"][0] intValue] - monthsAgo / 12;
    int month = [[date componentsSeparatedByString:@"-"][1] intValue];
    int day = [[date componentsSeparatedByString:@"-"][2] intValue];
    int truthmonthsAgo = monthsAgo % 12;if (truthmonthsAgo >= month) {month += 12;year -= 1;}month -= truthmonthsAgo;
    while ([self zz_getTimestampWithTime:[NSString stringWithFormat:@"%02d-%02d-%02d", year, month, day] andFormatter:@"yyyy-MM-dd"] < 1000) {
        day -= 1;//当天没有, 减去一天
    }
    
    //3. 序列化时间并返回
    return [NSString stringWithFormat:@"%02d-%02d-%02d", year, month, day];
    
}

+ (NSString *)zz_getTimeWithTimestamp:(NSTimeInterval)timestamp monthsAfter:(int)monthsAfter {
    
    //1. 获取基础时间的年月日
    NSString *date = [self zz_getTimeWithTimestamp:timestamp andFormatter:@"yyyy-MM-dd"];
    if ([date componentsSeparatedByString:@"-"].count < 3) {NSLog(@"方法: zz_getTimeWithTimestamp monthsAgo: 参数有误");return 0;}
    
    //2. 计算年月日
    int year = [[date componentsSeparatedByString:@"-"][0] intValue] + monthsAfter / 12;
    int month = [[date componentsSeparatedByString:@"-"][1] intValue];
    int day = [[date componentsSeparatedByString:@"-"][2] intValue];
    int truthmonthsAgo = monthsAfter % 12;if (truthmonthsAgo + month > 12) {month -= 12;year += 1;}month += truthmonthsAgo;
    while ([self zz_getTimestampWithTime:[NSString stringWithFormat:@"%02d-%02d-%02d", year, month, day] andFormatter:@"yyyy-MM-dd"] < 1000) {
        day -= 1;//当天没有, 减去一天
    }
    
    //3. 序列化时间并返回
    return [NSString stringWithFormat:@"%02d-%02d-%02d", year, month, day];
    
}

@end
