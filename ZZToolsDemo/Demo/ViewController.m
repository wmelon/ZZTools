//
//  ViewController.m
//  ZZProjectOC
//
//  Created by 刘猛 on 2019/1/3.
//  Copyright © 2019 刘猛. All rights reserved.
//

#import "ZZTools.h"
#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

/**页面主视图*/
@property (nonatomic , strong) UITableView  *tableView;

/**标题数组*/
@property (nonatomic , strong) NSArray      *titles;

@end

@implementation ViewController

+ (void)load {
    
    [[ZZRouter shared] mapRoute:@"app/demo/starView" toControllerClass:NSClassFromString(@"ZZStarViewVC")];//星星评价
    [[ZZRouter shared] mapRoute:@"app/demo/vertical" toControllerClass:NSClassFromString(@"ZZVerticalVC")];//垂直瀑布流
    [[ZZRouter shared] mapRoute:@"app/demo/horizontal" toControllerClass:NSClassFromString(@"ZZHorizontalVC")];//水平瀑布流
    [[ZZRouter shared] mapRoute:@"app/demo/automateFloat" toControllerClass:NSClassFromString(@"ZZAutomateFloatVC")];//浮动瀑布流
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZZToolsDemo";
    self.titles = @[@"竖直方向瀑布流", @"水平方向瀑布流", @"浮动瀑布流(可实现淘宝商品详情SKU选择)", @"星星评价, 支持间距, 滑动交互, 分阶, 最低分"];
    [self.view addSubview:self.tableView];
}

#pragma mark- 协议方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //1.取消选中
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //2.通过路由获取要跳转的控制器对象, 并跳转.页面路由可打断模块之间的耦合, 实现组件化.
    UIViewController *vc = nil;
    if (indexPath.row == 0) {
        vc = [[ZZRouter shared] getController:[NSString stringWithFormat:@"app/demo/vertical"]];
    } else if (indexPath.row == 1) {
        vc = [[ZZRouter shared] getController:[NSString stringWithFormat:@"app/demo/horizontal"]];
    } else if (indexPath.row == 2) {
        vc = [[ZZRouter shared] getController:[NSString stringWithFormat:@"app/demo/automateFloat"]];
    } else if (indexPath.row == 3) {
        //星星评价, 传参实例, 类似get请求.
        NSString *url = [NSString stringWithFormat:@"app/demo/starView?grade1=%@&grade2=%@&grade3=%@",@"3.5",@"2",@"2.8"];
        vc = [[ZZRouter shared] getController:url];
        vc.routerCallBack = ^(NSDictionary * _Nonnull result) {
            //这里是次级控制器反向传值
            NSLog(@"result === %@",result);
        };
        
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
