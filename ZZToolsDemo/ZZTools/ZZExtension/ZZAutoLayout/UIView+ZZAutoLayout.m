//
//  UIView+ZZAutoLayout.m
//
//  Created by gsd on 15/10/6.
//  Copyright (c) 2015年 gsd. All rights reserved.
//

/*
 
 *********************************************************************************
 *                                                                                *
 * 在您使用此自动布局库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并  *
 * 帮您解决问题。                                                                    *
 * QQ    : 2689718696(gsdios)                                                      *
 * Email : gsdios@126.com                                                          *
 * GitHub: https://github.com/gsdios                                               *
 * 新浪微博:Gzz_iOS                                                                 *
 *                                                                                *
 *********************************************************************************
 
 */

#import "UIView+ZZAutoLayout.h"
#import "UITableView+ZZAutoTableViewCellHeight.h"

#import <objc/runtime.h>

Class ZZCellContVClass()
{
    // 为了应付SB审核的SB条款 The use of non-public APIs is not permitted on the App Store because it can lead to a poor user experience should these APIs change.
    static UITableViewCell *tempCell;
    
    if (!tempCell) {
        tempCell = [UITableViewCell new];
    }
    return [tempCell.contentView class];
}

@interface ZZAutoLayoutModel ()

@property (nonatomic, strong) ZZAutoLayoutModelItem *width;
@property (nonatomic, strong) ZZAutoLayoutModelItem *height;
@property (nonatomic, strong) ZZAutoLayoutModelItem *left;
@property (nonatomic, strong) ZZAutoLayoutModelItem *top;
@property (nonatomic, strong) ZZAutoLayoutModelItem *right;
@property (nonatomic, strong) ZZAutoLayoutModelItem *bottom;
@property (nonatomic, strong) NSNumber *zz_centerX;
@property (nonatomic, strong) NSNumber *zz_centerY;

@property (nonatomic, strong) NSNumber *maxWidth;
@property (nonatomic, strong) NSNumber *maxHeight;
@property (nonatomic, strong) NSNumber *minWidth;
@property (nonatomic, strong) NSNumber *minHeight;

@property (nonatomic, strong) ZZAutoLayoutModelItem *ratio_width;
@property (nonatomic, strong) ZZAutoLayoutModelItem *ratio_height;
@property (nonatomic, strong) ZZAutoLayoutModelItem *ratio_left;
@property (nonatomic, strong) ZZAutoLayoutModelItem *ratio_top;
@property (nonatomic, strong) ZZAutoLayoutModelItem *ratio_right;
@property (nonatomic, strong) ZZAutoLayoutModelItem *ratio_bottom;

@property (nonatomic, strong) ZZAutoLayoutModelItem *equalLeft;
@property (nonatomic, strong) ZZAutoLayoutModelItem *equalRight;
@property (nonatomic, strong) ZZAutoLayoutModelItem *equalTop;
@property (nonatomic, strong) ZZAutoLayoutModelItem *equalBottom;
@property (nonatomic, strong) ZZAutoLayoutModelItem *equalzz_centerX;
@property (nonatomic, strong) ZZAutoLayoutModelItem *equalzz_centerY;

@property (nonatomic, strong) ZZAutoLayoutModelItem *widthEqualHeight;
@property (nonatomic, strong) ZZAutoLayoutModelItem *heightEqualWidth;

@property (nonatomic, strong) ZZAutoLayoutModelItem *lastModelItem;

@end

@implementation ZZAutoLayoutModel

@synthesize leftSpace2View = _leftSpace2View;
@synthesize rightSpace2View = _rightSpace2View;
@synthesize topSpace2View = _topSpace2View;
@synthesize bottomSpace2View = _bottomSpace2View;
@synthesize zz_widthIs = _zz_widthIs;
@synthesize zz_heightIs = _zz_heightIs;
@synthesize widthRatioToView = _widthRatioToView;
@synthesize heightRatioToView = _heightRatioToView;
@synthesize leftEqualToView = _leftEqualToView;
@synthesize rightEqualToView = _rightEqualToView;
@synthesize topEqualToView = _topEqualToView;
@synthesize bottomEqualToView = _bottomEqualToView;
@synthesize zz_centerXEqualToView = _zz_centerXEqualToView;
@synthesize zz_centerYEqualToView = _zz_centerYEqualToView;
@synthesize zz_xIs = _zz_xIs;
@synthesize zz_yIs = _zz_yIs;
@synthesize zz_centerzz_xIs = _zz_centerzz_xIs;
@synthesize zz_centerzz_yIs = _zz_centerzz_yIs;
@synthesize zz_autoHeightRatio = _zz_autoHeightRatio;
@synthesize autoWidthRatio = _autoWidthRatio;
@synthesize spaceToSuperView = _spaceToSuperView;
@synthesize maxzz_widthIs = _maxzz_widthIs;
@synthesize maxzz_heightIs = _maxzz_heightIs;
@synthesize minzz_widthIs = _minzz_widthIs;
@synthesize minzz_heightIs = _minzz_heightIs;
@synthesize widthEqualToHeight = _widthEqualToHeight;
@synthesize heightEqualToWidth = _heightEqualToWidth;
@synthesize offset = _offset;


- (ZZMarginToView)leftSpace2View
{
    if (!_leftSpace2View) {
        _leftSpace2View = [self marginToViewblockWithKey:@"left"];
    }
    return _leftSpace2View;
}

- (ZZMarginToView)rightSpace2View
{
    if (!_rightSpace2View) {
        _rightSpace2View = [self marginToViewblockWithKey:@"right"];
    }
    return _rightSpace2View;
}

- (ZZMarginToView)topSpace2View
{
    if (!_topSpace2View) {
        _topSpace2View = [self marginToViewblockWithKey:@"top"];
    }
    return _topSpace2View;
}

- (ZZMarginToView)bottomSpace2View
{
    if (!_bottomSpace2View) {
        _bottomSpace2View = [self marginToViewblockWithKey:@"bottom"];
    }
    return _bottomSpace2View;
}

- (ZZMarginToView)marginToViewblockWithKey:(NSString *)key
{
    __weak typeof(self) weakSelf = self;
    return ^(id viewOrViewsArray, CGFloat value) {
        ZZAutoLayoutModelItem *item = [ZZAutoLayoutModelItem new];
        item.value = @(value);
        if ([viewOrViewsArray isKindOfClass:[UIView class]]) {
            item.refView = viewOrViewsArray;
        } else if ([viewOrViewsArray isKindOfClass:[NSArray class]]) {
            item.refViewsArray = [viewOrViewsArray copy];
        }
        [weakSelf setValue:item forKey:key];
        return weakSelf;
    };
}

- (ZZWidthHeight)zz_widthIs
{
    if (!_zz_widthIs) {
        __weak typeof(self) weakSelf = self;
        _zz_widthIs = ^(CGFloat value) {
            weakSelf.needsAutoResizeView.fixedWidth = @(value);
            ZZAutoLayoutModelItem *widthItem = [ZZAutoLayoutModelItem new];
            widthItem.value = @(value);
            weakSelf.width = widthItem;
            return weakSelf;
        };
    }
    return _zz_widthIs;
}

- (ZZWidthHeight)zz_heightIs
{
    if (!_zz_heightIs) {
        __weak typeof(self) weakSelf = self;
        _zz_heightIs = ^(CGFloat value) {
            weakSelf.needsAutoResizeView.fixedHeight = @(value);
            ZZAutoLayoutModelItem *heightItem = [ZZAutoLayoutModelItem new];
            heightItem.value = @(value);
            weakSelf.height = heightItem;
            return weakSelf;
        };
    }
    return _zz_heightIs;
}

- (ZZWidthHeightEqualToView)widthRatioToView
{
    if (!_widthRatioToView) {
        __weak typeof(self) weakSelf = self;
        _widthRatioToView = ^(UIView *view, CGFloat value) {
            weakSelf.ratio_width = [ZZAutoLayoutModelItem new];
            weakSelf.ratio_width.value = @(value);
            weakSelf.ratio_width.refView = view;
            return weakSelf;
        };
    }
    return _widthRatioToView;
}

- (ZZWidthHeightEqualToView)heightRatioToView
{
    if (!_heightRatioToView) {
        __weak typeof(self) weakSelf = self;
        _heightRatioToView = ^(UIView *view, CGFloat value) {
            weakSelf.ratio_height = [ZZAutoLayoutModelItem new];
            weakSelf.ratio_height.refView = view;
            weakSelf.ratio_height.value = @(value);
            return weakSelf;
        };
    }
    return _heightRatioToView;
}

- (ZZWidthHeight)maxzz_widthIs
{
    if (!_maxzz_widthIs) {
        _maxzz_widthIs = [self limitingWidthHeightWithKey:@"maxWidth"];
    }
    return _maxzz_widthIs;
}

- (ZZWidthHeight)maxzz_heightIs
{
    if (!_maxzz_heightIs) {
        _maxzz_heightIs = [self limitingWidthHeightWithKey:@"maxHeight"];
    }
    return _maxzz_heightIs;
}

- (ZZWidthHeight)minzz_widthIs
{
    if (!_minzz_widthIs) {
        _minzz_widthIs = [self limitingWidthHeightWithKey:@"minWidth"];
    }
    return _minzz_widthIs;
}

- (ZZWidthHeight)minzz_heightIs
{
    if (!_minzz_heightIs) {
        _minzz_heightIs = [self limitingWidthHeightWithKey:@"minHeight"];
    }
    return _minzz_heightIs;
}


- (ZZWidthHeight)limitingWidthHeightWithKey:(NSString *)key
{
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat value) {
        [weakSelf setValue:@(value) forKey:key];
        
        return weakSelf;
    };
}


- (ZZMarginEqualToView)marginEqualToViewBlockWithKey:(NSString *)key
{
    __weak typeof(self) weakSelf = self;
    
    return ^(UIView *view) {
        ZZAutoLayoutModelItem *item = [ZZAutoLayoutModelItem new];
        item.refView = view;
        [weakSelf setValue:item forKey:key];
        weakSelf.lastModelItem = item;
        if ([view isKindOfClass:ZZCellContVClass()] && ([key isEqualToString:@"equalzz_centerY"] || [key isEqualToString:@"equalBottom"])) {
            view.zz_shouldReadjustFrameBeforeStoreCache = YES;
        }
        return weakSelf;
    };
}

- (ZZMarginEqualToView)leftEqualToView
{
    if (!_leftEqualToView) {
        _leftEqualToView = [self marginEqualToViewBlockWithKey:@"equalLeft"];
    }
    return _leftEqualToView;
}

- (ZZMarginEqualToView)rightEqualToView
{
    if (!_rightEqualToView) {
        _rightEqualToView = [self marginEqualToViewBlockWithKey:@"equalRight"];
    }
    return _rightEqualToView;
}

- (ZZMarginEqualToView)topEqualToView
{
    if (!_topEqualToView) {
        _topEqualToView = [self marginEqualToViewBlockWithKey:@"equalTop"];
    }
    return _topEqualToView;
}

- (ZZMarginEqualToView)bottomEqualToView
{
    if (!_bottomEqualToView) {
        _bottomEqualToView = [self marginEqualToViewBlockWithKey:@"equalBottom"];
    }
    return _bottomEqualToView;
}

- (ZZMarginEqualToView)zz_centerXEqualToView
{
    if (!_zz_centerXEqualToView) {
        _zz_centerXEqualToView = [self marginEqualToViewBlockWithKey:@"equalzz_centerX"];
    }
    return _zz_centerXEqualToView;
}

- (ZZMarginEqualToView)zz_centerYEqualToView
{
    if (!_zz_centerYEqualToView) {
        _zz_centerYEqualToView = [self marginEqualToViewBlockWithKey:@"equalzz_centerY"];
    }
    return _zz_centerYEqualToView;
}


- (ZZMargin)marginBlockWithKey:(NSString *)key
{
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat value) {
        
        if ([key isEqualToString:@"x"]) {
            weakSelf.needsAutoResizeView.left_zz = value;
        } else if ([key isEqualToString:@"y"]) {
            weakSelf.needsAutoResizeView.top_zz = value;
        } else if ([key isEqualToString:@"zz_centerX"]) {
            weakSelf.zz_centerX = @(value);
        } else if ([key isEqualToString:@"zz_centerY"]) {
            weakSelf.zz_centerY = @(value);
        }
        
        return weakSelf;
    };
}

- (ZZMargin)zz_xIs
{
    if (!_zz_xIs) {
        _zz_xIs = [self marginBlockWithKey:@"x"];
    }
    return _zz_xIs;
}

- (ZZMargin)zz_yIs
{
    if (!_zz_yIs) {
        _zz_yIs = [self marginBlockWithKey:@"y"];
    }
    return _zz_yIs;
}

- (ZZMargin)zz_centerzz_xIs
{
    if (!_zz_centerzz_xIs) {
        _zz_centerzz_xIs = [self marginBlockWithKey:@"zz_centerX"];
    }
    return _zz_centerzz_xIs;
}

- (ZZMargin)zz_centerzz_yIs
{
    if (!_zz_centerzz_yIs) {
        _zz_centerzz_yIs = [self marginBlockWithKey:@"zz_centerY"];
    }
    return _zz_centerzz_yIs;
}

- (ZZAutoHeightWidth)zz_autoHeightRatio
{
    __weak typeof(self) weakSelf = self;
    
    if (!_zz_autoHeightRatio) {
        _zz_autoHeightRatio = ^(CGFloat ratioaValue) {
            weakSelf.needsAutoResizeView.zz_autoHeightRatioValue = @(ratioaValue);
            return weakSelf;
        };
    }
    return _zz_autoHeightRatio;
}

- (ZZAutoHeightWidth)autoWidthRatio
{
    __weak typeof(self) weakSelf = self;
    
    if (!_autoWidthRatio) {
        _autoWidthRatio = ^(CGFloat ratioaValue) {
            weakSelf.needsAutoResizeView.zz_autoWidthRatioValue = @(ratioaValue);
            return weakSelf;
        };
    }
    return _autoWidthRatio;
}

- (ZZSpaceToSuperView)spaceToSuperView
{
    __weak typeof(self) weakSelf = self;
    
    if (!_spaceToSuperView) {
        _spaceToSuperView = ^(UIEdgeInsets insets) {
            UIView *superView = weakSelf.needsAutoResizeView.superview;
            if (superView) {
                weakSelf.needsAutoResizeView.zz_layout
                .leftSpace2View(superView, insets.left)
                .topSpace2View(superView, insets.top)
                .rightSpace2View(superView, insets.right)
                .bottomSpace2View(superView, insets.bottom);
            }
        };
    }
    return _spaceToSuperView;
}

- (ZZSameWidthHeight)widthEqualToHeight
{
    __weak typeof(self) weakSelf = self;
    
    if (!_widthEqualToHeight) {
        _widthEqualToHeight = ^() {
            weakSelf.widthEqualHeight = [ZZAutoLayoutModelItem new];
            weakSelf.lastModelItem = weakSelf.widthEqualHeight;
            // 主动触发一次赋值操作
            weakSelf.needsAutoResizeView.height_zz = weakSelf.needsAutoResizeView.height_zz;
            return weakSelf;
        };
    }
    return _widthEqualToHeight;
}

- (ZZSameWidthHeight)heightEqualToWidth
{
    __weak typeof(self) weakSelf = self;
    
    if (!_heightEqualToWidth) {
        _heightEqualToWidth = ^() {
            weakSelf.heightEqualWidth = [ZZAutoLayoutModelItem new];
            weakSelf.lastModelItem = weakSelf.heightEqualWidth;
            // 主动触发一次赋值操作
            weakSelf.needsAutoResizeView.width_zz = weakSelf.needsAutoResizeView.width_zz;
            return weakSelf;
        };
    }
    return _heightEqualToWidth;
}

- (ZZAutoLayoutModel *(^)(CGFloat))offset
{
    __weak typeof(self) weakSelf = self;
    if (!_offset) {
        _offset = ^(CGFloat offset) {
            weakSelf.lastModelItem.offset = offset;
            return weakSelf;
        };
    }
    return _offset;
}

@end


@implementation UIView (ZZzz_autoHeightWidth)

- (ZZUIViewCategoryManager *)zz_categoryManager
{
    ZZUIViewCategoryManager *manager = objc_getAssociatedObject(self, _cmd);
    if (!manager) {
        objc_setAssociatedObject(self, _cmd, [ZZUIViewCategoryManager new], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, _cmd);
}

- (void)zz_setupzz_autoHeightWithBottomView:(UIView *)bottomView bottomMargin:(CGFloat)bottomMargin
{
    if (!bottomView) return;
    
    [self zz_setupzz_autoHeightWithBottomViewsArray:@[bottomView] bottomMargin:bottomMargin];
}

- (void)zz_setupAutoWidthWithRightView:(UIView *)rightView rightMargin:(CGFloat)rightMargin
{
    if (!rightView) return;
    
    self.zz_rightViewsArray = @[rightView];
    self.zz_rightViewRightMargin = rightMargin;
}

- (void)zz_setupzz_autoHeightWithBottomViewsArray:(NSArray *)bottomViewsArray bottomMargin:(CGFloat)bottomMargin
{
    if (!bottomViewsArray) return;
    
    // 清空之前的view
    [self.zz_bottomViewsArray removeAllObjects];
    [self.zz_bottomViewsArray addObjectsFromArray:bottomViewsArray];
    self.zz_bottomViewBottomMargin = bottomMargin;
}

- (void)zz_clearAutoHeigtSettings
{
    [self.zz_bottomViewsArray removeAllObjects];
}

- (void)zz_clearAutoWidthSettings
{
    self.zz_rightViewsArray = nil;
}

- (void)zz_updateLayout
{
    [self.superview layoutSubviews];
}

- (void)zz_updateLayoutWithCellContentView:(UIView *)cellContentView
{
    if (cellContentView.zz_indexPath) {
        [cellContentView zz_clearSubviewsAutoLayoutFrameCaches];
    }
    [self zz_updateLayout];
}

- (CGFloat)zz_autoHeight
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)zz_setZz_autoHeight:(CGFloat)zz_autoHeight
{
    objc_setAssociatedObject(self, @selector(zz_autoHeight), @(zz_autoHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)zz_bottomViewsArray
{
    NSMutableArray *array = objc_getAssociatedObject(self, _cmd);
    if (!array) {
        objc_setAssociatedObject(self, _cmd, [NSMutableArray new], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, _cmd);
}

- (NSArray *)zz_rightViewsArray
{
    return [[self zz_categoryManager] rightViewsArray];
}

- (void)setZz_rightViewsArray:(NSArray *)zz_rightViewsArray
{
    [[self zz_categoryManager] setRightViewsArray:zz_rightViewsArray];
}

- (CGFloat)zz_bottomViewBottomMargin
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)zz_setZz_bottomViewBottomMargin:(CGFloat)zz_bottomViewBottomMargin
{
    objc_setAssociatedObject(self, @selector(zz_bottomViewBottomMargin), @(zz_bottomViewBottomMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)zz_setZz_rightViewRightMargin:(CGFloat)zz_rightViewRightMargin
{
    [[self zz_categoryManager] setRightViewRightMargin:zz_rightViewRightMargin];
}

- (CGFloat)zz_rightViewRightMargin
{
    return [[self zz_categoryManager] rightViewRightMargin];
}

@end

@implementation UIView (ZZLayoutExtention)

- (void (^)(CGRect))zz_didFinishAutoLayoutBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setZz_didFinishAutoLayoutBlock:(void (^)(CGRect))zz_didFinishAutoLayoutBlock
{
    objc_setAssociatedObject(self, @selector(zz_didFinishAutoLayoutBlock), zz_didFinishAutoLayoutBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSNumber *)zz_cornerRadius
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setZz_cornerRadius:(NSNumber *)zz_cornerRadius {
    objc_setAssociatedObject(self, @selector(zz_cornerRadius), zz_cornerRadius, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)zz_cornerRadiusFromWidthRatio
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setZz_cornerRadiusFromWidthRatio:(NSNumber *)zz_cornerRadiusFromWidthRatio
{
    objc_setAssociatedObject(self, @selector(zz_cornerRadiusFromWidthRatio), zz_cornerRadiusFromWidthRatio, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSNumber *)zz_cornerRadiusFromHeightRatio
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setZz_cornerRadiusFromHeightRatio:(NSNumber *)zz_cornerRadiusFromHeightRatio
{
    objc_setAssociatedObject(self, @selector(zz_cornerRadiusFromHeightRatio), zz_cornerRadiusFromHeightRatio, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)zz_equalWidthSubviews
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setZz_equalWidthSubviews:(NSArray *)zz_equalWidthSubviews
{
    objc_setAssociatedObject(self, @selector(zz_equalWidthSubviews), zz_equalWidthSubviews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)zz_addSubviews:(NSArray *)subviews
{
    [subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if ([view isKindOfClass:[UIView class]]) {
            [self addSubview:view];
        }
    }];
}

@end

@implementation UIView (ZZAutoFlowItems)

- (void)zz_setupAutoWidthFlowItems:(NSArray *)viewsArray withPerRowItemsCount:(NSInteger)perRowItemsCount verticalMargin:(CGFloat)verticalMargin horizontalMargin:(CGFloat)horizontalMagin zz_verticalEdgeInset:(CGFloat)vInset zz_horizontalEdgeInset:(CGFloat)hInset
{
    self.zz_categoryManager.flowItems = viewsArray;
    self.zz_categoryManager.perRowItemsCount = perRowItemsCount;
    self.zz_categoryManager.verticalMargin = verticalMargin;
    self.zz_categoryManager.horizontalMargin = horizontalMagin;
    self.zz_verticalEdgeInset = vInset;
    self.zz_horizontalEdgeInset = hInset;
    
    self.zz_categoryManager.lastWidth = 0;
    
    if (viewsArray.count) {
        [self zz_setupzz_autoHeightWithBottomView:viewsArray.lastObject bottomMargin:vInset];
    } else {
        [self zz_clearAutoHeigtSettings];
    }
}

- (void)zz_clearAutoWidthFlowItemsSettings
{
    [self zz_setupAutoWidthFlowItems:nil withPerRowItemsCount:0 verticalMargin:0 horizontalMargin:0 zz_verticalEdgeInset:0 zz_horizontalEdgeInset:0];
}

- (void)zz_setupAutoMarginFlowItems:(NSArray *)viewsArray withPerRowItemsCount:(NSInteger)perRowItemsCount itemWidth:(CGFloat)itemWidth verticalMargin:(CGFloat)verticalMargin zz_verticalEdgeInset:(CGFloat)vInset zz_horizontalEdgeInset:(CGFloat)hInset
{
    self.zz_categoryManager.shouldShowAsAutoMarginViews = YES;
    self.zz_categoryManager.flowItemWidth = itemWidth;
    [self zz_setupAutoWidthFlowItems:viewsArray withPerRowItemsCount:perRowItemsCount verticalMargin:verticalMargin horizontalMargin:0 zz_verticalEdgeInset:vInset zz_horizontalEdgeInset:hInset];
}

- (void)zz_clearAutoMarginFlowItemsSettings
{
    [self zz_setupAutoMarginFlowItems:nil withPerRowItemsCount:0 itemWidth:0 verticalMargin:0 zz_verticalEdgeInset:0 zz_horizontalEdgeInset:0];
}

- (void)setZz_horizontalEdgeInset:(CGFloat)zz_horizontalEdgeInset
{
    self.zz_categoryManager.zz_horizontalEdgeInset = zz_horizontalEdgeInset;
}

- (CGFloat)zz_horizontalEdgeInset
{
    return self.zz_categoryManager.zz_horizontalEdgeInset;
}

- (void)setZz_verticalEdgeInset:(CGFloat)zz_verticalEdgeInset
{
    self.zz_categoryManager.zz_verticalEdgeInset = zz_verticalEdgeInset;
}

- (CGFloat)zz_verticalEdgeInset
{
    return self.zz_categoryManager.zz_verticalEdgeInset;
}

@end

@implementation UIScrollView (ZZAutoContentSize)

- (void)zz_setupAutoContentSizeWithBottomView:(UIView *)bottomView bottomMargin:(CGFloat)bottomMargin
{
    [self zz_setupzz_autoHeightWithBottomView:bottomView bottomMargin:bottomMargin];
}

- (void)zz_setupAutoContentSizeWithRightView:(UIView *)rightView rightMargin:(CGFloat)rightMargin
{
    if (!rightView) return;
    
    self.zz_rightViewsArray = @[rightView];
    self.zz_rightViewRightMargin = rightMargin;
}

@end

@implementation UILabel (ZZLabelAutoResize)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSArray *selStringsArray = @[@"setText:"];
        
        [selStringsArray enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {
            NSString *mySelString = [@"zz_" stringByAppendingString:selString];
            
            Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
            Method myMethod = class_getInstanceMethod(self, NSSelectorFromString(mySelString));
            method_exchangeImplementations(originalMethod, myMethod);
        }];
    });
}

- (void)zz_setText:(NSString *)text
{
    // 如果程序崩溃在这行代码说明是你的label在执行“setText”方法时出了问题而不是在此自动布局库内部出现了问题，请检查你的“setText”方法
    [self zz_setText:text];
    
    
    if (self.zz_maxWidth) {
        [self sizeToFit];
    } else if (self.zz_autoHeightRatioValue) {
        self.size_zz = CGSizeZero;
    }
}

- (BOOL)isAttributedContent
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsAttributedContent:(BOOL)isAttributedContent
{
    objc_setAssociatedObject(self, @selector(isAttributedContent), @(isAttributedContent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSingleLineAutoResizeWithMaxWidth:(CGFloat)maxWidth
{
    self.zz_maxWidth = @(maxWidth);
}

- (void)setMaxNumberOfLinesToShow:(NSInteger)lineCount
{
    NSAssert(self.ownLayoutModel, @"请在布局完成之后再做此步设置！");
    if (lineCount > 0) {
        if (self.isAttributedContent) {
            NSDictionary *attrs = [self.attributedText attributesAtIndex:0 effectiveRange:nil];
            NSMutableParagraphStyle *paragraphStyle = attrs[NSParagraphStyleAttributeName];
            self.zz_layout.maxzz_heightIs((self.font.lineHeight) * lineCount + paragraphStyle.lineSpacing * (lineCount - 1) + 0.1);
        } else {
            self.zz_layout.maxzz_heightIs(self.font.lineHeight * lineCount + 0.1);
        }
    } else {
        self.zz_layout.maxzz_heightIs(MAXFLOAT);
    }
}

@end

@implementation UIButton (ZZExtention)

- (void)zz_setupAutoSizeWithHorizontalPadding:(CGFloat)hPadding buttonHeight:(CGFloat)buttonHeight
{
    self.fixedHeight = @(buttonHeight);
    
    self.titleLabel.zz_layout
    .leftSpace2View(self, hPadding)
    .topEqualToView(self)
    .zz_heightIs(buttonHeight);
    
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:MAXFLOAT];
    [self zz_setupAutoWidthWithRightView:self.titleLabel rightMargin:hPadding];
}

@end


@implementation ZZAutoLayoutModelItem

- (instancetype)init
{
    if (self = [super init]) {
        _offset = 0;
    }
    return self;
}

@end


@implementation UIView (ZZAutoLayout)

+ (void)load
{
    if (self == [UIView class]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            NSArray *selStringsArray = @[@"layoutSubviews"];
            
            [selStringsArray enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {
                NSString *mySelString = [@"zz_" stringByAppendingString:selString];
                
                Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
                Method myMethod = class_getInstanceMethod(self, NSSelectorFromString(mySelString));
                method_exchangeImplementations(originalMethod, myMethod);
            }];
        });
    }
}

#pragma mark - properties

- (NSMutableArray *)autoLayoutModelsArray
{
    if (!objc_getAssociatedObject(self, _cmd)) {
        objc_setAssociatedObject(self, _cmd, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, _cmd);
}

- (NSNumber *)fixedWidth
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFixedWidth:(NSNumber *)fixedWidth
{
    if (fixedWidth) {
        self.width_zz = [fixedWidth floatValue];
    }
    objc_setAssociatedObject(self, @selector(fixedWidth), fixedWidth, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)fixedHeight
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFixedHeight:(NSNumber *)fixedHeight
{
    if (fixedHeight) {
        self.height_zz = [fixedHeight floatValue];
    }
    objc_setAssociatedObject(self, @selector(fixedHeight), fixedHeight, OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)zz_autoHeightRatioValue
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setZz_autoHeightRatioValue:(NSNumber *)zz_autoHeightRatioValue
{
    objc_setAssociatedObject(self, @selector(zz_autoHeightRatioValue), zz_autoHeightRatioValue, OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)zz_autoWidthRatioValue{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setZz_autoWidthRatioValue:(NSNumber *)zz_autoWidthRatioValue {
    objc_setAssociatedObject(self, @selector(zz_autoWidthRatioValue), zz_autoWidthRatioValue, OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)zz_maxWidth
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setZz_maxWidth:(NSNumber *)zz_maxWidth
{
    objc_setAssociatedObject(self, @selector(zz_maxWidth), zz_maxWidth, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)zz_useCellFrameCacheWithIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableview
{
    self.zz_indexPath = indexPath;
    self.zz_tableView = tableview;
}

- (UITableView *)zz_tableView
{
    return self.zz_categoryManager.zz_tableView;
}

- (void)setZz_tableView:(UITableView *)zz_tableView
{
    if ([self isKindOfClass:[UITableViewCell class]]) {
        [(UITableViewCell *)self contentView].zz_tableView = zz_tableView;
    }
    self.zz_categoryManager.zz_tableView = zz_tableView;
}

- (NSIndexPath *)zz_indexPath
{
    return self.zz_categoryManager.zz_indexPath;
}

- (void)setZz_indexPath:(NSIndexPath *)zz_indexPath
{
    if ([self isKindOfClass:[UITableViewCell class]]) {
        [(UITableViewCell *)self contentView].zz_indexPath = zz_indexPath;
    }
    self.zz_categoryManager.zz_indexPath = zz_indexPath;
}

- (ZZAutoLayoutModel *)ownLayoutModel
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setOwnLayoutModel:(ZZAutoLayoutModel *)ownLayoutModel
{
    objc_setAssociatedObject(self, @selector(ownLayoutModel), ownLayoutModel, OBJC_ASSOCIATION_RETAIN);
}

- (ZZAutoLayoutModel *)zz_layout
{
    
#ifdef ZZDebugWithAssert
    /*
     卡在这里说明你的要自动布局的view在没有添加到父view的情况下就开始设置布局,你需要这样：
     1.  UIView *view = [UIView new];
     2.  [superView addSubview:view];
     3.  view.zz_layout
     .leftEqualToView()...
     */
    NSAssert(self.superview, @">>>>>>>>>在加入父view之后才可以做自动布局设置");
    
#endif
    
    ZZAutoLayoutModel *model = [self ownLayoutModel];
    if (!model) {
        model = [ZZAutoLayoutModel new];
        model.needsAutoResizeView = self;
        [self setOwnLayoutModel:model];
        [self.superview.autoLayoutModelsArray addObject:model];
    }
    
    return model;
}

- (ZZAutoLayoutModel *)zz_resetLayout
{
    /*
     * 方案待定
     [self zz_clearAutoLayoutSettings];
     return [self zz_layout];
     */
    
    ZZAutoLayoutModel *model = [self ownLayoutModel];
    ZZAutoLayoutModel *newModel = [ZZAutoLayoutModel new];
    newModel.needsAutoResizeView = self;
    [self zz_clearViewFrameCache];
    NSInteger index = 0;
    if (model) {
        index = [self.superview.autoLayoutModelsArray indexOfObject:model];
        [self.superview.autoLayoutModelsArray replaceObjectAtIndex:index withObject:newModel];
    } else {
        [self.superview.autoLayoutModelsArray addObject:newModel];
    }
    [self setOwnLayoutModel:newModel];
    [self zz_clearExtraAutoLayoutItems];
    return newModel;
}

- (ZZAutoLayoutModel *)zz_resetNewLayout
{
    [self zz_clearAutoLayoutSettings];
    [self zz_clearExtraAutoLayoutItems];
    return [self zz_layout];
}

- (BOOL)zz_isClosingAutoLayout
{
    return self.zz_categoryManager.zz_isClosingAutoLayout;
}

- (void)setZz_closeAutoLayout:(BOOL)zz_closeAutoLayout
{
    self.zz_categoryManager.zz_closeAutoLayout = zz_closeAutoLayout;
}

- (void)zz_removeFromSuperviewAndClearAutoLayoutSettings
{
    [self zz_clearAutoLayoutSettings];
    [self removeFromSuperview];
}

- (void)zz_clearAutoLayoutSettings
{
    ZZAutoLayoutModel *model = [self ownLayoutModel];
    if (model) {
        [self.superview.autoLayoutModelsArray removeObject:model];
        [self setOwnLayoutModel:nil];
    }
    [self zz_clearExtraAutoLayoutItems];
}

- (void)zz_clearExtraAutoLayoutItems
{
    if (self.zz_autoHeightRatioValue) {
        self.zz_autoHeightRatioValue = nil;
    }
    self.fixedHeight = nil;
    self.fixedWidth = nil;
}

- (void)zz_clearViewFrameCache
{
    self.frame = CGRectZero;
}

- (void)zz_clearSubviewsAutoLayoutFrameCaches
{
    if (self.zz_tableView && self.zz_indexPath) {
        [self.zz_tableView.cellzz_autoHeightManager clearHeightCacheOfIndexPaths:@[self.zz_indexPath]];
        return;
    }
    
    if (self.autoLayoutModelsArray.count == 0) return;
    
    [self.autoLayoutModelsArray enumerateObjectsUsingBlock:^(ZZAutoLayoutModel *model, NSUInteger idx, BOOL *stop) {
        model.needsAutoResizeView.frame = CGRectZero;
    }];
}

- (void)zz_layoutSubviews
{
    // 如果程序崩溃在这行代码说明是你的view在执行“layoutSubvies”方法时出了问题而不是在此自动布局库内部出现了问题，请检查你的“layoutSubvies”方法
    [self zz_layoutSubviews];
    
    [self zz_layoutSubviewsHandle];
}

- (void)zz_layoutSubviewsHandle{

    if (self.zz_equalWidthSubviews.count) {
        __block CGFloat totalMargin = 0;
        [self.zz_equalWidthSubviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            ZZAutoLayoutModel *model = view.zz_layout;
            CGFloat left = model.left ? [model.left.value floatValue] : model.needsAutoResizeView.left_zz;
            totalMargin += (left + [model.right.value floatValue]);
        }];
        CGFloat averageWidth = (self.width_zz - totalMargin) / self.zz_equalWidthSubviews.count;
        [self.zz_equalWidthSubviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            view.width_zz = averageWidth;
            view.fixedWidth = @(averageWidth);
        }];
    }
    
    if (self.zz_categoryManager.flowItems.count && (self.zz_categoryManager.lastWidth != self.width_zz)) {
        
        self.zz_categoryManager.lastWidth = self.width_zz;
        
        NSInteger perRowItemsCount = self.zz_categoryManager.perRowItemsCount;
        CGFloat horizontalMargin = 0;
        CGFloat w = 0;
        if (self.zz_categoryManager.shouldShowAsAutoMarginViews) {
            w = self.zz_categoryManager.flowItemWidth;
            long itemsCount = self.zz_categoryManager.perRowItemsCount;
            if (itemsCount > 1) {
                horizontalMargin = (self.width_zz - (self.zz_horizontalEdgeInset * 2) - itemsCount * w) / (itemsCount - 1);
            }
        } else {
            horizontalMargin = self.zz_categoryManager.horizontalMargin;
            w = (self.width_zz - (self.zz_horizontalEdgeInset * 2) - (perRowItemsCount - 1) * horizontalMargin) / perRowItemsCount;
        }
        CGFloat verticalMargin = self.zz_categoryManager.verticalMargin;
        
        __block UIView *referencedView = self;
        [self.zz_categoryManager.flowItems enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            if (idx < perRowItemsCount) {
                if (idx == 0) {
                    /* 保留
                    BOOL shouldShowAsAutoMarginViews = self.zz_categoryManager.shouldShowAsAutoMarginViews;
                     */
                    view.zz_layout
                    .leftSpace2View(referencedView, self.zz_horizontalEdgeInset)
                    .topSpace2View(referencedView, self.zz_verticalEdgeInset)
                    .zz_widthIs(w);
                } else {
                    view.zz_layout
                    .leftSpace2View(referencedView, horizontalMargin)
                    .topEqualToView(referencedView)
                    .zz_widthIs(w);
                }
                referencedView = view;
            } else {
                referencedView = self.zz_categoryManager.flowItems[idx - perRowItemsCount];
                view.zz_layout
                .leftEqualToView(referencedView)
                .zz_widthIs(w)
                .topSpace2View(referencedView, verticalMargin);
            }
        }];
    }
    
    if (self.autoLayoutModelsArray.count) {
        
        NSMutableArray *caches = nil;
        
        if ([self isKindOfClass:ZZCellContVClass()] && self.zz_tableView) {
            caches = [self.zz_tableView.cellzz_autoHeightManager subviewFrameCachesWithIndexPath:self.zz_indexPath];
        }
        
        [self.autoLayoutModelsArray enumerateObjectsUsingBlock:^(ZZAutoLayoutModel *model, NSUInteger idx, BOOL *stop) {
            if (idx < caches.count) {
                CGRect originalFrame = model.needsAutoResizeView.frame;
                CGRect newFrame = [[caches objectAtIndex:idx] CGRectValue];
                if (CGRectEqualToRect(originalFrame, newFrame)) {
                    [model.needsAutoResizeView setNeedsLayout];
                } else {
                    model.needsAutoResizeView.frame = newFrame;
                }
                [self setupCornerRadiusWithView:model.needsAutoResizeView model:model];
                model.needsAutoResizeView.zz_categoryManager.hasSetFrameWithCache = YES;
            } else {
                if (model.needsAutoResizeView.zz_categoryManager.hasSetFrameWithCache) {
                    model.needsAutoResizeView.zz_categoryManager.hasSetFrameWithCache = NO;
                }
                [self zz_resizeWithModel:model];
            }
        }];
    }
    
    if (self.tag == kZZModelCellTag && [self isKindOfClass:ZZCellContVClass()]) {
        UITableViewCell *cell = (UITableViewCell *)(self.superview);
        
        while (cell && ![cell isKindOfClass:[UITableViewCell class]]) {
            cell = (UITableViewCell *)cell.superview;
        }
        
        if ([cell isKindOfClass:[UITableViewCell class]]) {
            CGFloat height = 0;
            for (UIView *view in cell.zz_bottomViewsArray) {
                height = MAX(height, view.bottom_zz);
            }
            cell.zz_autoHeight = height + cell.zz_bottomViewBottomMargin;
        }
    } else if (![self isKindOfClass:[UITableViewCell class]] && (self.zz_bottomViewsArray.count || self.zz_rightViewsArray.count)) {
        if (self.zz_categoryManager.hasSetFrameWithCache) {
            self.zz_categoryManager.hasSetFrameWithCache = NO;
            return;
        }
        CGFloat contentHeight = 0;
        CGFloat contentWidth = 0;
        if (self.zz_bottomViewsArray) {
            CGFloat height = 0;
            for (UIView *view in self.zz_bottomViewsArray) {
                height = MAX(height, view.bottom_zz);
            }
            contentHeight = height + self.zz_bottomViewBottomMargin;
        }
        if (self.zz_rightViewsArray) {
            CGFloat width = 0;
            for (UIView *view in self.zz_rightViewsArray) {
                width = MAX(width, view.right_zz);
            }
            contentWidth = width + self.zz_rightViewRightMargin;
        }
        if ([self isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)self;
            CGSize contentSize = scrollView.contentSize;
            if (contentHeight > 0) {
                contentSize.height = contentHeight;
            }
            if (contentWidth > 0) {
                contentSize.width = contentWidth;
            }
            if (contentSize.width <= 0) {
                contentSize.width = scrollView.width_zz;
            }
            if (!CGSizeEqualToSize(contentSize, scrollView.contentSize)) {
                scrollView.contentSize = contentSize;
            }
        } else {
            // 如果这里出现循环调用情况请把demo发送到gsdios@126.com，谢谢配合。
            if (self.zz_bottomViewsArray.count && (floorf(contentHeight) != floorf(self.height_zz))) {
                self.height_zz = contentHeight;
                self.fixedHeight = @(self.height_zz);
            }
            
            if (self.zz_rightViewsArray.count && (floorf(contentWidth) != floorf(self.width_zz))) {
                self.width_zz = contentWidth;
                self.fixedWidth = @(self.width_zz);
            }
        }
        
        ZZAutoLayoutModel *model = self.ownLayoutModel;
        
        if (![self isKindOfClass:[UIScrollView class]] && self.zz_rightViewsArray.count && (model.right || model.equalRight || model.zz_centerX || model.equalzz_centerX)) {
            self.fixedWidth = @(self.width_zz);
            if (model.right || model.equalRight) {
                [self layoutRightWithView:self model:model];
            } else {
                [self layoutLeftWithView:self model:model];
            }
            self.fixedWidth = nil;
        }
        
        if (![self isKindOfClass:[UIScrollView class]] && self.zz_bottomViewsArray.count && (model.bottom || model.equalBottom || model.zz_centerY || model.equalzz_centerY)) {
            self.fixedHeight = @(self.height_zz);
            if (model.bottom || model.equalBottom) {
                [self layoutBottomWithView:self model:model];
            } else {
                [self layoutTopWithView:self model:model];
            }
            self.fixedHeight = nil;
        }
        
        if (self.zz_didFinishAutoLayoutBlock) {
            self.zz_didFinishAutoLayoutBlock(self.frame);
        }
    }
}

- (void)zz_resizeWithModel:(ZZAutoLayoutModel *)model
{
    UIView *view = model.needsAutoResizeView;
    
    if (!view || view.zz_isClosingAutoLayout) return;
    
    if (view.zz_maxWidth && (model.rightSpace2View || model.rightEqualToView)) { // 靠右布局前提设置
        [self layoutAutoWidthWidthView:view model:model];
        view.fixedWidth = @(view.width_zz);
    }
    
    [self layoutWidthWithView:view model:model];
    
    [self layoutHeightWithView:view model:model];
    
    [self layoutLeftWithView:view model:model];
    
    [self layoutRightWithView:view model:model];
    
    if (view.zz_autoHeightRatioValue && view.width_zz > 0 && (model.bottomEqualToView || model.bottomSpace2View)) { // 底部布局前提设置
        [self layoutzz_autoHeightWidthView:view model:model];
        view.fixedHeight = @(view.height_zz);
    }
    
    if (view.zz_autoWidthRatioValue) {
        view.fixedWidth = @(view.height_zz * [view.zz_autoWidthRatioValue floatValue]);
    }
    
    
    [self layoutTopWithView:view model:model];
    
    [self layoutBottomWithView:view model:model];
    
    if ((model.zz_centerX || model.equalzz_centerX) && !view.fixedWidth) {
        [self layoutLeftWithView:view model:model];
    }
    
    if ((model.zz_centerY || model.equalzz_centerY) && !view.fixedHeight) {
        [self layoutTopWithView:view model:model];
    }
    
    if (view.zz_maxWidth) {
        [self layoutAutoWidthWidthView:view model:model];
    }
    
    if (model.maxWidth && [model.maxWidth floatValue] < view.width_zz) {
        view.width_zz = [model.maxWidth floatValue];
    }
    
    if (model.minWidth && [model.minWidth floatValue] > view.width_zz) {
        view.width_zz = [model.minWidth floatValue];
    }
    
    if (view.zz_autoHeightRatioValue && view.width_zz > 0) {
        [self layoutzz_autoHeightWidthView:view model:model];
    }
    
    if (model.maxHeight && [model.maxHeight floatValue] < view.height_zz) {
        view.height_zz = [model.maxHeight floatValue];
    }
    
    if (model.minHeight && [model.minHeight floatValue] > view.height_zz) {
        view.height_zz = [model.minHeight floatValue];
    }
    
    if (model.widthEqualHeight) {
        view.width_zz = view.height_zz;
    }
    
    if (model.heightEqualWidth) {
        view.height_zz = view.width_zz;
    }
    
    if (view.zz_didFinishAutoLayoutBlock) {
        view.zz_didFinishAutoLayoutBlock(view.frame);
    }
    
    if (view.zz_bottomViewsArray.count || view.zz_rightViewsArray.count) {
        [view layoutSubviews];
    }
    
    [self setupCornerRadiusWithView:view model:model];
}

- (void)layoutzz_autoHeightWidthView:(UIView *)view model:(ZZAutoLayoutModel *)model
{
    if ([view.zz_autoHeightRatioValue floatValue] > 0) {
        view.height_zz = view.width_zz * [view.zz_autoHeightRatioValue floatValue];
    } else {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            label.numberOfLines = 0;
            if (label.text.length) {
                if (!label.isAttributedContent) {
                    CGRect rect = [label.text boundingRectWithSize:CGSizeMake(label.width_zz, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : label.font} context:nil];
                    label.height_zz = rect.size.height + 0.1;
                } else {
                    [label sizeToFit];
                    if (label.zz_maxWidth && label.width_zz > [label.zz_maxWidth floatValue]) {
                        label.width_zz = [label.zz_maxWidth floatValue];
                    }
                }
            } else {
                label.height_zz = 0;
            }
        } else {
            view.height_zz = 0;
        }
    }
}

- (void)layoutAutoWidthWidthView:(UIView *)view model:(ZZAutoLayoutModel *)model
{
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;
        CGFloat width = [view.zz_maxWidth floatValue] > 0 ? [view.zz_maxWidth floatValue] : MAXFLOAT;
        label.numberOfLines = 1;
        if (label.text.length) {
            if (!label.isAttributedContent) {
                CGRect rect = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, label.height_zz) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : label.font} context:nil];
                if (rect.size.width > width) {
                    rect.size.width = width;
                }
                label.width_zz = rect.size.width + 0.1;
            } else{
                [label sizeToFit];
                if (label.width_zz > width) {
                    label.width_zz = width;
                }
            }
        } else {
            label.size_zz = CGSizeZero;
        }
    }
}

- (void)layoutWidthWithView:(UIView *)view model:(ZZAutoLayoutModel *)model
{
    if (model.width) {
        view.width_zz = [model.width.value floatValue];
        view.fixedWidth = @(view.width_zz);
    } else if (model.ratio_width) {
        view.width_zz = model.ratio_width.refView.width_zz * [model.ratio_width.value floatValue];
        view.fixedWidth = @(view.width_zz);
    }
}

- (void)layoutHeightWithView:(UIView *)view model:(ZZAutoLayoutModel *)model
{
    if (model.height) {
        view.height_zz = [model.height.value floatValue];
        view.fixedHeight = @(view.height_zz);
    } else if (model.ratio_height) {
        view.height_zz = [model.ratio_height.value floatValue] * model.ratio_height.refView.height_zz;
        view.fixedHeight = @(view.height_zz);
    }
}

- (void)layoutLeftWithView:(UIView *)view model:(ZZAutoLayoutModel *)model
{
    if (model.left) {
        if (view.superview == model.left.refView) {
            if (!view.fixedWidth) { // view.autoLeft && view.autoRight
                view.width_zz = view.right_zz - [model.left.value floatValue];
            }
            view.left_zz = [model.left.value floatValue];
        } else {
            if (model.left.refViewsArray.count) {
                CGFloat lastRefRight = 0;
                for (UIView *ref in model.left.refViewsArray) {
                    if ([ref isKindOfClass:[UIView class]] && ref.right_zz > lastRefRight) {
                        model.left.refView = ref;
                        lastRefRight = ref.right_zz;
                    }
                }
            }
            if (!view.fixedWidth) { // view.autoLeft && view.autoRight
                view.width_zz = view.right_zz - model.left.refView.right_zz - [model.left.value floatValue];
            }
            view.left_zz = model.left.refView.right_zz + [model.left.value floatValue];
        }
        
    } else if (model.equalLeft) {
        if (!view.fixedWidth) {
            if (model.needsAutoResizeView == view.superview) {
                view.width_zz = view.right_zz - (0 + model.equalLeft.offset);
            } else {
                view.width_zz = view.right_zz  - (model.equalLeft.refView.left_zz + model.equalLeft.offset);
            }
        }
        if (view.superview == model.equalLeft.refView) {
            view.left_zz = 0 + model.equalLeft.offset;
        } else {
            view.left_zz = model.equalLeft.refView.left_zz + model.equalLeft.offset;
        }
    } else if (model.equalzz_centerX) {
        if (view.superview == model.equalzz_centerX.refView) {
            view.centerX_zz = model.equalzz_centerX.refView.width_zz * 0.5 + model.equalzz_centerX.offset;
        } else {
            view.centerX_zz = model.equalzz_centerX.refView.centerX_zz + model.equalzz_centerX.offset;
        }
    } else if (model.zz_centerX) {
        view.centerX_zz = [model.zz_centerX floatValue];
    }
}

- (void)layoutRightWithView:(UIView *)view model:(ZZAutoLayoutModel *)model
{
    if (model.right) {
        if (view.superview == model.right.refView) {
            if (!view.fixedWidth) { // view.autoLeft && view.autoRight
                view.width_zz = model.right.refView.width_zz - view.left_zz - [model.right.value floatValue];
            }
            view.right_zz = model.right.refView.width_zz - [model.right.value floatValue];
        } else {
            if (!view.fixedWidth) { // view.autoLeft && view.autoRight
                view.width_zz =  model.right.refView.left_zz - view.left_zz - [model.right.value floatValue];
            }
            view.right_zz = model.right.refView.left_zz - [model.right.value floatValue];
        }
    } else if (model.equalRight) {
        if (!view.fixedWidth) {
            if (model.equalRight.refView == view.superview) {
                view.width_zz = model.equalRight.refView.width_zz - view.left_zz + model.equalRight.offset;
            } else {
                view.width_zz = model.equalRight.refView.right_zz - view.left_zz + model.equalRight.offset;
            }
        }
        
        view.right_zz = model.equalRight.refView.right_zz + model.equalRight.offset;
        if (view.superview == model.equalRight.refView) {
            view.right_zz = model.equalRight.refView.width_zz + model.equalRight.offset;
        }
        
    }
}

- (void)layoutTopWithView:(UIView *)view model:(ZZAutoLayoutModel *)model
{
    if (model.top) {
        if (view.superview == model.top.refView) {
            if (!view.fixedHeight) { // view.autoTop && view.autoBottom && view.bottom
                view.height_zz = view.bottom_zz - [model.top.value floatValue];
            }
            view.top_zz = [model.top.value floatValue];
        } else {
            if (model.top.refViewsArray.count) {
                CGFloat lastRefBottom = 0;
                for (UIView *ref in model.top.refViewsArray) {
                    if ([ref isKindOfClass:[UIView class]] && ref.bottom_zz > lastRefBottom) {
                        model.top.refView = ref;
                        lastRefBottom = ref.bottom_zz;
                    }
                }
            }
            if (!view.fixedHeight) { // view.autoTop && view.autoBottom && view.bottom
                view.height_zz = view.bottom_zz - model.top.refView.bottom_zz - [model.top.value floatValue];
            }
            view.top_zz = model.top.refView.bottom_zz + [model.top.value floatValue];
        }
    } else if (model.equalTop) {
        if (view.superview == model.equalTop.refView) {
            if (!view.fixedHeight) {
                view.height_zz = view.bottom_zz - model.equalTop.offset;
            }
            view.top_zz = 0 + model.equalTop.offset;
        } else {
            if (!view.fixedHeight) {
                view.height_zz = view.bottom_zz - (model.equalTop.refView.top_zz + model.equalTop.offset);
            }
            view.top_zz = model.equalTop.refView.top_zz + model.equalTop.offset;
        }
    } else if (model.equalzz_centerY) {
        if (view.superview == model.equalzz_centerY.refView) {
            view.centerY_zz = model.equalzz_centerY.refView.height_zz * 0.5 + model.equalzz_centerY.offset;
        } else {
            view.centerY_zz = model.equalzz_centerY.refView.centerY_zz + model.equalzz_centerY.offset;
        }
    } else if (model.zz_centerY) {
        view.centerY_zz = [model.zz_centerY floatValue];
    }
}

- (void)layoutBottomWithView:(UIView *)view model:(ZZAutoLayoutModel *)model
{
    if (model.bottom) {
        if (view.superview == model.bottom.refView) {
            if (!view.fixedHeight) {
                view.height_zz = view.superview.height_zz - view.top_zz - [model.bottom.value floatValue];
            }
            view.bottom_zz = model.bottom.refView.height_zz - [model.bottom.value floatValue];
        } else {
            if (!view.fixedHeight) {
                view.height_zz = model.bottom.refView.top_zz - view.top_zz - [model.bottom.value floatValue];
            }
            view.bottom_zz = model.bottom.refView.top_zz - [model.bottom.value floatValue];
        }
        
    } else if (model.equalBottom) {
        if (view.superview == model.equalBottom.refView) {
            if (!view.fixedHeight) {
                view.height_zz = view.superview.height_zz - view.top_zz + model.equalBottom.offset;
            }
            view.bottom_zz = model.equalBottom.refView.height_zz + model.equalBottom.offset;
        } else {
            if (!view.fixedHeight) {
                view.height_zz = model.equalBottom.refView.bottom_zz - view.top_zz + model.equalBottom.offset;
            }
            view.bottom_zz = model.equalBottom.refView.bottom_zz + model.equalBottom.offset;
        }
    }
    if (model.widthEqualHeight && !view.fixedHeight) {
        [self layoutRightWithView:view model:model];
    }
}


- (void)setupCornerRadiusWithView:(UIView *)view model:(ZZAutoLayoutModel *)model
{
    CGFloat cornerRadius = view.layer.cornerRadius;
    CGFloat newCornerRadius = 0;
    
    if (view.zz_cornerRadius && (cornerRadius != [view.zz_cornerRadius floatValue])) {
        newCornerRadius = [view.zz_cornerRadius floatValue];
    } else if (view.zz_cornerRadiusFromWidthRatio && (cornerRadius != [view.zz_cornerRadiusFromWidthRatio floatValue] * view.width_zz)) {
        newCornerRadius = view.width_zz * [view.zz_cornerRadiusFromWidthRatio floatValue];
    } else if (view.zz_cornerRadiusFromHeightRatio && (cornerRadius != view.height_zz * [view.zz_cornerRadiusFromHeightRatio floatValue])) {
        newCornerRadius = view.height_zz * [view.zz_cornerRadiusFromHeightRatio floatValue];
    }
    
    if (newCornerRadius > 0) {
        view.layer.cornerRadius = newCornerRadius;
        view.clipsToBounds = YES;
    }
}

- (void)addAutoLayoutModel:(ZZAutoLayoutModel *)model
{
    [self.autoLayoutModelsArray addObject:model];
}

@end

@implementation UIButton (ZZAutoLayoutButton)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *selString = @"layoutSubviews";
        NSString *mySelString = [@"zz_button_" stringByAppendingString:selString];
        
        Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
        Method myMethod = class_getInstanceMethod(self, NSSelectorFromString(mySelString));
        method_exchangeImplementations(originalMethod, myMethod);
    });
}

- (void)zz_button_layoutSubviews
{
    // 如果程序崩溃在这行代码说明是你的view在执行“layoutSubvies”方法时出了问题而不是在此自动布局库内部出现了问题，请检查你的“layoutSubvies”方法
    [self zz_button_layoutSubviews];
    
    [self zz_layoutSubviewsHandle];
    
}

@end


@implementation UIView (ZZChangeFrame)

- (BOOL)zz_shouldReadjustFrameBeforeStoreCache
{
    return self.zz_categoryManager.zz_shouldReadjustFrameBeforeStoreCache;
}

- (void)setZz_shouldReadjustFrameBeforeStoreCache:(BOOL)zz_shouldReadjustFrameBeforeStoreCache
{
    self.zz_categoryManager.zz_shouldReadjustFrameBeforeStoreCache = zz_shouldReadjustFrameBeforeStoreCache;
}

- (CGFloat)left_zz {
    return self.frame.origin.x;
}

- (void)setLeft_zz:(CGFloat)x_zz {
    CGRect frame = self.frame;
    frame.origin.x = x_zz;
    self.frame = frame;
}

- (CGFloat)top_zz {
    return self.frame.origin.y;
}

- (void)setTop_zz:(CGFloat)y_zz {
    CGRect frame = self.frame;
    frame.origin.y = y_zz;
    self.frame = frame;
}

- (CGFloat)right_zz {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight_zz:(CGFloat)right_zz {
    CGRect frame = self.frame;
    frame.origin.x = right_zz - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom_zz {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom_zz:(CGFloat)bottom_zz {
    CGRect frame = self.frame;
    frame.origin.y = bottom_zz - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX_zz {
    return self.left_zz + self.width_zz * 0.5;
}

- (void)setCenterX_zz:(CGFloat)centerX_zz {
     self.left_zz = centerX_zz - self.width_zz * 0.5;
}

- (CGFloat)centerY_zz
{
    return self.top_zz + self.height_zz * 0.5;
}

- (void)setCenterY_zz:(CGFloat)centerY_zz {
    self.top_zz = centerY_zz - self.height_zz * 0.5;
}

- (CGFloat)width_zz {
    return self.frame.size.width;
}

- (void)setWidth_zz:(CGFloat)width_zz {
    if (self.ownLayoutModel.widthEqualHeight) {
        if (width_zz != self.height_zz) return;
    }
    CGRect frame = self.frame;
    frame.size.width = width_zz;
    self.frame = frame;
    if (self.ownLayoutModel.heightEqualWidth) {
        self.height_zz = width_zz;
    }
}

- (CGFloat)height_zz {
    return self.frame.size.height;
}

- (void)setHeight_zz:(CGFloat)height_zz {
    if (self.ownLayoutModel.heightEqualWidth) {
        if (height_zz != self.width_zz) return;
    }
    CGRect frame = self.frame;
    frame.size.height = height_zz;
    self.frame = frame;
    if (self.ownLayoutModel.widthEqualHeight) {
        self.width_zz = height_zz;
    }
}

- (CGPoint)origin_zz {
    return self.frame.origin;
}

- (void)setOrigin_zz:(CGPoint)origin_zz {
    CGRect frame = self.frame;
    frame.origin = origin_zz;
    self.frame = frame;
}

- (CGSize)size_zz {
    return self.frame.size;
}

- (void)setSize_zz:(CGSize)size_zz {
    CGRect frame = self.frame;
    frame.size = size_zz;
    self.frame = frame;
}

@end

@implementation ZZUIViewCategoryManager

@end

