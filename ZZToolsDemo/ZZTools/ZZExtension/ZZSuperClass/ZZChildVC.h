//
//  ZZChildVC.h
//  ZZToolsDemo
//
//  Created by 刘猛 on 2019/4/26.
//  Copyright © 2019 刘猛. All rights reserved.
//
//  需要和管理控制器处理联动效果的分页控制器抽象父类.
//

#import "ZZSuperVC.h"
#import "ZZScrollPageViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZZChildVCDelegate <NSObject>

@optional
-(void)scrollViewIsScrolling:(UIScrollView *)scrollView;

@end

@interface ZZChildVC : ZZSuperVC<ZZScrollPageViewChildVcDelegate>

//代理
@property (nonatomic,  weak) id<ZZChildVCDelegate>              delegate;

//子控制器的当前滚动视图
@property (nonatomic, strong) UIScrollView                      *scrollView;

/**分类索引*/
@property (nonatomic, assign) int                               cate_id;

/**滚动视图的高*/
@property (nonatomic, assign) CGFloat                           scrollViewHeight;

/**子类如果重写了这个协议方法, 则需要调用父类*/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
