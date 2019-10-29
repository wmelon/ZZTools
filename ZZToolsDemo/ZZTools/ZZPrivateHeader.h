//
//  ZZPrivateHeader.h
//  ZZToolsDemo
//
//  Created by 刘猛 on 2019/3/5.
//  Copyright © 2019年 刘猛. All rights reserved.
//
//  私有头文件, 无需导入
//

#ifndef ZZPrivateHeader_h
#define ZZPrivateHeader_h

//MARK:- 屏幕适配
#define AfW(x) (x / 375.0 * ZZWidth)
#define ZZWidth UIScreen.mainScreen.bounds.size.width
#define ZZHeight UIScreen.mainScreen.bounds.size.height
#define ZZKeyWindow [[UIApplication sharedApplication] keyWindow]

//MARK:- iPhone X系列
#define ZZDevice_iPhoneX (ZZHeight >= 812.f ? YES : NO)
#define ZZStatusBarHeight (ZZDevice_iPhoneX ? 44.f : 20.f)
#define ZZSafeTopHeight (ZZDevice_iPhoneX ? 24.f : 0)
#define ZZSafeBottomHeight (ZZDevice_iPhoneX ? 34.f : 0.f)
#define ZZNavHeight (ZZDevice_iPhoneX ? 88.f : 64.f)

//MARK:- 颜色&字体
#define ZZCOLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define ZZSysFont(x) [UIFont systemFontOfSize:AfW(x)]
#define ZZBoldFont(x) [UIFont boldSystemFontOfSize:AfW(x)]

//MARK:- weakSelf
#define ZZWeakSelf __block __weak __typeof(&*self)weakSelf = self;\

//MARK:- 引入头文件
#import <SDAutoLayout.h>

#endif /* ZZPrivateHeader_h */
