//
//  ZZStarView.h
//  ZZToolsDemo
//
//  Created by 刘猛 on 2019/2/1.
//  Copyright © 2019年 刘猛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZZStarViewCallBack)(CGFloat userGrade, CGFloat finalGrade);

NS_ASSUME_NONNULL_BEGIN

@interface ZZStarView : UIView

/**用户修改了分值的回调(传入后, 用户也将可以修改分值, 可以通过userInteractionEnabledv关闭)*/
@property (nonatomic ,   copy) ZZStarViewCallBack   callBack;

/**分阶, 默认为0.5, 即为最终分永远是0.5的倍数, 如果为1则永远为1的倍数(即为整数), 取值在0.01~1.0之间, 若需自定义, 建议在设置grade(分值)之前确定此值*/
@property (nonatomic , assign) CGFloat              sublevel;

/**当前分值, 每个星一分, 支持小数点, 进度自适应*/
@property (nonatomic , assign) CGFloat              grade;

/**最低分值, 用户无法设置低于此值的分值, 默认为0.5*/
@property (nonatomic , assign) CGFloat              miniGrade;

/**
 * image:       未选中状态的图片
 * selectImage: 选中状态的图片
 * starWidth:   星星的宽度
 * starHeight:  星星的高度
 * starMargin:  每两个星星之间的间距
 * starCount:   需要几个星星
 * callBack:    如果传入nil, 则用户不可以修改分值
 * 注:          此view宽高自适应, 设置frame时, 只需考虑起点xy坐标.
 */
- (instancetype)initWithImage:(UIImage *)image selectImage:(UIImage *)selectImage starWidth:(CGFloat)starWidth starHeight:(CGFloat)starHeight starMargin:(CGFloat)starMargin starCount:(int)starCount callBack:(nullable ZZStarViewCallBack)callBack;

@end

NS_ASSUME_NONNULL_END
