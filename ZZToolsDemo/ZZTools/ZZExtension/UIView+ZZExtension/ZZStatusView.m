//
//  ZZStatusView.m
//  ZZToolsDemo
//
//  Created by 刘猛 on 2019/9/28.
//  Copyright © 2018 刘猛. All rights reserved.
//

#import "ZZStatusView.h"
#import <SDAutoLayout.h>
#import "ZZPrivateHeader.h"
#import "UIColor+ZZExtension.h"
#import "UILabel+ZZExtension.h"

@interface ZZStatusView()

/**备注*/
@property (nonatomic, strong) UIImageView *imageView;

/**备注*/
@property (nonatomic, strong) UIButton    *messageButton;

@end

@implementation ZZStatusView

- (instancetype)initWithStyle:(ZZStatusStyle *)style status:(RequestStatus)status callBack:(ZZStatusViewRetryCallBack)callBack {
    if (self == [super init]) {
        self.hidden = NO;
        self.style = style;
        self.status = status;
        self.callBack = callBack;
        
        //1.设置frame
        self.frame = CGRectMake(0, style.topMargin, ZZWidth, style.superView.bounds.size.height - style.topMargin);
        //2.背景颜色
        self.backgroundColor = style.bgViewBackgorundColor ? self.style.bgViewBackgorundColor : [UIColor zz_colorWithCSS:@"#FFFFFF"];
        //3.添加到父视图
        [style.superView addSubview:self];[style.superView bringSubviewToFront:self];
        
        [self.imageView stopAnimating];
        
        //4.顶部的图片
        NSArray *imageNanemArray = @[ @"默认状态", @"ZZStatusView_loadError", @"ZZStatusView_noCollectionGoods", @"loading_1", @"ZZStatusView_noNetwork", style.noDataImageName.length > 0 ? style.noDataImageName : @"icon_empty", @"ZZStatusView_noCollectionGoods" ,@"ZZStatusView_noCollectionGoods", @"ZZStatusView_noCollectionShop", @"ZZStatusView_noAfterSalesOrder", @"ZZStatusView_noSystemMessage", @"ZZStatusView_noSearchRecords", @"ZZStatusView_noWithdrawalRecord", @"ZZStatusView_noEvaluation"];
        UIImage *image = [UIImage imageNamed:imageNanemArray[status]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:imageView];self.imageView = imageView;
        imageView.sd_layout.topSpaceToView(self, style.imageTopCon).centerXEqualToView(self)
        .widthIs(AfW(120)).heightIs(AfW(120));
        
        if (status == RequestStatusRequesting) {
            // 刘猛业务 设置动画
            NSMutableArray *imageArray = [NSMutableArray array];
            for (int i = 0; i < 80; i++) {
                NSString *imageName = [NSString stringWithFormat:@"loading_%d",i + 1];
                UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
                if (image) {[imageArray addObject:image];}
            }
            [imageView setAnimationImages:imageArray];
            [imageView setAnimationDuration:1.2];
            [imageView setAnimationRepeatCount:CGFLOAT_MAX];
            [imageView startAnimating];
        }
        //5.文字标题
        NSArray *messageTitleArray = @[ @"默认状态, 请勿展示", @"数据加载失败", @"加载成功", @"加载中", @"网络走丢了", @"空空的, 什么都没有呢", @"售空下架", @"暂无收藏宝贝", @"暂无收藏店铺", @"暂无售后订单", @"暂无系统消息", @"没有找到该商品", @"暂无提现记录", @"暂无评价" ];
        UILabel *messageTitleLabel = [[UILabel alloc] initWithTextColor:@"#FF333333" font:ZZSysFont(13) textAlignment:NSTextAlignmentCenter superView:self];
        messageTitleLabel.sd_layout.leftSpaceToView(messageTitleLabel.superview, 0).rightSpaceToView(messageTitleLabel.superview, 0)
        .topSpaceToView(imageView, AfW(47)).autoHeightRatio(0);
        [messageTitleLabel setMaxNumberOfLinesToShow:1];
        messageTitleLabel.text = messageTitleArray[status];
        
//        //6.问题内容
//        NSArray *messageContentArray = @[ @"加载失败, 请重新尝试", @"网络或服务器延迟，请稍后再试", @"成功预留, 请勿用于展示", @"", @"请您检查网络设置后重试", @"空空的, 什么都没有呢", @"商品已售空下架", @"您可以将喜欢的宝贝收藏到这里", @"您可以将喜欢的店铺收藏到这里", @"返回上一级去逛逛吧", @"返回上一级去逛逛吧", @"换个关键词再试试吧", @"返回上一级去逛逛吧", @"或许可以去抢个沙发哦" ];
//        UILabel *messageContentLabel = [[UILabel alloc] initWithTextColor:@"#FF666666" font:kFont(11) textAlignment:NSTextAlignmentCenter superView:self];
//        messageContentLabel.sd_layout.leftSpaceToView(messageContentLabel.superview, 0).rightSpaceToView(messageContentLabel.superview, 0)
//        .topSpaceToView(imageView, AfW(73)).autoHeightRatio(0);
//        [messageContentLabel setMaxNumberOfLinesToShow:1];
//        messageContentLabel.text = messageContentArray[status];
        
        //7.按钮标题
//        NSArray *buttonTitleArray = @[ @"重新加载", @"重新加载", @"重新加载", style.noDataMessage.length > 0 ? style.noDataMessage : @"空空如也", @"重新加载", @"重新加载", @"上一级", @"去收藏", @"去收藏", @"随便逛下", @"上一级", @"重新搜索", @"上一级", @"上一级" ];
//        self.messageButton = [[UIButton alloc] initWithTitle:buttonTitleArray[status] titleColor:@"#FFFF6059" font:kFont(12) image:nil selectImage:nil superView:self];
//        self.messageButton.sd_layout.centerXEqualToView(self).widthIs(AfW(110))
//        .topSpaceToView(imageView, AfW(114)).heightIs(AfW(34));
//        self.messageButton.layer.cornerRadius = AfW(17);
//        self.messageButton.layer.borderColor = [UIColor colorWithCSS:@"#FFFF6059"].CGColor;
//        self.messageButton.layer.borderWidth = 1;
//        [self.messageButton zz_setShadowWithColor:[UIColor colorWithCSS:@"#24FF6059"] cornerRadius:AfW(17)];
//        self.messageButton.backgroundColor = [UIColor whiteColor];
        
        if (status == RequestStatusRequesting) {//请求中(第一次请求的时候才会显示)
            self.messageButton.hidden = YES;
            return self;
        } else {
            self.messageButton.hidden = NO;
        }
        
        
        [self.messageButton addTarget:self action:@selector(retryButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        
        //        if (style.zz_hideBackButton == NO) {
        //            UIButton *backButton = [[UIButton alloc] initWithTitle:@"" titleColor:@"ffffff" font:kFont(12) image:@"状态页返回" selectImage:@"状态页返回" superView:self];
        //            backButton.sd_layout.topSpaceToView(self, AfW(6.5) + ZZSafeTopHeight * 2 + 20)
        //            .leftSpaceToView(self, AfW(12))
        //            .widthIs(AfW(30)).heightIs(AfW(30));
        //            [backButton addTarget:self action:@selector(zz_backButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
        //        }
        
        
    }
    return self;
}

#pragma mark - 绑定的方法
- (void)zz_backButtonClick {
    //    if (self.navigationController.viewControllers.count > 1) {
    //        [self.navigationController popViewControllerAnimated:YES];
    //    } else {
    //        [self dismissViewControllerAnimated:YES completion:nil];
    //    }
}

- (void)retryButtonClick:(UIButton *)button {
    if (self.callBack) {
        self.callBack();
    }
//    if (NETWORK) {
//        [MBManager showBriefAlert:@"网络已断开"];
//    } else {
//        //[self removeFromSuperview];
//        [MBManager showBriefAlert:@"尝试重新请求"];
//        if (self.callBack) {
//            self.callBack();
//        }
//    }
    
}

@end


@implementation ZZStatusStyle

- (instancetype)initWithSuperView:(UIView *)superView {
    if (self == [super init]) {
        self.errorCode = 0;
        /**第几次请求,设置大于1则不显示正在加载中*/
        self.requestTimes = 10;
        /**是否隐藏返回按钮*/
        self.showBackButton = NO;
        /**是否显示无数据的view*/
        self.showNoDataView = NO;
        /**网络状态view的父视图*/
        self.superView = superView;
        /**无数据view上显示图图片名*/
        self.noDataImageName = @"";
        /**无数据view上的提示文字*/
        self.noDataMessage = @"";
        /**背景颜色*/
        self.bgViewBackgorundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1];
        /**状态图片距离状态view的顶部间距*/
        self.imageTopCon = AfW(120) + 64 + ZZSafeTopHeight * 2;
    }
    return self;
}

@end
