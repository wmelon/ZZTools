//
//  ZZChildVC.m
//  ZZToolsDemo
//
//  Created by 刘猛 on 2019/4/26.
//  Copyright © 2019 刘猛. All rights reserved.
//

#import "ZZChildVC.h"
#import "ZZSuperVC.h"

@interface ZZChildVC ()

@end

@implementation ZZChildVC

- (void)viewDidLoad {
    [super viewDidLoad];self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leaveFromTop) name:@"ZZParentTableViewDidLeaveFromTopNotification" object:nil];
}

- (void)leaveFromTop {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_scrollView setContentOffset:CGPointMake(0, 0)];
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!_scrollView) {_scrollView = scrollView;}
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewIsScrolling:)]) {
        [self.delegate scrollViewIsScrolling:scrollView];
    }
    
}

@end
