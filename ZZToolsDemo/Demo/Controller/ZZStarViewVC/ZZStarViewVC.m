//
//  ZZStarViewVC.m
//  ZZToolsDemo
//
//  Created by 刘猛 on 2019/2/1.
//  Copyright © 2019年 刘猛. All rights reserved.
//

#import "ZZTools.h"
#import "ZZStarViewVC.h"

@interface ZZStarViewVC ()

/**星星评价*/
@property (nonatomic , strong) ZZStarView   *starView;

@end

@implementation ZZStarViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"星星评价";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //第一个
    self.starView = [[ZZStarView alloc] initWithImage:[UIImage imageNamed:@"star"] selectImage:[UIImage imageNamed:@"didStar"] starWidth:20 starHeight:20 starMargin:5 starCount:5 callBack:^(CGFloat userGrade, CGFloat finalGrade) {
        NSLog(@"用户实际选择分 === %.2f, 最终分 === %.2f", userGrade, finalGrade);
    }];
    self.starView.sublevel = 0.5;//默认值, 可以不写, 用户可选分值范围是0.5的倍数.(建议在设置分值之前确定此值)
    self.starView.grade = [self.params[@"grade1"] floatValue];//设置分值, 可以不写, 默认显示0分.(self.params是UIViewController在ZZRouter中扩展的属性, 包含了所有参数)
    self.starView.miniGrade = 0.5;//默认值, 可以不写 ,用户可以设置的最低分值.
    [self.view addSubview:self.starView];
    self.starView.frame = CGRectMake(50, 150, self.starView.bounds.size.width, self.starView.bounds.size.height);

    //第二个
    ZZStarView *starView1 = [[ZZStarView alloc] initWithImage:[UIImage imageNamed:@"star"] selectImage:[UIImage imageNamed:@"didStar"] starWidth:20 starHeight:20 starMargin:5 starCount:10 callBack:^(CGFloat userGrade, CGFloat finalGrade) {
        NSLog(@"用户实际选择分 === %.2f, 最终分 === %.2f", userGrade, finalGrade);
    }];
    starView1.sublevel = 1;//用户可选分值范围是1的倍数(即为整数).(建议在设置分值之前确定此值)
    starView1.grade = [self.params[@"grade2"] floatValue];//设置分值, 可以不写, 默认显示0分.(self.params是UIViewController在ZZRouter中扩展的属性, 包含了所有参数)
    starView1.miniGrade = 0;//用户可以设置的最低分值.
    
    [self.view addSubview:starView1];
    starView1.frame = CGRectMake(50, 210, starView1.bounds.size.width, starView1.bounds.size.height);
    
    //第三个
    ZZStarView *starView2 = [[ZZStarView alloc] initWithImage:[UIImage imageNamed:@"star"] selectImage:[UIImage imageNamed:@"didStar"] starWidth:20 starHeight:20 starMargin:5 starCount:8 callBack:^(CGFloat userGrade, CGFloat finalGrade) {
        NSLog(@"用户实际选择分 === %.2f, 最终分 === %.2f", userGrade, finalGrade);
    }];
    starView2.sublevel = 0.01;//用户可选分值范围是0.01的倍数.(建议在设置分值之前确定此值)
    starView2.grade = [self.params[@"grade3"] floatValue];//设置分值, 可以不写, 默认显示0分.(self.params是UIViewController在ZZRouter中扩展的属性, 包含了所有参数)
    starView2.miniGrade = 0.5;//用户可以设置的最低分值.
    [self.view addSubview:starView2];
    starView2.frame = CGRectMake(50, 270, starView2.bounds.size.width, starView2.bounds.size.height);
   
}

- (void)dealloc {
    if (self.routerCallBack) {
        self.routerCallBack(@{ @"code": @"1", @"data": @"jsonString" });
    }
}

@end
