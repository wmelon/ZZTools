//
//  ZZStatusView.h
//  ZZToolsDemo
//
//  Created by 刘猛 on 2019/9/28.
//  Copyright © 2018 刘猛. All rights reserved.
//
//  "网络状态"的view
//

#import <UIKit/UIKit.h>

@class ZZStatusStyle;

typedef enum : NSUInteger {
    RequestStatusDefault,//默认状态,控制器刚初始化的状态
    RequestStatusRequestDefeated,//失败
    RequestStatusRequestSucceed,//成功
    RequestStatusRequesting,//请求中
    RequestStatusNoConnect,//无网络
    RequestStatusNoData,//无数据
    RequestStatusSoldOut,//已下架
    RequestStatusNoCollectionGoods,//无收藏宝贝
    RequestStatusNoCollectionShop,//无收藏店铺
    RequestStatusNoAfterSalesOrder,//无售后订单
    RequestStatusNoSystemMessage,//无系统消息
    RequestStatusNoSearchRecords,//无收藏店铺
    RequestStatusNoWithdrawalRecord,//无售后订单
    RequestStatusNoEvaluation,//无系统消息
} RequestStatus;

typedef void(^ZZStatusViewRetryCallBack)(void);

/** "网络状态"的view  */
@interface ZZStatusView : UIView

/**view的配置信息*/
@property (nonatomic, strong) ZZStatusStyle               *style;

/**要显示的类型*/
@property (nonatomic, assign) RequestStatus               status;

/**点击重试的回调*/
@property (nonatomic,   copy) ZZStatusViewRetryCallBack   callBack;

- (instancetype)initWithStyle:(ZZStatusStyle *)style status:(RequestStatus)status callBack:(ZZStatusViewRetryCallBack)callBack;

@end

/** ZZStatusView的 style */
@interface ZZStatusStyle : NSObject

/**暂时没有用到*/
@property (nonatomic, assign) int         errorCode;
/**第几次请求,设置大于1则不显示正在加载中*/
@property (nonatomic, assign) int         requestTimes;
/**是否显示返回按钮,默认隐藏*/
@property (nonatomic, assign) BOOL        showBackButton;
/**是否显示无数据的view,默认隐藏*/
@property (nonatomic, assign) BOOL        showNoDataView;
/**网络状态view的父视图,默认为控制器的self.view*/
@property (nonatomic, strong) UIView      *superView;
/**无数据view上显示图图片名,不传用默认值*/
@property (nonatomic,   copy) NSString    *noDataImageName;
/**无数据view上的提示文字,不传用默认值*/
@property (nonatomic,   copy) NSString    *noDataMessage;
/**背景颜色,不传用默认值242*/
@property (nonatomic, strong) UIColor     *bgViewBackgorundColor;
/**状态View距离父视图的顶部距离,不传用默认值0*/
@property (nonatomic, assign) CGFloat     topMargin;
/**状态图片距离状态view的顶部间距,有默认值,根据比例来的*/
@property (nonatomic, assign) CGFloat     imageTopCon;
/**记录导航条是否被隐藏*/
@property (nonatomic, assign) BOOL        navigationBarHidden;
/**网络请求完成后, 保留状态view, 默认为NO*/
@property (nonatomic, assign) BOOL        saveBgViewWhenNetworkSucceed;

- (instancetype)initWithSuperView:(UIView *)superView;

@end


