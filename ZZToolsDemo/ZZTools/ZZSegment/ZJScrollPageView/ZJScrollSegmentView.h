//
//  ZJScrollSegmentView.h
//  ZZToolsDemo
//
//  Created by 刘猛 on 19/5/6.
//  Copyright © 2016年 刘猛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJSegmentStyle.h"
#import "ZJScrollPageViewDelegate.h"

@class ZJTitleView;
@class ZJSegmentStyle;

typedef void(^ExtraBtnOnClick)(UIButton *extraBtn);
typedef void(^TitleBtnOnClickBlock)(ZJTitleView *titleView, NSInteger index);

@interface ZJScrollSegmentView : UIView

// 所有的标题
@property (nonatomic, strong) NSArray                       *titles;
@property (nonatomic, strong) ZJSegmentStyle                *segmentStyle;
@property (nonatomic,   copy) ExtraBtnOnClick               extraBtnOnClick;
@property (nonatomic,   weak) id<ZJScrollPageViewDelegate>  delegate;
@property (nonatomic, strong) UIImage                       *backgroundImage;

- (instancetype)initWithFrame:(CGRect )frame segmentStyle:(ZJSegmentStyle *)segmentStyle delegate:(id<ZJScrollPageViewDelegate>)delegate titles:(NSArray *)titles titleDidClick:(TitleBtnOnClickBlock)titleDidClick;

- (instancetype)initWithFrame:(CGRect )frame bottomLineWidth:(CGFloat)bottomLineWidth segmentStyle:(ZJSegmentStyle *)segmentStyle delegate:(id<ZJScrollPageViewDelegate>)delegate titles:(NSArray *)titles titleDidClick:(TitleBtnOnClickBlock)titleDidClick;

/** 切换下标的时候根据progress同步设置UI*/
- (void)adjustUIWithProgress:(CGFloat)progress oldIndex:(NSInteger)oldIndex currentIndex:(NSInteger)currentIndex;

/** 让选中的标题居中*/
- (void)adjustTitleOffSetToCurrentIndex:(NSInteger)currentIndex;

/** 设置选中的下标*/
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated;

/** 重新刷新标题的内容*/
- (void)reloadTitlesWithNewTitles:(NSArray *)titles;

- (void)reloadImageIsShow:(BOOL)imageIsShow alpha:(CGFloat)alpha lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth;

@end
