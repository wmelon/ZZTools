//
//  CustomLayout.m
//  collectionView
//
//  Created by 刘猛 on 2018/11/30.
//  Copyright © 2018年 刘猛. All rights reserved.
//

#import "ZZLayout.h"

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

//区头尺寸
@property (nonatomic , assign) CGSize           headerReferenceSize;

//区尾尺寸
@property (nonatomic , assign) CGSize           footerReferenceSize;

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

@end

@implementation ZZLayout

- (instancetype)init {
    if (self == [super init]) {
        //默认滚动方向为u垂直
        self.scrollDirection = ZZLayoutFlowTypeVertical;
    }
    return self;
}

//自定义初始化方法, 建议使用
- (instancetype)initWith:(ZZLayoutFlowType)scrollDirection delegate:(id<ZZLayoutDelegate>)delegate {
    if (self == [super init]) {
        self.scrollDirection = scrollDirection;
        self.delegate = delegate;
    }
    return self;
}

//准备布局,自定义layout必须重写
- (void)prepareLayout {
    [super prepareLayout];
    
    //1.清空数据
    self.lineSpacing = 0;
    self.contentDistance = 0;
    self.lastContentHeight = 0;
    self.spacingWithLastSection = 0;
    self.sectionInsets = UIEdgeInsetsZero;
    self.headerReferenceSize = CGSizeZero;
    self.footerReferenceSize = CGSizeZero;
    [self.columnDistances removeAllObjects];
    [self.attributesArray removeAllObjects];
    
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
        UICollectionViewLayoutAttributes *headerAttributs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        [self.attributesArray addObject:headerAttributs];
        [self.columnDistances removeAllObjects];
        self.lastContentHeight = self.contentDistance;
        
        //2.初始化区的distance值
        for (NSInteger i = 0; i < self.columnCount; i ++) {
            [self.columnDistances addObject:@(self.contentDistance)];
        }
        
        //3.每个区中有多少 item(布局每个区的每个cell)
        for (NSInteger j = 0; j < itemCountOfSection; j ++) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attributesArray addObject:attributes];
        }
        
        //4.初始化 footer
        UICollectionViewLayoutAttributes *footerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
        [self.attributesArray addObject:footerAttributes];
        
    }
}

//计算返回布局attributes
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
    
    //2.分类布局
    if (self.scrollDirection == ZZLayoutFlowTypeVertical) {
        
        return [self setupAttributesWithVertical:indexPath];
        
    } else if (self.scrollDirection == ZZLayoutFlowTypeAutomateFloat) {
        
        return [self setupAttributesWithVerticalFloat:indexPath];
        
    } else if (self.scrollDirection == ZZLayoutFlowTypeHorizontal) {
        
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
    }
    
    if (self.contentDistance < minColumnHeight) {
        self.contentDistance = minColumnHeight;
    }
    
    attributes.frame = CGRectMake(cellX, cellY, cellWeight, cellHeight);
    
    self.columnDistances[tempMinColumn] = @(CGRectGetMaxY(attributes.frame));
    // 取出最大的
    for (NSInteger i = 0; i < self.columnDistances.count; i++ ) {
        if (self.contentDistance < [self.columnDistances[i] doubleValue]) {
            self.contentDistance = [self.columnDistances[i] doubleValue];
        }
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

    if (self.contentDistance < minColumnWidth) {
        self.contentDistance = minColumnWidth;
    }
    
    
    attributes.frame = CGRectMake(cellX, cellY, cellWeight, cellHeight);
    self.columnDistances[tempMinColumn] = @(CGRectGetMaxX(attributes.frame));
    // 取出最大的
    for (NSInteger i = 0; i < self.columnDistances.count; i++ ) {
        if (self.contentDistance < [self.columnDistances[i] doubleValue]) {
            self.contentDistance = [self.columnDistances[i] doubleValue];
        }
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
        if (indexPath.row > 1) {
            currentFrame.origin.y = CGRectGetMaxY(lastFrame) + self.lineSpacing;
        } else {
            currentFrame.origin.y = CGRectGetMaxY(lastFrame) + self.sectionInsets.top;
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
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        if ([_delegate respondsToSelector:@selector(layout:referenceSizeForHeaderInSection:)]) {
            self.headerReferenceSize = [_delegate layout:self referenceSizeForHeaderInSection:indexPath.section];
        }
        
        if (self.scrollDirection != ZZLayoutFlowTypeHorizontal) {
            self.contentDistance += self.spacingWithLastSection;
            attributes.frame = CGRectMake(0,  self.contentDistance, self.headerReferenceSize.width, self.headerReferenceSize.height);
            self.contentDistance += self.sectionInsets.top;
            self.contentDistance += self.headerReferenceSize.height;
        } else {
            self.contentDistance += self.spacingWithLastSection;
            attributes.frame = CGRectMake(self.contentDistance,  0, self.headerReferenceSize.width, self.headerReferenceSize.height);
            self.contentDistance += self.sectionInsets.left;
            self.contentDistance += self.headerReferenceSize.width;
        }
        
    } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        
        if ([_delegate respondsToSelector:@selector(layout:referenceSizeForFooterInSection:)]) {
            self.footerReferenceSize = [_delegate layout:self referenceSizeForFooterInSection:indexPath.section];
        }
        
        if (self.scrollDirection != ZZLayoutFlowTypeHorizontal) {
            self.contentDistance += self.sectionInsets.bottom;
            attributes.frame = CGRectMake(0, self.contentDistance, self.footerReferenceSize.width, self.footerReferenceSize.height);
            self.contentDistance += self.footerReferenceSize.height;
        } else {
            self.contentDistance += self.sectionInsets.right;
            attributes.frame = CGRectMake(self.contentDistance, 0, self.footerReferenceSize.width, self.footerReferenceSize.height);
            self.contentDistance += self.footerReferenceSize.width;
        }
        
    }
    
    return attributes;
}

//collection的可滚动范围
- (CGSize)collectionViewContentSize {
    if (self.scrollDirection != ZZLayoutFlowTypeHorizontal) {
        return CGSizeMake(self.collectionView.frame.size.width, self.contentDistance);
    }
    return CGSizeMake(self.contentDistance, self.collectionView.frame.size.height);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributesArray;
}

#pragma mark - 懒加载
- (NSInteger)columnCount {
    if (_columnCount) {
        return _columnCount;
    }
    return DefaultColumnCpunt;
}

- (NSMutableArray *)attributesArray {
    if (!_attributesArray) {
        _attributesArray = [[NSMutableArray alloc] init];
    }
    return _attributesArray;
}

- (NSMutableArray *)columnDistances {
    if (!_columnDistances) {
        _columnDistances = [NSMutableArray arrayWithCapacity:DefaultColumnCpunt];
    }
    return _columnDistances;
}

@end
