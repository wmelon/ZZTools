//
//  ZZStarView.m
//  ZZToolsDemo
//
//  Created by yons on 2019/2/1.
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

@end

@implementation ZZStarView

- (instancetype)initWithImage:(UIImage *)image selectImage:(UIImage *)selectImage starWidth:(CGFloat)starWidth starHeight:(CGFloat)starHeight starMargin:(CGFloat)starMargin starCount:(int)starCount callBack:(ZZStarViewCallBack)callBack {
    if (self == [super init]) {
        
        self.starWidth = starWidth;
        self.starHeight = starHeight;
        self.starCount = starCount;
        self.starMargin = starMargin;
        
        //0.临时的东西
        self.frame = CGRectMake(50, 150, self.starWidth * starCount + starMargin * (starCount > 1 ? starCount - 1 : starCount), starHeight);
        
        //1.普通的view
        self.normalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.starWidth * starCount + starMargin * (starCount > 1 ? starCount - 1 : starCount), self.starHeight)];
        [self addSubview:self.normalView];
        self.normalView.backgroundColor = [UIColor yellowColor];
        
        for (int i = 0 ; i < starCount; i ++ ) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.starWidth + starMargin) * i, 0, self.starWidth, self.starHeight)];
            [self.normalView addSubview:imageView];
            imageView.image = image;
        }
        
        //2.选中的view
        self.selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.starWidth * starCount + starMargin * (starCount > 1 ? starCount - 1 : starCount), self.starHeight)];
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
            self.grade = i + value / self.starWidth;
        }
    }
    //CGPoint pt = [[touches anyObject] locationInView:self];
    //NSLog(@"pt.x === %.2f",pt.x);
}

# pragma mark- 设置分值
-(void)setGrade:(CGFloat)grade {
    
    _grade = grade > self.starCount ? self.starCount : grade;//最高分为星星的个数.
    int g = (int)grade;
    CGFloat width = self.starWidth * g + self.starMargin * g + (grade - g) * self.starWidth;
    //1.修改选中的宽度.
    CGRect rect = self.selectView.frame;
    rect.size.width = width;
    self.selectView.frame = rect;
    
}

@end
