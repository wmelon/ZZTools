//
//  ZZCollectionViewCell.h
//  ZZToolsDemo
//
//  Created by 刘猛 on 2019/2/3.
//  Copyright © 2019年 刘猛. All rights reserved.
//

#import "ZZModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZCollectionViewCell : UICollectionViewCell

/**数据model*/
@property (nonatomic , strong) ZZModel  *model;

/**不以MVC的方式直接传标题*/
@property (nonatomic ,   copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
