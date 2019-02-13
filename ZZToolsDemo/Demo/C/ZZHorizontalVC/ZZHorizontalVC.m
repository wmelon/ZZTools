//
//  ZZHorizontalVC.m
//  ZZProjectOC
//
//  Created by 刘猛 on 2019/1/18.
//  Copyright © 2019 刘猛. All rights reserved.
//

#import "ZZTools.h"
#import "ZZHorizontalVC.h"
#import <MJRefresh/MJRefresh.h>
#import "ZZCollectionViewCell.h"
#import "ZZCollectionHeaderView.h"

@interface ZZHorizontalVC ()<UICollectionViewDelegate, UICollectionViewDataSource, ZZLayoutDelegate>

/**页面主视图*/
@property (nonatomic , strong) UICollectionView *collectionView;

/**数据数组*/
@property (nonatomic , strong) NSMutableArray   *models;

@end

@implementation ZZHorizontalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"水平瀑布流";
    [self.view addSubview:self.collectionView];
}

#pragma mark- 协议方法
//collectionView的协议方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return rand() % 5 + 6;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return random() % 20 + 20;
    
}

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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableView = nil;
    // 区头
    if (kind == UICollectionElementKindSectionHeader) {
        ZZCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZZCollectionHeaderView" forIndexPath:indexPath];
        headerView.label.text = [NSString stringWithFormat:@"    %ld",indexPath.section];
        reusableView = headerView;
    }
    // 区尾
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" forIndexPath:indexPath];
        reusableView = footerView;
    }
    return reusableView;
}

//瀑布流协议方法
- (CGFloat)layout:(ZZLayout *)collectionViewLayout widthForRowAtIndexPath:(NSIndexPath *)indexPath {//返回item的宽
    return random() % 100 + 80;
}

- (NSInteger)layout:(ZZLayout *)collectionViewLayout columnNumberAtSection:(NSInteger)section {//每个区有几列(横向的列)
    return section % 2 == 0 ? 10 : 12;
}

- (UIEdgeInsets)layout:(ZZLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {//设置每个区的边距
    if (section % 2 == 0) {
        return UIEdgeInsetsMake(10, 0, 10, 0);
    }
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (NSInteger)layout:(ZZLayout *)collectionViewLayout lineSpacingForSectionAtIndex:(NSInteger)section {//设置每个区的行间距
    return 10;
}

- (CGFloat)layout:(ZZLayout *)collectionViewLayout interitemSpacingForSectionAtIndex:(NSInteger)section {//设置每个区的列间距
    return 15;
}

- (CGSize)layout:(ZZLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {//设置区头的高度
    return CGSizeMake(44, self.collectionView.bounds.size.height);
}

#pragma mark- 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        ZZLayout *layout = [[ZZLayout alloc] initWith:ZZLayoutFlowTypeHorizontal delegate:self];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64 - ([UIScreen mainScreen].bounds.size.height >= 812.f ? 24 : 0)) collectionViewLayout:layout];
        _collectionView.delegate = self;_collectionView.dataSource = self;
        
//        //实现"头视图"效果
//        UILabel *headerView = [[UILabel alloc] init];
//        headerView.frame = CGRectMake(0, -200, self.view.bounds.size.width, 200);
//        headerView.backgroundColor = [UIColor whiteColor];
//        headerView.text = @"实现类似tableView的头视图效果.";
//        headerView.textColor = [UIColor blackColor];
//        headerView.textAlignment = NSTextAlignmentCenter;
//        [_collectionView addSubview:headerView];
//        _collectionView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
        
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

- (void)dealloc {
    NSLog(@"水平瀑布流dealloc");
}

@end
