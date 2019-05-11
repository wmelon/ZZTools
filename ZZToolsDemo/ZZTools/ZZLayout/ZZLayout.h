//
//  ZZLayout.h
//  collectionView
//
//  Created by 刘猛 on 2018/11/30.
//  Copyright © 2018年 刘猛. All rights reserved.
//
//  瀑布流通用的Layout, 部分思路来自其他开源库, 侵删, 联系qq:1156858877
//
//  特别鸣谢以下开源作者/开源工具
//  垂直瀑布流:https://github.com/JiWuChao/CustomLayout
//  横向瀑布流:https://github.com/ZhouZhengzz/ZZCollectionViewLayout
//

#import <UIKit/UIKit.h>

@class ZZLayout;

typedef enum : NSUInteger {
    ZZLayoutFlowTypeVertical,//垂直(默认)
    ZZLayoutFlowTypeHorizontal,//水平
    ZZLayoutFlowTypeAutomateFloat,//浮动效果(item宽度不相等, 自动换行, 类似淘宝sku选择时的效果)
} ZZLayoutFlowType;

@protocol ZZLayoutDelegate <NSObject>

@optional
/**cell的宽(垂直瀑布流时此协议方法无效, 根据columnNumber和各种间距自适应)*/
- (CGFloat)layout:(ZZLayout *)collectionViewLayout widthForRowAtIndexPath:(NSIndexPath *)indexPath;

/**cell的高(水平瀑布流是此协议方法无效, 根据columnNumber和各种间距自适应)*/
- (CGFloat)layout:(ZZLayout *)collectionViewLayout heightForRowAtIndexPath:(NSIndexPath *)indexPath;

/**每个区多少列(浮动瀑布流时时此协议方法无效)*/
- (NSInteger)layout:(ZZLayout *)collectionViewLayout columnNumberAtSection:(NSInteger)section;

/**每个区的边距(上左下右)*/
- (UIEdgeInsets)layout:(ZZLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

/**多种类型混合, 暂不支持水平, 可随意兼容垂直和浮动效果*/
- (ZZLayoutFlowType)layout:(ZZLayout *)collectionViewLayout layoutFlowTypeForSectionAtIndex:(NSInteger)section;

/**每个item行间距(如果为水平方向瀑布流, 这里则是左右间距)*/
- (NSInteger)layout:(ZZLayout *)collectionViewLayout lineSpacingForSectionAtIndex:(NSInteger)section;

/**每个item列间距(如果是水平方向瀑布流, 这里则是上下间距)*/
- (CGFloat)layout:(ZZLayout *)collectionViewLayout interitemSpacingForSectionAtIndex:(NSInteger)section;

/**header的size*/
- (CGSize)layout:(ZZLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;

/**footer的size*/
- (CGSize)layout:(ZZLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;

/**本区区头和上个区区尾的间距*/
- (CGFloat)layout:(ZZLayout *)collectionViewLayout spacingWithLastSectionForSectionAtIndex:(NSInteger)section;

/**指定某个分区的"背景"颜色(从区头, 到区尾的空间, 不包含区头区尾)*/
- (UIColor *)layout:(ZZLayout *)collectionViewLayout colorForSection:(NSInteger)section;

@end

@interface ZZLayout : UICollectionViewFlowLayout

/**自定义初始化方法, 建议使用*/
- (instancetype)initWith:(ZZLayoutFlowType)flowType delegate:(id<ZZLayoutDelegate>)delegate;

/**传入回调的代理, 建议通过自定义协议方法传入*/
@property (nonatomic , weak) id<ZZLayoutDelegate> delegate;

/**layout的类型*/
@property (nonatomic , assign) ZZLayoutFlowType zzScrollDirection;

@end


@interface ZZCollectionReusableView : UICollectionReusableView;

@end

@interface ZZCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes;

/**背景颜色*/
@property (nonatomic , strong) UIColor  *backgroudColor;

@end


//@interface UICollectionReusableView (ZZLayout)
//
///**如果需要区头浮动, 必须给出此值*/
//@property (nonatomic , assign) NSInteger  zz_section;
//
//@end

//
//
//@interface UICollectionViewCell (ZZLayout)
//
///**cell的高度*/
//@property (nonatomic , assign) CGFloat  zz_cellHeight;
//
//@end
