//
//  ViewController.m
//  ZZProjectOC
//
//  Created by 刘猛 on 2019/1/3.
//  Copyright © 2019 刘猛. All rights reserved.
//

#import "ZZStarViewVC.h"
#import "ZZVerticalVC.h"
#import "ZZHorizontalVC.h"
#import "ViewController.h"
#import "ZZAutomateFloatVC.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

/**页面主视图*/
@property (nonatomic , strong) UITableView  *tableView;

/**标题数组*/
@property (nonatomic , strong) NSArray      *titles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZZToolsDemo";
    self.titles = @[@"竖直方向瀑布流", @"水平方向瀑布流", @"浮动瀑布流(可实现淘宝商品详情SKU选择)", @"星星评价, 支持间距, 滑动交互, 分阶, 最低分"];
    [self.view addSubview:self.tableView];
    ZZStarViewVC *vc = [[ZZStarViewVC alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark- 协议方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //1.取消选中
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //2.跳转到对应的控制器(有简单的写法, 把控制器类名字符串放在数组中, 通过字符串获取类名然后实例化对象, 有兴趣的可以自己研究一下)
    if (indexPath.row == 0) {
        ZZVerticalVC *vc = [[ZZVerticalVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        ZZHorizontalVC *vc = [[ZZHorizontalVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        ZZAutomateFloatVC *vc = [[ZZAutomateFloatVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 3) {
        ZZStarViewVC *vc = [[ZZStarViewVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}

#pragma mark- 懒加载
-(UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;_tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        self.edgesForExtendedLayout = UIRectEdgeNone;if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
    }
    return _tableView;
}


@end
