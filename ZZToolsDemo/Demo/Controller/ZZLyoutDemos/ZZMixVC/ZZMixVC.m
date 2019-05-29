//
//  ZZMixVC.m
//  ZZToolsDemo
//
//  Created by yons on 2019/3/11.
//  Copyright © 2019年 刘猛. All rights reserved.
//

#import "ZZMixVC.h"
#import "ZZTools.h"
#import <MJRefresh/MJRefresh.h>
#import "ZZCollectionViewCell.h"
#import "ZZCollectionHeaderView.h"

@interface ZZMixVC ()<UICollectionViewDelegate, UICollectionViewDataSource, ZZLayoutDelegate>

/**页面主视图*/
@property (nonatomic , strong) UICollectionView *collectionView;

/**数据数组*/
@property (nonatomic , strong) NSMutableArray   *models;


@end

@implementation ZZMixVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"混合";
    [self.view addSubview:self.collectionView];
}

#pragma mark- 协议方法
//collectionView的协议方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了第: %ld个区的第: %ld个item",indexPath.section,indexPath.row);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZZCollectionViewCell" forIndexPath:indexPath];
    
    cell.title = [NSString stringWithFormat:@"第%ld个", indexPath.row];
    int r = rand() % 255;
    int g = rand() % 255;
    int b = rand() % 255;
    cell.backgroundColor = [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1];
    
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return random() % 20 + 30;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableView = nil;
    // 区头
    if (kind == UICollectionElementKindSectionHeader) {
        ZZCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZZCollectionHeaderView" forIndexPath:indexPath];
        headerView.label.text = [NSString stringWithFormat:@"这里是第: %ld个区的区头",indexPath.section];
        reusableView = headerView;
    }
    // 区尾
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" forIndexPath:indexPath];
        reusableView = footerView;
    }
    return reusableView;
}

//ZZLyout的流协议方法
- (CGFloat)layout:(ZZLayout *)layout heightForRowAtIndexPath:(NSIndexPath *)indexPath {//返回item的高
    if (indexPath.section %2 == 0) {
        return 30;
    }
    return random() % 120 + 20;//同一section下请不要改变高度.
}

- (CGFloat)layout:(ZZLayout *)layout widthForRowAtIndexPath:(NSIndexPath *)indexPath {//返回item的宽
    return random() % 120 + 60;//这里可以根据内容传入任意宽度
}

- (UIEdgeInsets)layout:(ZZLayout *)layout insetForSectionAtIndex:(NSInteger)section {//设置每个区的边距
    return UIEdgeInsetsMake(10, 20, 10, 20);
}

- (ZZLayoutFlowType)layout:(ZZLayout *)layout layoutFlowTypeForSectionAtIndex:(NSInteger)section {//如果重写了这个方法, 滚动类型则可变, 混合类型不支持对水平的支持
    if (section % 2 == 0) {
        return ZZLayoutFlowTypeAutomateFloat;
    }
    return ZZLayoutFlowTypeVertical;
}

- (NSInteger)layout:(ZZLayout *)layout lineSpacingForSectionAtIndex:(NSInteger)section {//设置每个区的行间距
    return 10;
}

- (CGFloat) layout:(ZZLayout *)layout interitemSpacingForSectionAtIndex:(NSInteger)section {//设置每个区的列间距
    return 15;
}

- (CGSize)layout:(ZZLayout *)layout referenceSizeForHeaderInSection:(NSInteger)section {//设置区头的高度
    return CGSizeMake(self.view.bounds.size.width, 44);
}

- (UIColor *)layout:(UICollectionView *)layout colorForSection:(NSInteger)section {
    if (section == 1) {
        return [UIColor redColor];
    }
    return [UIColor darkGrayColor];
}

#pragma mark- 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        ZZLayout *layout = [[ZZLayout alloc] initWith:ZZLayoutFlowTypeVertical delegate:self];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64 - ([UIScreen mainScreen].bounds.size.height >= 812.f ? 24 : 0)) collectionViewLayout:layout];
        _collectionView.delegate = self;_collectionView.dataSource = self;
        
        //实现"头视图"效果
        UILabel *headerView = [[UILabel alloc] init];
        headerView.frame = CGRectMake(0, -200, self.view.bounds.size.width, 200);
        headerView.backgroundColor = [UIColor whiteColor];
        headerView.text = @"实现类似tableView的头视图效果.";
        headerView.textColor = [UIColor blackColor];
        headerView.backgroundColor = [UIColor redColor];
        headerView.textAlignment = NSTextAlignmentCenter;
        [_collectionView addSubview:headerView];
        _collectionView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
        
        //配合MJRefresh可这么使用.
        __weak typeof(self)weakSelf = self;
        MJRefreshNormalHeader *header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView reloadData];
        }];
        
        header.ignoredScrollViewContentInsetTop = 200;
        _collectionView.mj_header = header;
        
        //注册cell
        [_collectionView registerClass:[ZZCollectionViewCell class] forCellWithReuseIdentifier:@"ZZCollectionViewCell"];
        [_collectionView registerClass:[ZZCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZZCollectionHeaderView"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter"];
        
        //_collectionView.contentInset = UIEdgeInsetsMake(AfW(319), 0, 0, 0);
        _collectionView.showsHorizontalScrollIndicator = NO;_collectionView.bounces = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        if (@available(iOS 11.0, *)) {_collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;}
        _collectionView.backgroundColor = [UIColor whiteColor];
        
    }
    return _collectionView;
}

@end
