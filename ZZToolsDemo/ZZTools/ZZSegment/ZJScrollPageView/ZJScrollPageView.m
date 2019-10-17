//
//  ZZToolsDemo.m
//  ZZToolsDemo
//
//  Created by 刘猛 on 19/5/6.
//  Copyright © 2016年 刘猛. All rights reserved.
//

#import "ZJScrollPageView.h"

@interface ZJScrollPageView ()
@property (strong, nonatomic) ZJSegmentStyle *segmentStyle;
@property (weak, nonatomic) ZJScrollSegmentView *segmentView;
@property (weak, nonatomic) ZJContentView *contentView;

@property (weak, nonatomic) UIViewController *parentViewController;
@property (strong, nonatomic) NSArray *childVcs;
@property (strong, nonatomic) NSArray *titlesArray;

//LY新增
@property (nonatomic,assign)CGRect segmentViewFrame;
@property (nonatomic,assign)CGFloat bottomLineWidth;


@end
@implementation ZJScrollPageView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame segmentStyle:(ZJSegmentStyle *)segmentStyle titles:(NSArray<NSString *> *)titles parentViewController:(UIViewController *)parentViewController delegate:(id<ZJScrollPageViewDelegate>) delegate {
    if (self = [super initWithFrame:frame]) {
        self.segmentStyle = segmentStyle;
        self.delegate = delegate;
        self.parentViewController = parentViewController;
        self.titlesArray = titles.copy;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame segmentStyle:(ZJSegmentStyle *)segmentStyle titles:(NSArray<NSString *> *)titles segmentViewFrame:(CGRect)segmentViewFrame bottomLineWidth:(CGFloat)bottomLineWidth parentViewController:(UIViewController *)parentViewController delegate:(id<ZJScrollPageViewDelegate>) delegate{
    if (self = [super initWithFrame:frame]) {
        self.segmentStyle = segmentStyle;
        self.delegate = delegate;
        self.parentViewController = parentViewController;
        self.titlesArray = titles.copy;
        self.segmentViewFrame = segmentViewFrame;
        self.bottomLineWidth = bottomLineWidth;
        [self commonInit];
    }
    return self;
}


- (void)commonInit{
    // 触发懒加载
    self.segmentView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)dealloc {
    //NSLog(@"ZJScrollPageView--销毁");
}

#pragma mark - public helper

/** 给外界设置选中的下标的方法 */
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    [self.segmentView setSelectedIndex:selectedIndex animated:animated];
}

/**  给外界重新设置视图内容的标题的方法 */
- (void)reloadWithNewTitles:(NSArray<NSString *> *)newTitles {
    
    self.titlesArray = nil;
    self.titlesArray = newTitles.copy;
    
    [self.segmentView reloadTitlesWithNewTitles:self.titlesArray];
    [self.contentView reload];
}


#pragma mark - getter ---- setter

- (ZJContentView *)contentView {
    if (!_contentView) {
        ZJContentView *content = [[ZJContentView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.segmentView.frame), self.bounds.size.width, self.bounds.size.height - CGRectGetMaxY(self.segmentView.frame)) segmentView:self.segmentView parentViewController:self.parentViewController delegate:self.delegate];
        [self addSubview:content];
        _contentView = content;
    }
    
    return  _contentView;
}


- (ZJScrollSegmentView *)segmentView {
    if (!_segmentView) {
        __weak typeof(self) weakSelf = self;
        
        CGRect rect = self.segmentViewFrame.size.width > 0 ? self.segmentViewFrame : CGRectMake(0, 0, self.bounds.size.width, self.segmentStyle.segmentHeight);
        
        ZJScrollSegmentView *segment = [[ZJScrollSegmentView alloc] initWithFrame:rect bottomLineWidth:_bottomLineWidth segmentStyle:self.segmentStyle delegate:self.delegate titles:self.titlesArray titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
            
            [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0) animated:weakSelf.segmentStyle.isAnimatedContentViewWhenTitleClicked];
            
        }];
        [self addSubview:segment];
        _segmentView = segment;
    }
    return _segmentView;
}


- (NSArray *)childVcs {
    if (!_childVcs) {
        _childVcs = [NSArray array];
    }
    return _childVcs;
}

- (NSArray *)titlesArray {
    if (!_titlesArray) {
        _titlesArray = [NSArray array];
    }
    return _titlesArray;
}

- (void)setExtraBtnOnClick:(ExtraBtnOnClick)extraBtnOnClick {
    _extraBtnOnClick = extraBtnOnClick;
    self.segmentView.extraBtnOnClick = extraBtnOnClick;
}

@end
