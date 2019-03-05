//
//  ZZStarView.m
//  ZZToolsDemo
//
//  Created by 刘猛 on 2019/2/1.
//  Copyright © 2019年 刘猛. All rights reserved.
//

#import "ZZStarView.h"

@interface ZZStarView ()

/**普通状态的view*/
@property (nonatomic , strong) UIView   *normalView;

/**选中状态的view*/
@property (nonatomic , strong) UIView   *selectView;

/**星星个数*/
@property (nonatomic , assign) int      starCount;

/**星星间距*/
@property (nonatomic , assign) CGFloat  starMargin;

/**星星的宽度*/
@property (nonatomic , assign) CGFloat  starWidth;

/**星星的高度*/
@property (nonatomic , assign) CGFloat  starHeight;

/**用户所选的分值*/
@property (nonatomic , assign) CGFloat  userGrade;

@end

@implementation ZZStarView

- (instancetype)initWithImage:(UIImage *)image selectImage:(UIImage *)selectImage starWidth:(CGFloat)starWidth starHeight:(CGFloat)starHeight starMargin:(CGFloat)starMargin starCount:(int)starCount callBack:(ZZStarViewCallBack)callBack {
    if (self == [super init]) {
        //1.基础的东西
        self.userInteractionEnabled = NO;
        self.miniGrade = 0.0;
        self.starWidth = starWidth;
        self.starHeight = starHeight;
        self.starCount = starCount;
        self.starMargin = starMargin;
        self.callBack = callBack;
        self.sublevel = 0.5;
        self.bounds = CGRectMake(0, 0, self.starWidth * starCount + starMargin * (starCount > 1 ? starCount - 1 : starCount), starHeight);
        
        //2.普通的view
        self.normalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.starWidth * starCount + starMargin * (starCount > 1 ? starCount - 1 : starCount), self.starHeight)];
        [self addSubview:self.normalView];
        for (int i = 0 ; i < starCount; i ++ ) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.starWidth + starMargin) * i, 0, self.starWidth, self.starHeight)];
            [self.normalView addSubview:imageView];
            imageView.image = image;
        }
        
        //3.选中的view
        self.selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.starHeight)];
        self.selectView.clipsToBounds = YES;
        self.selectView.userInteractionEnabled = NO;
        [self addSubview:self.selectView];
        self.selectView.backgroundColor = [UIColor clearColor];
        
        for (int i = 0 ; i < starCount; i ++ ) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.starWidth + starMargin) * i, 0, self.starWidth, self.starHeight)];
            [self.selectView addSubview:imageView];
            imageView.image = selectImage;
        }
        
    }
    return self;
}

- (instancetype)init {
    if (self == [super init]) {
        self.miniGrade = 0.0;
        self.sublevel = 0.5;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //UIView *eventView = nil;
    
    for (int i = 0; i < self.normalView.subviews.count; i ++) {
        UIView *view = self.normalView.subviews[i];
        CGPoint pt = [[touches anyObject] locationInView:view];
        if (pt.x >= 0 && pt.x < self.starWidth + self.starMargin) {//定位具体在哪个星星的范围
            CGFloat value = pt.x > self.starWidth ? self.starWidth : pt.x;
            self.userGrade = i + value / self.starWidth;
            self.grade = self.userGrade;
        }
    }
    //CGPoint pt = [[touches anyObject] locationInView:self];
    //NSLog(@"pt.x === %.2f",pt.x);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.callBack) {
        self.callBack(self.userGrade, self.grade);
    }
}

# pragma mark- 设置分值
- (void)setGrade:(CGFloat)grade {
    
    //1.取最大值和最小值
    _grade = grade > self.starCount ? self.starCount : grade;//最高分为星星的个数.
    _grade = grade > self.miniGrade ? grade : self.miniGrade;//最低值
    
    //2.取分阶分值
    int i = (int)_grade;//分值的整数部分
    CGFloat f = _grade - i;//分值的小数部分
    int intF = (int)(f * 1000);
    int factor = intF / ((int)(self.sublevel * 1000));
    CGFloat remainder = (intF % (int)(self.sublevel * 1000)) * 0.001;
    _grade = i + factor * self.sublevel + (remainder > self.sublevel * 0.5 ? self.sublevel : 0);
    
    //3.计算并修改星星的显示
    CGFloat width = self.starWidth * i + self.starMargin * i + (_grade - i) * self.starWidth;
    CGRect rect = self.selectView.frame;
    rect.size.width = width;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.selectView.frame = rect;
    });
    
}

- (void)setSublevel:(CGFloat)sublevel {
    
    if (sublevel < 0.01) {
        _sublevel = 0.01;
    } else if (sublevel > 1) {
        _sublevel = 1.0;
    } else {
        _sublevel = sublevel;
    }
    
    [self setGrade:self.grade];
    
}

- (void)setCallBack:(ZZStarViewCallBack)callBack {
    _callBack = callBack;
    if (callBack) {self.userInteractionEnabled = YES;}
}

@end
