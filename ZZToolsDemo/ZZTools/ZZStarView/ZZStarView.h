//
//  ZZStarView.h
//  ZZToolsDemo
//
//  Created by yons on 2019/2/1.
//  Copyright © 2019年 刘猛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZZStarViewCallBack)(CGFloat userGrade, CGFloat finalGrade);

NS_ASSUME_NONNULL_BEGIN

@interface ZZStarView : UIView

/**用户修改了分值的回调(传入后, 用户也将可以修改分值, 可以通过userInteractionEnabledv关闭)*/
@property (nonatomic ,   copy) ZZStarViewCallBack   callBack;

/**当前分值, 每个星一分, 支持小数点, 进度自适应*/
@property (nonatomic , assign) CGFloat              grade;

/**最低分值, 用户无法设置低于此值的分支, 默认为0.5*/
@property (nonatomic , assign) CGFloat              miniGrade;

/**
 * image:           未选中状态的图片
 * selectImage:     选中状态的图片
 * starWidth:       星星的宽度
 * starHeight:      星星的高度
 * starMargin:      每两个星星之间的间距
 * starCount:       需要几个星星
 * callBack:        如果传入nil, 则用户不可以修改分值
 * 注:               此view宽高自适应, 设置frame时, 只需考虑q起点xy坐标.
 */
- (instancetype)initWithImage:(UIImage *)image selectImage:(UIImage *)selectImage starWidth:(CGFloat)starWidth starHeight:(CGFloat)starHeight starMargin:(CGFloat)starMargin starCount:(int)starCount callBack:(ZZStarViewCallBack)callBack;

@end

NS_ASSUME_NONNULL_END
