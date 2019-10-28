//
//  UITableView+ZZAutoTableViewCellHeight.m
//  ZZAutoLayout 测试 Demo
//
//  Created by aier on 15/11/1.
//  Copyright © 2015年 gsd. All rights reserved.
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

#import "UITableView+ZZAutoTableViewCellHeight.h"
#import <objc/runtime.h>

@interface ZZCellzz_autoHeightManager ()

@property (nonatomic, weak) UITableView *modelTableview;

@end

@implementation ZZCellzz_autoHeightManager
{
    NSMutableDictionary *_cacheDictionary;
    NSMutableDictionary *_modelCellsDict;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCellClass:(Class)cellClass tableView:(UITableView *)tableView
{
    if (self = [super init]) {
        [self setup];
        self.modelTableview = tableView;
        [self registerCellWithCellClass:cellClass];
    }
    return self;
}

- (instancetype)initWithCellClasses:(NSArray *)cellClassArray tableView:(UITableView *)tableView
{
    if (self = [super init]) {
        [self setup];
        self.modelTableview = tableView;
        [cellClassArray enumerateObjectsUsingBlock:^(Class obj, NSUInteger idx, BOOL *stop) {
            [self registerCellWithCellClass:obj];
        }];
    }
    return self;
}

- (void)setup
{
    _cacheDictionary = [NSMutableDictionary new];
    _modelCellsDict = [NSMutableDictionary new];
}

- (void)registerCellWithCellClass:(Class)cellClass
{
    [_modelTableview registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
    self.modelCell = [_modelTableview dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass)];
    
    if (!self.modelCell.contentView.subviews.count) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@.nib", NSStringFromClass(cellClass)] ofType:nil];
        if (path) {
            self.modelCell = nil;
            [_modelTableview registerNib:[UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil] forCellReuseIdentifier:NSStringFromClass(cellClass)];
            self.modelCell = [_modelTableview dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass)];
        }
    }
    if (self.modelCell) {
        [_modelCellsDict setObject:self.modelCell forKey:NSStringFromClass(cellClass)];
    }
}

+ (instancetype)managerWithCellClass:(Class)cellClass tableView:(UITableView *)tableView
{
    ZZCellzz_autoHeightManager *manager = [[self alloc] initWithCellClass:cellClass tableView:tableView];
    return manager;
}

- (UITableViewCell *)modelCell
{
    if (_modelCell.contentView.tag != kZZModelCellTag) {
        _modelCell.contentView.tag = kZZModelCellTag;
    }
    return _modelCell;
}

- (NSDictionary *)heightCacheDict
{
    return _cacheDictionary;
}

- (void)clearHeightCache
{
    [_cacheDictionary removeAllObjects];
    [_subviewFrameCacheDict removeAllObjects];
}

- (NSString *)cacheKeyForIndexPath:(NSIndexPath *)indexPath
{
    return [NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section, (long)indexPath.row];
}

- (void)clearHeightCacheOfIndexPaths:(NSArray *)indexPaths
{
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        NSString *cacheKey = [self cacheKeyForIndexPath:indexPath];
        [self->_cacheDictionary removeObjectForKey:cacheKey];
        [self->_subviewFrameCacheDict removeObjectForKey:cacheKey];
    }];
}

- (void)deleteThenResetHeightCache:(NSIndexPath *)indexPathToDelete
{

    NSString *cacheKey = [self cacheKeyForIndexPath:indexPathToDelete];
    [_cacheDictionary removeObjectForKey:cacheKey];
    [_subviewFrameCacheDict removeObjectForKey:cacheKey];
    
    long sectionOfToDeleteItem = indexPathToDelete.section;
    long rowOfToDeleteItem = indexPathToDelete.row;
    NSMutableDictionary *tempHeightCacheDict = [NSMutableDictionary new];
    NSMutableDictionary *tempFrameCacheDict = [NSMutableDictionary new];
    for (NSString *key in _cacheDictionary.allKeys) {
        NSArray *res = [key componentsSeparatedByString:@"-"];
        long section = [res.firstObject integerValue];
        long row = [res.lastObject integerValue];
        if (section == sectionOfToDeleteItem && row > rowOfToDeleteItem) {
            NSNumber *heightCache = _cacheDictionary[key];
            NSArray *frameCache = _subviewFrameCacheDict[key];
            NSString *newKey = [NSString stringWithFormat:@"%ld-%ld", section, (row - 1)];
            [tempHeightCacheDict setValue:heightCache forKey:newKey];
            [tempFrameCacheDict setValue:frameCache forKey:newKey];
            [_cacheDictionary removeObjectForKey:key];
            [_subviewFrameCacheDict removeObjectForKey:key];
        }
    }
    [_cacheDictionary addEntriesFromDictionary:tempHeightCacheDict];
    [_subviewFrameCacheDict addEntriesFromDictionary:tempFrameCacheDict];

}

- (void)insertNewDataAtTheBeginingOfSection:(NSInteger)section newDataCount:(NSInteger)count
{
    NSMutableDictionary *tempHeightCacheDict = [NSMutableDictionary new];
    NSMutableDictionary *tempFrameCacheDict = [NSMutableDictionary new];
    for (NSString *key in _cacheDictionary.allKeys) {
        NSArray *res = [key componentsSeparatedByString:@"-"];
        long originalSection = [res.firstObject integerValue];
        long row = [res.lastObject integerValue];
        if (originalSection == section) {
            NSNumber *heightCache = _cacheDictionary[key];
            NSArray *frameCache = _subviewFrameCacheDict[key];
            NSString *newKey = [NSString stringWithFormat:@"%ld-%ld", originalSection, (row + count)];
            [tempHeightCacheDict setValue:heightCache forKey:newKey];
            [tempFrameCacheDict setValue:frameCache forKey:newKey];
            [_cacheDictionary removeObjectForKey:key];
            [_subviewFrameCacheDict removeObjectForKey:key];
        }
    }
    [_cacheDictionary addEntriesFromDictionary:tempHeightCacheDict];
    [_subviewFrameCacheDict addEntriesFromDictionary:tempFrameCacheDict];
}

- (void)insertNewDataAtIndexPaths:(NSArray *)indexPaths
{
    NSMutableDictionary *sectionsdict = [NSMutableDictionary new];
    for (NSIndexPath *indexPath in indexPaths) {
        NSString *sectionkey = [@(indexPath.section) stringValue];
        if (![sectionsdict objectForKey:sectionkey]) {
            [sectionsdict setValue:[NSMutableArray new] forKey:sectionkey];
        }
        NSMutableArray *arr = sectionsdict[sectionkey];
        [arr addObject:indexPath];
    }
    for (NSString *sectionkey in sectionsdict.allKeys) {
        NSMutableArray *tempHeightCaches = [NSMutableArray new];
        NSMutableArray *tempFrameCaches = [NSMutableArray new];
        NSInteger section = [sectionkey integerValue];
        NSInteger rowCount = [self.modelTableview numberOfRowsInSection:section];
        if (rowCount <= 0) {
            continue;
        } else {
            for (int i = 0; i < rowCount; i++) {
                [tempHeightCaches addObject:[NSNull null]];
                [tempFrameCaches addObject:[NSNull null]];
            }
        }
        
        for (NSString *key in _cacheDictionary.allKeys) {
            NSArray *res = [key componentsSeparatedByString:@"-"];
            long originalSection = [res.firstObject integerValue];
            long row = [res.lastObject integerValue];
            if (originalSection == section) {
                NSNumber *heightCache = _cacheDictionary[key];
                NSArray *frameCache = _subviewFrameCacheDict[key];
                [tempHeightCaches setObject:heightCache atIndexedSubscript:row];
                [tempFrameCaches setObject:frameCache atIndexedSubscript:row];
                [_cacheDictionary removeObjectForKey:key];
                [_subviewFrameCacheDict removeObjectForKey:key];
            }
        }
        NSMutableArray *objsToInsert = [NSMutableArray new];
        NSMutableIndexSet *indexSet = [NSMutableIndexSet new];
        NSArray *indexPaths = sectionsdict[sectionkey];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *obj, NSUInteger idx, BOOL *stop) {
            [objsToInsert addObject:[NSNull null]];
            [indexSet addIndex:obj.row];
        }];
        [tempHeightCaches insertObjects:objsToInsert atIndexes:indexSet];
        [tempFrameCaches insertObjects:objsToInsert atIndexes:indexSet];
        [tempHeightCaches enumerateObjectsUsingBlock:^(NSNumber *heightCache, NSUInteger idx, BOOL *stop) {
            if (![heightCache isKindOfClass:[NSNull class]]) {
                NSString *key = [NSString stringWithFormat:@"%zd-%zd", section, idx];
                [self->_cacheDictionary setValue:heightCache forKey:key];
                [self->_subviewFrameCacheDict setValue:[tempFrameCaches objectAtIndex:idx] forKey:key];
            }
        }];
    }
}

- (NSNumber *)heightCacheForIndexPath:(NSIndexPath *)indexPath
{
    /*
     如果程序卡在了这里很可能是由于你用了“dequeueReusableCellWithIdentifier:forIndexPath:”方法来重用cell，换成““dequeueReusableCellWithIdentifier:”（不带IndexPath）方法即可解决
     */
    NSString *cacheKey = [self cacheKeyForIndexPath:indexPath];
    return (NSNumber *)[_cacheDictionary objectForKey:cacheKey];
}

- (CGFloat)zz_cellHeightForIndexPath:(NSIndexPath *)indexPath model:(id)model keyPath:(NSString *)keyPath
{
    
    NSNumber *cacheHeight = [self heightCacheForIndexPath:indexPath];
    if (cacheHeight) {
        return [cacheHeight floatValue];
    } else {
        if (!self.modelCell) {
            return 0;
        }
        
        if (self.modelTableview && self.modelTableview != self.modelCell.zz_tableView) {
            self.modelCell.zz_tableView = self.modelTableview;
        }
        self.modelCell.zz_indexPath = indexPath;
        
        if (model && keyPath) {
            [self.modelCell setValue:model forKey:keyPath];
        } else if (self.cellDataSetting) {
            self.cellDataSetting(self.modelCell);
        }
        
        
#ifdef ZZDebugWithAssert
        /*
         如果程序卡在了这里说明你的cell还没有调用“zz_setupzz_autoHeightWithBottomView:(UIView *)bottomView bottomMargin:(CGFloat)bottomMargin”方法或者你传递的bottomView为nil，请检查并修改。例：
         
         //注意：bottomView不能为nil
         [cell zz_setupzz_autoHeightWithBottomView:bottomView bottomMargin:bottomMargin];
         */
        NSAssert(self.modelCell.zz_bottomViewsArray.count, @">>>>>> 你的cell还没有调用“zz_setupzz_autoHeightWithBottomView:(UIView *)bottomView bottomMargin:(CGFloat)bottomMargin”方法或者你传递的bottomView为nil，请检查并修改");
        
#endif
        
        [self.modelCell.contentView layoutSubviews];
        NSString *cacheKey = [self cacheKeyForIndexPath:indexPath];
        [_cacheDictionary setObject:@(self.modelCell.zz_autoHeight) forKey:cacheKey];
        
        
        if (self.modelCell.zz_indexPath && self.modelCell.zz_tableView) {
            if (self.modelCell.contentView.zz_shouldReadjustFrameBeforeStoreCache) {
                self.modelCell.contentView.height_zz = self.modelCell.zz_autoHeight;
                [self.modelCell.contentView layoutSubviews];
            }
            [self.modelCell.contentView.autoLayoutModelsArray enumerateObjectsUsingBlock:^(ZZAutoLayoutModel *model, NSUInteger idx, BOOL *stop) {
                [self.modelTableview.cellzz_autoHeightManager setSubviewFrameCache:model.needsAutoResizeView.frame WithIndexPath:self.modelCell.zz_indexPath];
            }];
        }
        
        
        return self.modelCell.zz_autoHeight;
    }
}

- (CGFloat)zz_cellHeightForIndexPath:(NSIndexPath *)indexPath model:(id)model keyPath:(NSString *)keyPath cellClass:(Class)cellClass
{
    if (![self.modelCell isKindOfClass:cellClass]) {
        self.modelCell = nil;
        self.modelCell = [_modelCellsDict objectForKey:NSStringFromClass(cellClass)];
        if (!self.modelCell) {
            [self registerCellWithCellClass:cellClass];
        }
        _modelCell.contentView.tag = kZZModelCellTag;
    }
    if (self.modelCell.contentView.width_zz != self.contentViewWidth) {
        _modelCell.contentView.width_zz = self.contentViewWidth;
    }
    return [self zz_cellHeightForIndexPath:indexPath model:model keyPath:keyPath];
}

- (void)setContentViewWidth:(CGFloat)contentViewWidth
{
    if (_contentViewWidth == contentViewWidth) return;
    
    CGFloat lastContentViewWidth = _contentViewWidth;
    _contentViewWidth = contentViewWidth;
    
    self.modelCell.contentView.width_zz = self.contentViewWidth;
    
    if (lastContentViewWidth > 0) {
        [_subviewFrameCacheDict removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self clearHeightCache];
            [self.modelTableview reloadData];
        });
    }
}


- (void)setSubviewFrameCache:(CGRect)rect WithIndexPath:(NSIndexPath *)indexPath
{
    if (!self.subviewFrameCacheDict) {
        self.subviewFrameCacheDict = [NSMutableDictionary new];
    }
    NSString *cacheKey = [self cacheKeyForIndexPath:indexPath];
    NSMutableArray *caches = [self.subviewFrameCacheDict objectForKey:cacheKey];
    if (!caches) {
        caches = [NSMutableArray new];
        [self.subviewFrameCacheDict setValue:caches forKey:cacheKey];
    }
    [caches addObject:[NSValue valueWithCGRect:rect]];
}

- (NSMutableArray *)subviewFrameCachesWithIndexPath:(NSIndexPath *)indexPath
{
    NSString *cacheKey = [self cacheKeyForIndexPath:indexPath];
    return [self.subviewFrameCacheDict valueForKey:cacheKey];
}

@end


@implementation UITableView (ZZAutoTableViewCellHeight)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSArray *selStringsArray = @[@"reloadData", @"reloadRowsAtIndexPaths:withRowAnimation:", @"deleteRowsAtIndexPaths:withRowAnimation:", @"insertRowsAtIndexPaths:withRowAnimation:"];
        
        [selStringsArray enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {
            NSString *mySelString = [@"zz_" stringByAppendingString:selString];
            
            Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
            Method myMethod = class_getInstanceMethod(self, NSSelectorFromString(mySelString));
            method_exchangeImplementations(originalMethod, myMethod);
        }];
    });
}

- (void)zz_reloadData
{
    if (!self.cellzz_autoHeightManager.shouldKeepHeightCacheWhenReloadingData) {
        [self.cellzz_autoHeightManager clearHeightCache];
    }
    [self zz_reloadData];
    self.cellzz_autoHeightManager.shouldKeepHeightCacheWhenReloadingData = NO;
}

- (void)zz_reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self.cellzz_autoHeightManager clearHeightCacheOfIndexPaths:indexPaths];
    [self zz_reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)zz_deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    for (NSIndexPath *indexPath in indexPaths) {
        [self.cellzz_autoHeightManager deleteThenResetHeightCache:indexPath];
    }
    [self zz_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}


- (void)zz_insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self.cellzz_autoHeightManager insertNewDataAtIndexPaths:indexPaths];
    [self zz_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

/*
 * 下一步即将实现的功能
 
 - (void)zz_moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath
 {
 [self zz_moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
 }
 
 */

- (CGFloat)zz_cellHeightForIndexPath:(NSIndexPath *)indexPath model:(id)model keyPath:(NSString *)keyPath cellClass:(Class)cellClass contentViewWidth:(CGFloat)contentViewWidth
{
    self.cellzz_autoHeightManager.modelTableview = self;
    
    self.cellzz_autoHeightManager.contentViewWidth = contentViewWidth;
    
    return [self.cellzz_autoHeightManager zz_cellHeightForIndexPath:indexPath model:model keyPath:keyPath cellClass:cellClass];
}

- (CGFloat)zz_cellHeightForIndexPath:(NSIndexPath *)indexPath cellClass:(__unsafe_unretained Class)cellClass cellContentViewWidth:(CGFloat)width cellDataSetting:(ZZAutoCellHeightDataSettingBlock)cellDataSetting
{

    self.cellDataSetting = cellDataSetting;

    return [self zz_cellHeightForIndexPath:indexPath model:nil keyPath:nil cellClass:cellClass contentViewWidth:width];
}

- (void)reloadDataWithEzz_xIstedHeightCache
{
    self.cellzz_autoHeightManager.shouldKeepHeightCacheWhenReloadingData = YES;
    [self reloadData];
}

- (void)reloadDataWithInsertingDataAtTheBeginingOfSection:(NSInteger)section newDataCount:(NSInteger)count
{
    self.cellzz_autoHeightManager.shouldKeepHeightCacheWhenReloadingData = YES;
    [self.cellzz_autoHeightManager insertNewDataAtTheBeginingOfSection:section newDataCount:count];
    [self reloadData];
}

- (void)reloadDataWithInsertingDataAtTheBeginingOfSections:(NSArray *)sectionNumsArray newDataCounts:(NSArray *)dataCountsArray
{
    self.cellzz_autoHeightManager.shouldKeepHeightCacheWhenReloadingData = YES;
    [sectionNumsArray enumerateObjectsUsingBlock:^(NSNumber *num, NSUInteger idx, BOOL *stop) {
        int section = [num intValue];
        int dataCountForSection = [dataCountsArray[idx] intValue];
        [self.cellzz_autoHeightManager insertNewDataAtTheBeginingOfSection:section newDataCount:dataCountForSection];
    }];
    [self reloadData];
}

- (CGFloat)cellsTotalHeight
{
    CGFloat h = 0;
    if (!self.cellzz_autoHeightManager.heightCacheDict.count) {
        [self reloadData];
    }
    NSArray *values = [self.cellzz_autoHeightManager.heightCacheDict allValues];
    for (NSNumber *number in values) {
        h += [number floatValue];
    }
    return h;
}

- (ZZCellzz_autoHeightManager *)cellzz_autoHeightManager
{
    
    ZZCellzz_autoHeightManager *cellzz_autoHeightManager = objc_getAssociatedObject(self, _cmd);
    
    if (!cellzz_autoHeightManager) {
        
        cellzz_autoHeightManager = [[ZZCellzz_autoHeightManager alloc] init];
        
        [self setCellzz_autoHeightManager:cellzz_autoHeightManager];
    }
    
    return cellzz_autoHeightManager;
}

- (void)setCellzz_autoHeightManager:(ZZCellzz_autoHeightManager *)cellzz_autoHeightManager
{
    objc_setAssociatedObject(self, @selector(cellzz_autoHeightManager), cellzz_autoHeightManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setCellDataSetting:(ZZAutoCellHeightDataSettingBlock)cellDataSetting
{
    self.cellzz_autoHeightManager.cellDataSetting = cellDataSetting;
}

- (ZZAutoCellHeightDataSettingBlock)cellDataSetting
{
    return self.cellzz_autoHeightManager.cellDataSetting;
}

@end


@implementation UITableViewController (ZZTableViewControllerAutoCellHeight)

- (CGFloat)zz_cellHeightForIndexPath:(NSIndexPath *)indexPath cellContentViewWidth:(CGFloat)width
{
    return [self zz_cellHeightForIndexPath:indexPath cellContentViewWidth:width tableView:self.tableView];
}

@end

@implementation NSObject (ZZAnyObjectAutoCellHeight)

- (CGFloat)zz_cellHeightForIndexPath:(NSIndexPath *)indexPath cellContentViewWidth:(CGFloat)width tableView:(UITableView *)tableView
{
    tableView.cellzz_autoHeightManager.modelTableview = tableView;

    if (tableView.cellzz_autoHeightManager.contentViewWidth != width) {
        tableView.cellzz_autoHeightManager.contentViewWidth = width;
    }
    if ([tableView.cellzz_autoHeightManager heightCacheForIndexPath:indexPath]) {
        return [[tableView.cellzz_autoHeightManager heightCacheForIndexPath:indexPath] floatValue];
    }
    UITableViewCell *cell = [tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    tableView.cellzz_autoHeightManager.modelCell = cell;
    if (cell.contentView.width_zz != width) {
        cell.contentView.width_zz = width;
    }
    return [[tableView cellzz_autoHeightManager] zz_cellHeightForIndexPath:indexPath model:nil keyPath:nil];
}

@end

