//
//  ZJContentView.h
//  ZZToolsDemo
//
//  Created by 刘猛 on 19/5/6.
//  Copyright © 2016年 刘猛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJCollectionView.h"
#import "ZJScrollSegmentView.h"
#import "ZJScrollPageViewDelegate.h"
#import "UIViewController+ZZExtension.h"

@interface ZJContentView : UIView

/**是否正在切换item*/
@property (nonatomic,  copy) NSString                                                                               *isChangingItem;

/** 必须设置代理和实现相关的方法*/
@property (weak, nonatomic)id <ZJScrollPageViewDelegate>                                                            delegate;

@property (nonatomic, strong, readonly) ZJCollectionView                                                            *collectionView;

///当前控制器
@property (nonatomic, strong, readonly) UIViewController<ZJScrollPageViewChildVcDelegate>                           *currentChildVc;

///所有的子控制器
@property (nonatomic, strong) NSMutableDictionary<NSString *, UIViewController<ZJScrollPageViewChildVcDelegate> *>  *childVcsDic;

/**初始化方法*/
- (instancetype)initWithFrame:(CGRect)frame segmentView:(ZJScrollSegmentView *)segmentView parentViewController:(UIViewController *)parentViewController delegate:(id<ZJScrollPageViewDelegate>) delegate;

/** 给外界可以设置ContentOffSet的方法 */
- (void)setContentOffSet:(CGPoint)offset animated:(BOOL)animated;

/** 给外界 重新加载内容的方法 */
- (void)reload;

@end
