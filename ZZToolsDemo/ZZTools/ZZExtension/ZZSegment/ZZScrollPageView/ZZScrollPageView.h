//
//  ZZToolsDemo.h
//  ZZToolsDemo
//
//  Created by 刘猛 on 19/5/6.
//  Copyright © 2016年 刘猛. All rights reserved.
//

#import "ZZTitleView.h"
#import <UIKit/UIKit.h>
#import "ZZContentView.h"

@interface ZZScrollPageView : UIView
typedef void(^ExtraBtnOnClick)(UIButton *extraBtn);

@property (copy, nonatomic) ExtraBtnOnClick                 extraBtnOnClick;

@property (weak, nonatomic, readonly) ZZContentView         *contentView;

@property (weak, nonatomic, readonly) ZZScrollSegmentView   *segmentView;

/**必须设置代理并且实现相应的方法*/
@property(weak, nonatomic)id<ZZScrollPageViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame segmentStyle:(ZZSegmentStyle *)segmentStyle titles:(NSArray<NSString *> *)titles parentViewController:(UIViewController *)parentViewController delegate:(id<ZZScrollPageViewDelegate>) delegate ;

/**提供自定义sectionView*/
- (instancetype)initWithFrame:(CGRect)frame segmentStyle:(ZZSegmentStyle *)segmentStyle titles:(NSArray<NSString *> *)titles segmentViewFrame:(CGRect)segmentViewFrame bottomLineWidth:(CGFloat)bottomLineWidth parentViewController:(UIViewController *)parentViewController delegate:(id<ZZScrollPageViewDelegate>) delegate;

/**给外界设置选中的下标的方法 */
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;

/**给外界重新设置的标题的方法(同时会重新加载页面的内容) */
- (void)reloadWithNewTitles:(NSArray<NSString *> *)newTitles;
@end
