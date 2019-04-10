//
//  ZZModel.h
//  ZZToolsDemo
//
//  Created by 刘猛 on 2019/2/3.
//  Copyright © 2019年 刘猛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZModel : NSObject

/**标题*/
@property (nonatomic ,   copy) NSString *title;

/**缓存cell的高*/
@property (nonatomic , assign) CGFloat  cellHeight;

@end

NS_ASSUME_NONNULL_END
