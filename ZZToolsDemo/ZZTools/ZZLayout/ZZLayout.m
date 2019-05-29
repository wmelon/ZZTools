//
//  CustomLayout.m
//  collectionView
//
//  Created by 刘猛 on 2018/11/30.
//  Copyright © 2018年 刘猛. All rights reserved.
//

#import "ZZLayout.h"
#import <objc/message.h>

static const NSInteger DefaultColumnCpunt = 3;

@interface ZZLayout ()

//边距
@property (nonatomic , assign) UIEdgeInsets     sectionInsets;

//列数
@property (nonatomic , assign) NSInteger        columnCount;

//行间距
@property (nonatomic , assign) CGFloat          lineSpacing;

//列间距
@property (nonatomic , assign) CGFloat          interitemSpacing;

//collectionView的可滚动距离(横竖)
@property (nonatomic , assign) CGFloat          contentDistance;

//记录上个区最高的把一列的高度
@property (nonatomic , assign) CGFloat          lastContentHeight;

//存放每个区中各个列的最后一个高度
@property (nonatomic , strong) NSMutableArray   *columnDistances;

//每个区的区头和上个区的区尾的距离
@property (nonatomic , assign) CGFloat          spacingWithLastSection;

//存放attribute的数组
@property (nonatomic , strong) NSMutableArray   *attributesArray;

/**存放header的数组*/
@property (nonatomic , strong) NSMutableArray   *headerArray;

/**存放item的数组*/
@property (nonatomic , strong) NSMutableArray   *itemArray;

/**存放footer的数组*/
@property (nonatomic , strong) NSMutableArray   *footerArray;

//分区背景颜色的数组
@property (nonatomic , strong) NSMutableArray   *decorationViewAttrs;

@end

@implementation ZZLayout

- (instancetype)init {
    if (self == [super init]) {
        //默认滚动方向为垂直
        self.zzScrollDirection = ZZLayoutFlowTypeVertical;
    }
    return self;
}

//自定义初始化方法, 建议使用
- (instancetype)initWith:(ZZLayoutFlowType)scrollDirection delegate:(id<ZZLayoutDelegate>)delegate {
    if (self == [super init]) {
        self.zzScrollDirection = scrollDirection;self.delegate = delegate;
        if (self.zzScrollDirection == ZZLayoutFlowTypeHorizontal) {
            self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        }
        [self registerClass:[ZZCollectionReusableView class] forDecorationViewOfKind:@"ZZCollectionReusableView"];
    }
    return self;
}

//准备布局,自定义layout必须重写
- (void)prepareLayout {
    [super prepareLayout];
    
    //1.整理数据
    self.lineSpacing = 0;self.contentDistance = 0;self.lastContentHeight = 0;self.spacingWithLastSection = 0;
    self.footerReferenceSize = CGSizeZero;[self.columnDistances removeAllObjects];[self.attributesArray removeAllObjects];
    self.sectionInsets = UIEdgeInsetsZero;self.headerReferenceSize = CGSizeZero;[self.decorationViewAttrs removeAllObjects];
    [self.headerArray removeAllObjects];[self.footerArray removeAllObjects];[self.itemArray removeAllObjects];
    
    //2.布局每个区
    NSInteger sectionCount = [self.collectionView numberOfSections];
    for (NSInteger i = 0; i < sectionCount; i ++) {
        NSIndexPath *indexPat = [NSIndexPath indexPathWithIndex:i];
        
        //每个区的初始化高度
        if ([_delegate respondsToSelector:@selector(layout:columnNumberAtSection:)]) {
            self.columnCount = [_delegate layout:self columnNumberAtSection:indexPat.section];
        }
        
        if ([_delegate respondsToSelector:@selector(layout:insetForSectionAtIndex:)]) {
            self.sectionInsets = [_delegate layout:self insetForSectionAtIndex:indexPat.section];
        }
        
        if ([_delegate respondsToSelector:@selector(layout:spacingWithLastSectionForSectionAtIndex:)]) {
            self.spacingWithLastSection = [_delegate layout:self spacingWithLastSectionForSectionAtIndex:indexPat.section];
        }
        
        //1.生成区头
        NSInteger itemCountOfSection = [self.collectionView numberOfItemsInSection:i];
        NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:i];
        
        if ([self.collectionView.dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
            UICollectionViewLayoutAttributes *headerAttributs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
            if (headerAttributs) {
                headerAttributs.zIndex = 1;
                [self.attributesArray addObject:headerAttributs];
                [self.headerArray addObject:headerAttributs];
            }
        }
        
        [self.columnDistances removeAllObjects];
        self.lastContentHeight = self.contentDistance;
        
        //2.初始化区的distance值
        for (NSInteger i = 0; i < self.columnCount; i ++) {[self.columnDistances addObject:@(self.contentDistance)];}
        
        //3.每个区中有多少 item(布局每个区的每个cell)
        UICollectionViewLayoutAttributes *firstAttributes;
        for (NSInteger j = 0; j < itemCountOfSection; j ++) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attributesArray addObject:attributes];
            //获取第一个item的布局信息
            if (j == 0) {firstAttributes = attributes;}
        }
        
        //4.初始化 footer
        if ([self.collectionView.dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
            UICollectionViewLayoutAttributes *footerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
            if (footerAttributes) {
                [self.attributesArray addObject:footerAttributes];
                [self.footerArray addObject:footerAttributes];
            }
        }
        
        //5.修改分区颜色
        CGRect sectionFrame = firstAttributes.frame;CGSize footSize = CGSizeZero;
        if ([self.delegate respondsToSelector:@selector(layout:referenceSizeForFooterInSection:)]) {
            footSize = [self.delegate layout:self referenceSizeForFooterInSection:i];
        }
        
        //根据不同瀑布流类型计算.
        if (self.zzScrollDirection == ZZLayoutFlowTypeVertical) {
            sectionFrame.origin.x -= self.sectionInsets.left;
            sectionFrame.origin.y -= self.sectionInsets.top;
            sectionFrame.size.width = self.collectionView.bounds.size.width;
            sectionFrame.size.height = self.contentDistance - sectionFrame.origin.y - footSize.height;
        } else if (self.zzScrollDirection == ZZLayoutFlowTypeHorizontal) {
            sectionFrame.origin.x -= self.sectionInsets.left;
            sectionFrame.origin.y -= self.sectionInsets.top;
            sectionFrame.size.width = self.contentDistance - sectionFrame.origin.x - footSize.width;
            sectionFrame.size.height = self.collectionView.bounds.size.height;
        } else {
            sectionFrame.origin.x -= self.sectionInsets.left;
            sectionFrame.origin.y -= self.sectionInsets.top;
            sectionFrame.size.width = self.collectionView.bounds.size.width;
            sectionFrame.size.height = self.contentDistance - sectionFrame.origin.y - footSize.height;
        }
        
        //设置frame
        ZZCollectionViewLayoutAttributes *attr = [ZZCollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"ZZCollectionReusableView" withIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        attr.zIndex = -1;attr.frame = sectionFrame;
        attr.backgroudColor = [UIColor clearColor];
        if ([self.delegate respondsToSelector:@selector(layout:colorForSection:)]) {
            attr.backgroudColor = [self.delegate layout:self colorForSection:i];
        } else {
            attr.backgroudColor = [UIColor clearColor];
        }
        [self.decorationViewAttrs addObject:attr];
        
    }
}

# pragma mark- 计算返回布局attributes(item布局算法核心)
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //1.协议取值
    if ([_delegate respondsToSelector:@selector(layout:columnNumberAtSection:)]) {
        self.columnCount = [_delegate layout:self columnNumberAtSection:indexPath.section];
    }
    
    if ([_delegate respondsToSelector:@selector(layout:lineSpacingForSectionAtIndex:)]) {
        self.lineSpacing = [_delegate layout:self lineSpacingForSectionAtIndex:indexPath.section];
    }
    
    if ([_delegate respondsToSelector:@selector(layout:interitemSpacingForSectionAtIndex:)]) {
        self.interitemSpacing = [_delegate layout:self interitemSpacingForSectionAtIndex:indexPath.section];
    }
    
    //如果是混合类型, 则需要动态处理.
    if ([self.delegate respondsToSelector:@selector(layout:layoutFlowTypeForSectionAtIndex:)]) {
        self.zzScrollDirection = [self.delegate layout:self layoutFlowTypeForSectionAtIndex:indexPath.section];
    }
    
    //2.分类布局
    if (self.zzScrollDirection == ZZLayoutFlowTypeVertical) {
        
        return [self setupAttributesWithVertical:indexPath];
        
    } else if (self.zzScrollDirection == ZZLayoutFlowTypeAutomateFloat) {
        
        return [self setupAttributesWithVerticalFloat:indexPath];
        
    } else if (self.zzScrollDirection == ZZLayoutFlowTypeHorizontal) {
        
        return [self setupAttributesWithHorizontal:indexPath];
        
    }
    
    return [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];;
}

//垂直瀑布流算法
- (UICollectionViewLayoutAttributes *)setupAttributesWithVertical:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat collectionViewWeight = self.collectionView.frame.size.width;
    CGFloat cellWeight = (collectionViewWeight - self.sectionInsets.left - self.sectionInsets.right - (self.columnCount - 1) * self.interitemSpacing) / self.columnCount;
    CGFloat cellHeight = 50;
    if ([self.delegate respondsToSelector:@selector(layout:heightForRowAtIndexPath:)]) {
        cellHeight = [self.delegate layout:self heightForRowAtIndexPath:indexPath];
    }
    
    NSInteger tempMinColumn = 0;//默认第 0 列最小
    CGFloat minColumnHeight = [self.columnDistances[0] doubleValue];// 取出最小的那一列的高度
    for (NSInteger i = 0; i < self.columnCount; i ++) {
        CGFloat columnH = [self.columnDistances[i] doubleValue];
        if (minColumnHeight > columnH) {
            minColumnHeight = columnH;
            tempMinColumn = i;
        }
    }
    
    CGFloat cellX = self.sectionInsets.left + tempMinColumn * (cellWeight + self.interitemSpacing);
    CGFloat cellY = MAX(minColumnHeight, 0);
    
    //如果cell的y值不等于上个区的最高的高度 即不是此区的第一列 要加上此区的每个cell的上下间距
    if (cellY != self.lastContentHeight) {
        cellY += self.lineSpacing;
    } else {
        cellY += self.sectionInsets.top;
    }
    if (self.contentDistance < minColumnHeight) {self.contentDistance = minColumnHeight;}
    
    attributes.frame = CGRectMake(cellX, cellY, cellWeight, cellHeight);
    self.columnDistances[tempMinColumn] = @(CGRectGetMaxY(CGRectMake(cellX, cellY, cellWeight, cellHeight)));
    
    //取出最大的
    for (NSInteger i = 0; i < self.columnDistances.count; i++) {
        if (self.contentDistance < [self.columnDistances[i] doubleValue]) {self.contentDistance = [self.columnDistances[i] doubleValue];}
    }
    
    return attributes;
}

//水平瀑布流算法
- (UICollectionViewLayoutAttributes *)setupAttributesWithHorizontal:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat collectionViewHeight = self.collectionView.frame.size.height;
    CGFloat cellHeight = (collectionViewHeight - self.sectionInsets.top - self.sectionInsets.bottom - (self.columnCount - 1) * self.interitemSpacing) / self.columnCount;
    CGFloat cellWeight = 50;
    if ([self.delegate respondsToSelector:@selector(layout:widthForRowAtIndexPath:)]) {
        cellWeight = [self.delegate layout:self widthForRowAtIndexPath:indexPath];
    }
    
    NSInteger tempMinColumn = 0;//默认第 0 列最小
    CGFloat minColumnWidth = [self.columnDistances[0] doubleValue];// 取出最小的那一列的宽度
    for (NSInteger i = 0; i < self.columnCount; i ++) {
        CGFloat columnW = [self.columnDistances[i] doubleValue];
        if (minColumnWidth > columnW) {
            minColumnWidth = columnW;
            tempMinColumn = i;
        }
    }
    
    CGFloat cellX = MAX(minColumnWidth, 0);
    CGFloat cellY = self.sectionInsets.top + tempMinColumn * (cellHeight + self.interitemSpacing);
    
    //如果cell的y值不等于上个区的最高的高度 即不是此区的第一列 要加上此区的每个cell的上下间距
    if (cellX != self.lastContentHeight) {
        cellX += self.lineSpacing;
    }
    if (self.contentDistance < minColumnWidth) {self.contentDistance = minColumnWidth;}
    
    attributes.frame = CGRectMake(cellX, cellY, cellWeight, cellHeight);
    self.columnDistances[tempMinColumn] = @(CGRectGetMaxX(attributes.frame));
    
    // 取出最大的
    for (NSInteger i = 0; i < self.columnDistances.count; i++ ) {
        if (self.contentDistance < [self.columnDistances[i] doubleValue]) {self.contentDistance = [self.columnDistances[i] doubleValue];}
    }
    
    return attributes;
}

//浮动算法
- (UICollectionViewLayoutAttributes *)setupAttributesWithVerticalFloat:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //1.外部返回宽高
    CGFloat cellWidth = 50;
    CGFloat cellHeight = 50;
    if ([self.delegate respondsToSelector:@selector(layout:widthForRowAtIndexPath:)]) {
        cellWidth = [self.delegate layout:self widthForRowAtIndexPath:indexPath];
    }
    
    if ([self.delegate respondsToSelector:@selector(layout:heightForRowAtIndexPath:)]) {
        cellHeight = [self.delegate layout:self heightForRowAtIndexPath:indexPath];
    }
    
    //2.取出上一个item的attributes
    CGRect currentFrame = CGRectZero;
    UICollectionViewLayoutAttributes *lastAttributs = [self.attributesArray lastObject];
    CGRect lastFrame = lastAttributs.frame;
    
    //3.判断当前item和上一个item是否在同一个row
    if (CGRectGetMaxX(lastFrame) + self.sectionInsets.right + cellWidth >= self.collectionView.bounds.size.width) {//不在同一行
        currentFrame.origin.x = self.sectionInsets.left;
        if (indexPath.row == 0) {
            currentFrame.origin.y = CGRectGetMaxY(lastFrame) + self.sectionInsets.top;
        } else {
            currentFrame.origin.y = CGRectGetMaxY(lastFrame) + self.lineSpacing;
        }
        currentFrame.size.width = cellWidth;
        currentFrame.size.height = cellHeight;
        attributes.frame = currentFrame;
        
    } else {///在同一行
        currentFrame.origin.x = CGRectGetMaxX(lastFrame) + self.interitemSpacing;
        currentFrame.origin.y = lastFrame.origin.y;
        currentFrame.size.width = cellWidth;
        currentFrame.size.height = cellHeight;
        attributes.frame = currentFrame;
        
    }
    self.contentDistance = CGRectGetMaxY(attributes.frame);
    return attributes;
}

//区头区尾
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        if ([_delegate respondsToSelector:@selector(layout:referenceSizeForHeaderInSection:)]) {
            self.headerReferenceSize = [_delegate layout:self referenceSizeForHeaderInSection:indexPath.section];
        } else {
            self.headerReferenceSize = CGSizeMake(self.collectionView.bounds.size.width, 0.001);
        }
        self.contentDistance += indexPath.section == 0 ? 0 : self.spacingWithLastSection;
        
        if (self.zzScrollDirection != ZZLayoutFlowTypeHorizontal) {
            
            attribute.frame = CGRectMake(0, self.contentDistance, self.headerReferenceSize.width, self.headerReferenceSize.height);
            self.contentDistance += self.sectionInsets.top;
            self.contentDistance += self.headerReferenceSize.height;
            
        } else {
            
            attribute.frame = CGRectMake(self.contentDistance,  0, self.headerReferenceSize.width, self.headerReferenceSize.height);
            self.contentDistance += self.sectionInsets.left;
            self.contentDistance += self.headerReferenceSize.width;
        }
        
    } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        
        if ([_delegate respondsToSelector:@selector(layout:referenceSizeForFooterInSection:)]) {
            self.footerReferenceSize = [_delegate layout:self referenceSizeForFooterInSection:indexPath.section];
        } else {
            self.headerReferenceSize = CGSizeMake(0.001, self.collectionView.bounds.size.height);
        }
        
        if (self.zzScrollDirection != ZZLayoutFlowTypeHorizontal) {
            self.contentDistance += self.sectionInsets.bottom;
            attribute.frame = CGRectMake(0, self.contentDistance, self.footerReferenceSize.width, self.footerReferenceSize.height);
            self.contentDistance += self.footerReferenceSize.height;
        } else {
            self.contentDistance += self.sectionInsets.right;
            attribute.frame = CGRectMake(self.contentDistance, 0, self.footerReferenceSize.width, self.footerReferenceSize.height);
            self.contentDistance += self.footerReferenceSize.width;
        }
        
    }
    
    return attribute;
}

//分区背景颜色相关
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:@"ZZCollectionReusableView"]) {
        return [self.decorationViewAttrs objectAtIndex:indexPath.section];
    }
    return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
}

//collection的可滚动范围
- (CGSize)collectionViewContentSize {
    if (self.zzScrollDirection != ZZLayoutFlowTypeHorizontal) {
        return CGSizeMake(self.collectionView.frame.size.width, self.contentDistance);
    }
    return CGSizeMake(self.contentDistance, self.collectionView.frame.size.height);
}

//处理区头浮动和分区背景颜色
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    //添加分区背景
    for (UICollectionViewLayoutAttributes *attr in self.decorationViewAttrs) {//添加分区背景颜色
        if (CGRectIntersectsRect(rect, attr.frame)) {[self.attributesArray addObject:attr];}
    }
    
    //如果区头不需要悬浮, 直接返回布局对象数组
    if (!self.sectionHeadersPinToVisibleBounds) {return self.attributesArray;}
    
    //遍历所有区头
    for (UICollectionViewLayoutAttributes *headerAttributes in self.headerArray) {
        
        UICollectionViewLayoutAttributes *sectionBgAttirbutes = self.decorationViewAttrs[headerAttributes.indexPath.section];
        UICollectionViewLayoutAttributes *footerAttributes = self.footerArray[headerAttributes.indexPath.section];
        headerAttributes.zIndex = 10 + headerAttributes.indexPath.section;
        footerAttributes.zIndex = 20 + headerAttributes.indexPath.section;
        CGRect headerRect = headerAttributes.frame;
        
        if (self.zzScrollDirection != ZZLayoutFlowTypeHorizontal) {
            //如果找到一个区头 符合这个条件, 则不再执行其他区
            if (headerAttributes.frame.origin.y >= self.collectionView.contentOffset.y) {
                return self.attributesArray;
            }
            
            if (self.collectionView.contentOffset.y < sectionBgAttirbutes.frame.size.height + headerAttributes.frame.origin.y) {
                headerRect.origin.y = self.collectionView.contentOffset.y;
            } else {
                headerRect.origin.y = footerAttributes.frame.origin.y - headerRect.size.height;
            }
            headerAttributes.frame = headerRect;
        } else {
            //如果找到一个区头 符合这个条件, 则不再执行其他区
            if (headerAttributes.frame.origin.x >= self.collectionView.contentOffset.x) {
                return self.attributesArray;
            }
            
            if (self.collectionView.contentOffset.x < sectionBgAttirbutes.frame.size.width + headerAttributes.frame.origin.x) {
                headerRect.origin.x = self.collectionView.contentOffset.x;
            } else {
                headerRect.origin.x = footerAttributes.frame.origin.x - headerRect.size.width;
            }
            headerAttributes.frame = headerRect;
        }
        
    }
    
    return self.attributesArray;
    
}

//这里返回是否浮动区头, 否则不会重复调用.
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    return self.sectionHeadersPinToVisibleBounds;
}

#pragma mark - 懒加载
- (NSInteger)columnCount {
    if (_columnCount) {return _columnCount;}
    return DefaultColumnCpunt;
}

- (NSMutableArray *)attributesArray {
    if (!_attributesArray) {_attributesArray = [[NSMutableArray alloc] init];}
    return _attributesArray;
}

- (NSMutableArray *)columnDistances {
    if (!_columnDistances) {_columnDistances = [NSMutableArray arrayWithCapacity:DefaultColumnCpunt];}
    return _columnDistances;
}

- (NSMutableArray *)decorationViewAttrs {
    if (!_decorationViewAttrs) {_decorationViewAttrs = [[NSMutableArray alloc] init];}
    return _decorationViewAttrs;
}

- (NSMutableArray *)headerArray {
    if (!_headerArray) {_headerArray = [[NSMutableArray alloc] init];}
    return _headerArray;
}

- (NSMutableArray *)itemArray {
    if (!_itemArray) {_itemArray = [[NSMutableArray alloc] init];}
    return _itemArray;
}

- (NSMutableArray *)footerArray {
    if (!_footerArray) {_footerArray = [[NSMutableArray alloc] init];}
    return _footerArray;
}

@end

@implementation ZZCollectionReusableView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    
    [super applyLayoutAttributes:layoutAttributes];
    
    if ([layoutAttributes isKindOfClass:[ZZCollectionViewLayoutAttributes class]]) {
        ZZCollectionViewLayoutAttributes *attr = (ZZCollectionViewLayoutAttributes *)layoutAttributes;
        self.backgroundColor = attr.backgroudColor;
    }
    
}

@end

@implementation ZZCollectionViewLayoutAttributes

@end

//@implementation UICollectionReusableView (ZZLayout)
//
//char const ZZ_SECTION;
//
//- (void)setZz_section:(NSInteger)zz_section {
//    objc_setAssociatedObject(self, &ZZ_SECTION, @(zz_section), OBJC_ASSOCIATION_ASSIGN);
//}
//
//- (NSInteger)zz_section {
//    return [objc_getAssociatedObject(self, &ZZ_SECTION) integerValue];
//}
//
//@end
//
//
//char const ZZ_CELLHEIGHT;
//
//@implementation UICollectionViewCell (ZZLayout)
//
//
//- (void)setZz_cellHeight:(CGFloat)zz_cellHeight {
//    objc_setAssociatedObject(self, &ZZ_CELLHEIGHT, @(zz_cellHeight), OBJC_ASSOCIATION_ASSIGN);
//}
//
//- (CGFloat)zz_cellHeight {
//    return [objc_getAssociatedObject(self, &ZZ_CELLHEIGHT) floatValue];
//}
//
//@end

