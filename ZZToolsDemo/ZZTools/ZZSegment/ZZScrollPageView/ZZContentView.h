//
//  ZZContentView.h
//  ZZToolsDemo
//
//  Created by 刘猛 on 19/5/6.
//  Copyright © 2016年 刘猛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZCollectionView.h"
#import "ZZScrollSegmentView.h"
#import "ZZScrollPageViewDelegate.h"
#import "UIViewController+ZZExtension.h"

@interface ZZContentView : UIView

/**是否正在切换item*/
@property (nonatomic,  copy) NSString                                                                               *isChangingItem;

/** 必须设置代理和实现相关的方法*/
@property (weak, nonatomic)id <ZZScrollPageViewDelegate>                                                            delegate;

@property (nonatomic, strong, readonly) ZZCollectionView                                                            *collectionView;

///当前控制器
@property (nonatomic, strong, readonly) UIViewController<ZZScrollPageViewChildVcDelegate>                           *currentChildVc;

///所有的子控制器
@property (nonatomic, strong) NSMutableDictionary<NSString *, UIViewController<ZZScrollPageViewChildVcDelegate> *>  *childVcsDic;

/**初始化方法*/
- (instancetype)initWithFrame:(CGRect)frame segmentView:(ZZScrollSegmentView *)segmentView parentViewController:(UIViewController *)parentViewController delegate:(id<ZZScrollPageViewDelegate>) delegate;

/** 给外界可以设置ContentOffSet的方法 */
- (void)setContentOffSet:(CGPoint)offset animated:(BOOL)animated;

/** 给外界 重新加载内容的方法 */
- (void)reload;

@end
