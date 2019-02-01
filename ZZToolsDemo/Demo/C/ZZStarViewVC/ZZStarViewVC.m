//
//  ZZStarViewVC.m
//  ZZToolsDemo
//
//  Created by yons on 2019/2/1.
//  Copyright © 2019年 刘猛. All rights reserved.
//

#import "ZZStarView.h"
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
    
    self.starView = [[ZZStarView alloc] initWithImage:[UIImage imageNamed:@"star"] selectImage:[UIImage imageNamed:@"didStar"] starWidth:40 starHeight:40 starMargin:10 starCount:5 callBack:^(CGFloat grade) {
        NSLog(@"grad === %.2f", grade);
    }];
    
    [self.view addSubview:self.starView];
    
    self.starView.backgroundColor = [UIColor redColor];
    
    self.starView.grade = 1.5;
   
}



@end
