//
//  UIControl+ZZExtension.h
//  FanLi
//
//  Created by 刘猛 on 2019/9/4.
//  Copyright © 2019 nvZhuangWang. All rights reserved.
//
//  类别,具体用法查看具体公开方法的单独注释
//


#import <UIKit/UIKit.h>

typedef void(^UIControlReturnEventingCallBack)(double remainingTime);

@interface UIControl (ZZExtension)

/** 查看按钮当前是否会处理接到的事件(事件已经被接收,不会传给父视图了) */
@property (nonatomic, readonly , assign) BOOL                              isReturnClickEvent;
/** 点击间隔时的回调 */
@property (nonatomic, readonly ,   copy) UIControlReturnEventingCallBack   callBack;

/**
 *实现按钮的间隔点击效果
 *@param interval   按钮的点击间隔时间
 *@param frequency  间隔时间内,回调的频率,0为不回调
 *@param callBack   若想拿到回调,则需要实现这个block
 */
- (void)zz_setReturnEventAfterClicked:(double) interval frequency:(CGFloat)frequency callBack:(UIControlReturnEventingCallBack)callBack;

@end
